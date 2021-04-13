//
//  CTMediator+TZImgPicker.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator+TZImgPicker.h"

NSString * const kCTMediatorTargetTZImgPicker = @"TZImgPicker";

NSString * const kCTMediatorActionNativeOnlyPhotoShowTZImagePickerViewController = @"nativeOnlyPhotoShowTZImagePickerViewController";
NSString * const kCTMediatorActionNativeOnlyVideoShowTZImagePickerViewController = @"nativeOnlyVideoShowTZImagePickerViewController";
NSString * const kCTMediatorActionNativeShowTZImagePickerViewController = @"nativeShowTZImagePickerViewController";

NSString * const kCTMediatorActionNativePublishImageCell = @"nativePublishImageCell";

@implementation CTMediator (TZImgPicker)

- (void)CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(NSArray<UIImage *> * _Nonnull))blk {
    [self performTarget:kCTMediatorTargetTZImgPicker
                 action:kCTMediatorActionNativeOnlyPhotoShowTZImagePickerViewController
                 params:@{@"maxCount": @(maxCount),
                          @"block": blk}
      shouldCacheTarget:NO];
}

- (void)CTMediator_showTZImagePickerOnlyVideoWithResultBlk:(void (^)(NSURL * _Nonnull, UIImage * _Nullable))blk {
    [self performTarget:kCTMediatorTargetTZImgPicker
               action:kCTMediatorActionNativeOnlyVideoShowTZImagePickerViewController
               params:@{@"block": blk}
    shouldCacheTarget:NO];
}

- (void)CTMediator_showTZImagePickerWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(id _Nonnull, UIImage * _Nullable))blk {
    [self performTarget:kCTMediatorTargetTZImgPicker
               action:kCTMediatorActionNativeShowTZImagePickerViewController
               params:@{@"maxCount": @(maxCount),
                        @"block": blk}
    shouldCacheTarget:NO];
}

- (UICollectionViewCell *)CTMediator_collectionViewCellWithIndexPath:(NSIndexPath *)indexPath CollectionView:(UICollectionView *)collectionView ImageArray:(NSMutableArray *)imageArray ResultBlk:(void (^)(void))blk {
    UICollectionViewCell *cell = [self performTarget:kCTMediatorTargetTZImgPicker
                                              action:kCTMediatorActionNativePublishImageCell
                                              params:@{@"indexPath": indexPath,
                                                       @"collectionView": collectionView,
                                                       @"imageArray": imageArray,
                                                       @"block": blk}
                                   shouldCacheTarget:YES];
    if ([cell isKindOfClass:UICollectionViewCell.class]) {
        return cell;
    } else {
        return UICollectionViewCell.new;
    }
}

@end
