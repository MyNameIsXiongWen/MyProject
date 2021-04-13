//
//  AddDownloadURLViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "AddDownloadURLViewController.h"

@interface AddDownloadURLViewController ()

@property (nonatomic, strong) UITextField *urlTextField;

@end

@implementation AddDownloadURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightNavBtn setTitle:@"下载" forState:0];
    [self.rightAnotherNavBtn setTitle:@"草稿" forState:0];
    
    self.urlTextField = UITextField.tfFrame(CGRectMake(20, kTopBarHeight+20, kScreenW-40, 40)).tfBorderColor(kColorThemeeee).tfCornerRadius(5);
    [self.view addSubview:self.urlTextField];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    self.fileSource.sourceImg = UIImageMake(@"登陆页");
    if (self.urlTextField.text.length > 0) {
        self.fileSource.sourceUrlPath = self.urlTextField.text;
    } else {
        self.fileSource.sourceUrlPath = @"https://codeload.github.com/easemob/sdkdemoapp3.0_ios/zip/sdk3.x";
//        self.fileSource.sourceUrlPath = @"https://www.bilibili.com/video/av44";
    }
    [SVProgressHUD showInfoWithStatus:@"正在下载"];
    [self handleFileDataWithComplete:^{
        [DownloadManager.sharedManager addSourceWithFileSource:self.fileSource];
        [DownloadManager.sharedManager archiveDownloadFileSource:self.fileSource];
    }];
}

- (void)rightAnotherNavBtnAction:(UIButton *)sender {
    [SVProgressHUD showInfoWithStatus:@"正在保存草稿"];
    [self handleFileDataWithComplete:^{
        self.fileSource.downloadStatus = FileDownloadStatusDraft;
        [DownloadManager.sharedManager archiveDownloadFileSource:self.fileSource];
    }];
}

- (void)handleFileDataWithComplete:(void(^)(void))complete {
    dispatch_group_t group = dispatch_group_create();
//    __block NSMutableArray *fileArray = [NSMutableArray array];
//    for (QHWImageModel *imgModel in self.dataArray) {
//        dispatch_group_enter(group);
//        if (imgModel.asset.mediaType == PHAssetMediaTypeImage) {
//            [TZImageManager.manager getOriginalPhotoDataWithAsset:imgModel.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
//                NSString *path = [UploadFileBlock writePictureFileToDisk:data];
//                UploadFileBlock *fileBlock = [[UploadFileBlock alloc] initFileBlcokAtPath:path fileId:[NSString stringWithTimeStamp] sourceId:self.fileSource.sourceId];
//                fileBlock.fileLocalIdentifier = imgModel.asset.localIdentifier;
//                fileBlock.fileThumbImage = imgModel.image;
//                [fileArray addObject:fileBlock];
//                dispatch_group_leave(group);
//            }];
//        } else if (imgModel.asset.mediaType == PHAssetMediaTypeVideo) {
//            [TZImageManager.manager getVideoOutputPathWithAsset:imgModel.asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
//                //导出完成，在这里写上传代码，通过路径或者通过NSData上传
//                //如果这样写[NSData dataWithContentsOfURL:xxxx]; 文件过大，会导致内存吃紧而闪退
//                //解决办法，直接移动文件到指定目录《类似剪切》
//                NSString *path = [UploadFileBlock moveVideoFileAtPath:outputPath];
//                UploadFileBlock *fileBlock = [[UploadFileBlock alloc] initFileBlcokAtPath:path fileId:[NSString stringWithTimeStamp] sourceId:self.fileSource.sourceId];
//                fileBlock.fileLocalIdentifier = imgModel.asset.localIdentifier;
//                fileBlock.fileThumbImage = imgModel.image;
//                [fileArray addObject:fileBlock];
//                dispatch_group_leave(group);
//            } failure:^(NSString *errorMessage, NSError *error) {
//                dispatch_group_leave(group);
//            }];
//        }
//    }
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//        self.fileSource.fileBlocks = fileArray;
//        self.fileSource.sourceImg = [fileArray.firstObject fileThumbImage];
        complete();
        [NSNotificationCenter.defaultCenter postNotificationName:DownloadFileSourceChangedNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (DownloadFileSource *)fileSource {
    if (!_fileSource) {
        _fileSource = DownloadFileSource.new;
        _fileSource.sourceId = [NSString stringWithTimeStamp];
    }
    return _fileSource;
}

@end
