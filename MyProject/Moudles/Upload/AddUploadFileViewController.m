//
//  AddUploadFileViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "AddUploadFileViewController.h"
#import "QHWPermissionManager.h"
#import "CTMediator+TZImgPicker.h"
#import "QHWPhotoBrowser.h"
#import "QHWImageModel.h"
#import "UploadFileBlock.h"
#import "UploadManager.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface AddUploadFileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) NSMutableDictionary *uploadOperationQueueDict;

@end

@implementation AddUploadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightNavBtn setTitle:@"上传" forState:0];
    [self.rightAnotherNavBtn setTitle:@"草稿" forState:0];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.collectionView];
    [self handleFileSourceData];
}

- (void)handleFileSourceData {
    for (UploadFileBlock *fileBlock in self.fileSource.fileBlocks) {
        QHWImageModel *tempModel = QHWImageModel.new;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[fileBlock.fileLocalIdentifier] options:nil];
        tempModel.asset = fetchResult.firstObject;
        if (!tempModel.asset) {} //如果asset为空，说明这个文件从相册中被删除了
        tempModel.image = fileBlock.fileThumbImage;
        [self.dataArray addObject:tempModel];
    }
    [self.collectionView reloadData];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    [SVProgressHUD showInfoWithStatus:@"正在上传"];
    [self handleFileDataWithComplete:^{
        [UploadManager.sharedManager addSourceWithFileSource:self.fileSource];
        [UploadManager.sharedManager archiveUploadFileSource:self.fileSource];
    }];
}

- (void)rightAnotherNavBtnAction:(UIButton *)sender {
    [SVProgressHUD showInfoWithStatus:@"正在保存草稿"];
    [self handleFileDataWithComplete:^{
        self.fileSource.uploadStatus = FileUploadStatusDraft;
        [UploadManager.sharedManager archiveUploadFileSource:self.fileSource];
    }];
}

- (void)handleFileDataWithComplete:(void(^)(void))complete {
    if (self.dataArray.count == 0) {
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    __block NSMutableArray *fileArray = [NSMutableArray array];
    for (QHWImageModel *imgModel in self.dataArray) {
        dispatch_group_enter(group);
        if (imgModel.asset.mediaType == PHAssetMediaTypeImage) {
            [TZImageManager.manager getOriginalPhotoDataWithAsset:imgModel.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                NSString *path = [UploadFileBlock writePictureFileToDisk:data];
                UploadFileBlock *fileBlock = [[UploadFileBlock alloc] initFileBlcokAtPath:path fileId:[NSString stringWithTimeStamp] sourceId:self.fileSource.sourceId];
                fileBlock.fileLocalIdentifier = imgModel.asset.localIdentifier;
                fileBlock.fileThumbImage = imgModel.image;
                [fileArray addObject:fileBlock];
                dispatch_group_leave(group);
            }];
        } else if (imgModel.asset.mediaType == PHAssetMediaTypeVideo) {
            [TZImageManager.manager getVideoOutputPathWithAsset:imgModel.asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
                //导出完成，在这里写上传代码，通过路径或者通过NSData上传
                //如果这样写[NSData dataWithContentsOfURL:xxxx]; 文件过大，会导致内存吃紧而闪退
                //解决办法，直接移动文件到指定目录《类似剪切》
                NSString *path = [UploadFileBlock moveVideoFileAtPath:outputPath];
                UploadFileBlock *fileBlock = [[UploadFileBlock alloc] initFileBlcokAtPath:path fileId:[NSString stringWithTimeStamp] sourceId:self.fileSource.sourceId];
                fileBlock.fileLocalIdentifier = imgModel.asset.localIdentifier;
                fileBlock.fileThumbImage = imgModel.image;
                [fileArray addObject:fileBlock];
                dispatch_group_leave(group);
            } failure:^(NSString *errorMessage, NSError *error) {
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        self.fileSource.fileBlocks = fileArray;
        self.fileSource.sourceImg = [fileArray.firstObject fileThumbImage];
        complete();
        [NSNotificationCenter.defaultCenter postNotificationName:UploadFileSourceChangedNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    return [CTMediator.sharedInstance CTMediator_collectionViewCellWithIndexPath:indexPath
                                                                  CollectionView:collectionView
                                                                       ImageArray:self.dataArray ResultBlk:^{
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        [CTMediator.sharedInstance CTMediator_showTZImagePickerWithMaxCount:UploadFileMaxCount ResultBlk:^(id  _Nonnull selectedObject, UIImage * _Nullable coverImage) {
            if ([selectedObject isKindOfClass:NSArray.class]) {
                NSArray *dataArray = (NSArray *)selectedObject;
                NSArray *photos = (NSArray *)dataArray.firstObject;
                NSArray *assets = (NSArray *)dataArray.lastObject;
                for (int i=0; i<assets.count; i++) {
                    [self addImgModelWithAsset:assets[i] CoverImg:photos[i]];
                }
            } else if ([selectedObject isKindOfClass:PHAsset.class]) {
                PHAsset *asset = (PHAsset *)selectedObject;
                [self addImgModelWithAsset:asset CoverImg:coverImage];
            }
            [collectionView reloadData];
        }];
    } else {
        QHWPhotoBrowser *browser = [[QHWPhotoBrowser alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) ImgArray:self.dataArray.mutableCopy CurrentIndex:indexPath.row];
        [browser show];
    }
}

- (void)addImgModelWithAsset:(PHAsset *)asset CoverImg:(UIImage *)coverImg {
//    for (UploadFileBlock *fileBlock in self.fileSource.fileBlocks) {
//        if ([asset.localIdentifier isEqualToString:fileBlock.fileLocalIdentifier]) {
//            break;
//        }
//    }
    QHWImageModel *tempModel = QHWImageModel.new;
    tempModel.asset = asset;
    tempModel.image = coverImg;
    [self.dataArray addObject:tempModel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = UITextField.tfFrame(CGRectMake(15, 15, kScreenW-30, 40)).tfPlaceholder(@"请输入名字").tfBorderColor(kColorThemeeee).tfCornerRadius(5);
    }
    return _nameTextField;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = floor((kScreenW-60)/4);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _collectionView = [UICollectionView initWithFrame:CGRectMake(0, self.nameTextField.bottom+15, kScreenW, kScreenH-self.nameTextField.bottom-30) Layout:flowLayout Object:self];
        [_collectionView registerClass:NSClassFromString(@"PublishImgViewCell") forCellWithReuseIdentifier:@"PublishImgViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

- (NSMutableDictionary *)uploadOperationQueueDict {
    if (!_uploadOperationQueueDict) {
        _uploadOperationQueueDict = NSMutableDictionary.dictionary;
    }
    return _uploadOperationQueueDict;
}

- (UploadFileSource *)fileSource {
    if (!_fileSource) {
        _fileSource = UploadFileSource.new;
        _fileSource.sourceId = [NSString stringWithTimeStamp];
    }
    return _fileSource;
}

@end
