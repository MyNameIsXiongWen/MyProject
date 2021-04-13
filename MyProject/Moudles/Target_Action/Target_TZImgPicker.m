//
//  Target_TZImgPicker.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "Target_TZImgPicker.h"
#import "TZImagePickerController.h"
#import "QHWPermissionManager.h"
#import "QHWImageModel.h"
#import "UploadFileConstant.h"

@interface Target_TZImgPicker ()

@end

@implementation Target_TZImgPicker

- (void)Action_nativeOnlyPhotoShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            NSInteger count = [params[@"maxCount"] integerValue];
            __block void (^blk)(NSArray<UIImage *> *photos) = params[@"block"];
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.maxImagesCount = count;
            imagePickerVC.allowPickingVideo = NO;
            imagePickerVC.allowPickingGif = NO;
            [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (blk) {
                    blk(photos);
                }
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

- (void)Action_nativeOnlyVideoShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.preferredLanguage = @"zh-Hans";
            imagePickerVC.iconThemeColor = UIColor.greenColor;
            imagePickerVC.showPhotoCannotSelectLayer = YES;
            imagePickerVC.showSelectedIndex = YES;
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowPickingMultipleVideo = NO;
            imagePickerVC.allowPickingImage = NO;
            __block void (^blk)(NSURL *videoUrl, UIImage * _Nullable coverImage) = params[@"block"];
            [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
                    if (blk) {
                        blk(urlAsset.URL, coverImage);
                    }
                }];
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

- (void)Action_nativeShowTZImagePickerViewController:(NSDictionary *)params {
    [QHWPermissionManager openAlbumService:^(BOOL isOpen) {
        if (isOpen) {
            NSInteger count = [params[@"maxCount"] integerValue];
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] init];
            imagePickerVC.maxImagesCount = count;
            imagePickerVC.preferredLanguage = @"zh-Hans";
            imagePickerVC.iconThemeColor = UIColor.greenColor;
            imagePickerVC.showPhotoCannotSelectLayer = YES;
            imagePickerVC.showSelectedIndex = YES;
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowPickingMultipleVideo = NO;
//            imagePickerVC.photoWidth = floor((kScreenW-60)/3.0);
            __block void (^blk)(id selectedObject, UIImage * _Nullable coverImage) = params[@"block"];
            [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (blk) {
                    blk(@[photos, assets], photos.firstObject);
                }
//                if (blk) {
//                    blk(photos, nil);
//                }
            }];
            [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                if (blk) {
                    blk(asset, coverImage);
                }
//                [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
//                    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
//                    if (blk) {
//                        blk(urlAsset.URL, coverImage);
//                    }
//                }];
            }];
            imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.getCurrentMethodCallerVC presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }];
}

- (UICollectionViewCell *)Action_nativePublishImageCell:(NSDictionary *)params {
    UICollectionView *collectionView = params[@"collectionView"];
    NSIndexPath *indexPath = params[@"indexPath"];
    NSMutableArray *imageArray = params[@"imageArray"];
    void (^blk)(void) = params[@"block"];
    PublishImgViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PublishImgViewCell.class) forIndexPath:indexPath];
    cell.closeAction = blk;
    if (imageArray.count < UploadFileMaxCount) {
        if (indexPath.row == imageArray.count) {
            cell.button.hidden = YES;
            cell.bgImageView.image = [UIImage imageNamed:@"publish_add"];
            return cell;
        }
    }
    QHWImageModel *model = imageArray[indexPath.row];
    cell.bgImageView.image = model.image;
    cell.button.hidden = NO;
    return cell;
}

@end

@implementation PublishImgViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}
-(void)handleButtoAction:(UIButton *)button
{
    if (self.closeAction) {
        self.closeAction();
    }
}
-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, self.width - 7.5, self.height - 7.5)];
    }
    return _bgImageView;
}
-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.width - 15, 0, 15, 15);
        [_button setImage:[UIImage imageNamed:@"publish_close"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(handleButtoAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    }
    return _button;
}

@end
