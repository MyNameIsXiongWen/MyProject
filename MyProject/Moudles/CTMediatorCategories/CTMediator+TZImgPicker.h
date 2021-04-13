//
//  CTMediator+TZImgPicker.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (TZImgPicker)

- (void)CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(NSArray <UIImage *>* photos))blk;

- (void)CTMediator_showTZImagePickerOnlyVideoWithResultBlk:(void (^)(NSURL *videoURL, UIImage * _Nullable coverImage))blk;

- (void)CTMediator_showTZImagePickerWithMaxCount:(NSInteger)maxCount ResultBlk:(void (^)(id selectedObject, UIImage * _Nullable coverImage))blk;

- (UICollectionViewCell *)CTMediator_collectionViewCellWithIndexPath:(NSIndexPath *)indexPath CollectionView:(UICollectionView *)collectionView ImageArray:(NSMutableArray *)imageArray ResultBlk:(void (^)(void))blk;

@end

NS_ASSUME_NONNULL_END
