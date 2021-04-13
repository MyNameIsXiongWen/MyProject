//
//  QHWImageModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/24.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWImageModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageSrc;//图片地址
@property (nonatomic, assign) CGFloat imageWidth;//图片宽度
@property (nonatomic, assign) CGFloat imageHeight;//图片高度
@property (nonatomic, assign) BOOL imgSelected;

@end

NS_ASSUME_NONNULL_END
