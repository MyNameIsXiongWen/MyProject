//
//  UIImageView+Category.h
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)

/**
 创建UIImageView

 @param rect 图片大小
 @param imageUrl 图片地址
 @param image 默认图片
 @param mode 显示类型
 @return 图片视图
 */
+ (UIImageView *)initWithFrame:(CGRect)rect
                      ImageUrl:(NSString *)imageUrl
                         Image:(UIImage *)image
                   ContentMode:(UIViewContentMode)mode;

+ (UIImageView *(^)(void))ivInit;
+ (UIImageView *(^)(CGRect ivFrame))ivFrame;
- (UIImageView *(^)(UIColor *color))ivBkgColor;
- (UIImageView *(^)(UIImage *ivImage))ivImage;
- (UIImageView *(^)(UIViewContentMode ivMode))ivMode;
///最好先调用ivImage
- (UIImageView *(^)(NSString *ivImageUrl))ivImageUrl;
- (UIImageView *(^)(CGFloat ivCornerRadius))ivCornerRadius;
- (UIImageView *(^)(UIColor *tfBorderColor))ivBorderColor;

@end
