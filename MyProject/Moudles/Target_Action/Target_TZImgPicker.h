//
//  Target_TZImgPicker.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_TZImgPicker : NSObject

- (void)Action_nativeOnlyPhotoShowTZImagePickerViewController:(NSDictionary *)params;

- (void)Action_nativeOnlyVideoShowTZImagePickerViewController:(NSDictionary *)params;

- (void)Action_nativeShowTZImagePickerViewController:(NSDictionary *)params;

- (UICollectionViewCell *)Action_nativePublishImageCell:(NSDictionary *)params;

@end

@interface PublishImgViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIButton *button;

@property(nonatomic,copy)void(^closeAction)(void);
@end

NS_ASSUME_NONNULL_END
