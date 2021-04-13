//
//  UIButton+Category.h
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

/**
 创建Button

 @param rect rect
 @param title title
 @param image image
 @param selectedImage selectedImage
 @param font font
 @param titleColor titleColor
 @return btn
 */
+ (UIButton *)initWithFrame:(CGRect)rect
                      Title:(NSString *)title
                      Image:(UIImage *)image
              SelectedImage:(UIImage *)selectedImage
                       Font:(UIFont *)font
                 TitleColor:(UIColor *)titleColor
            BackgroundColor:(UIColor *)backgroundColor
               CornerRadius:(CGFloat)radius;


+ (UIButton *(^)(void))btnInit;
+ (UIButton *(^)(CGRect btnFrame))btnFrame;
- (UIButton *(^)(NSString *btnTitle))btnTitle;
- (UIButton *(^)(NSString *btnSelectedTitle))btnSelectedTitle;
- (UIButton *(^)(UIImage *btnImage))btnImage;
- (UIButton *(^)(UIImage *btnSelectedImage))btnSelectedImage;
- (UIButton *(^)(UIFont *btnFont))btnFont;
- (UIButton *(^)(UIColor *btnTitleColor))btnTitleColor;
- (UIButton *(^)(UIColor *btnBkgColor))btnBkgColor;
- (UIButton *(^)(CGFloat btnCornerRadius))btnCornerRadius;
- (UIButton *(^)(UIColor *tfBorderColor))btnBorderColor;
- (UIButton *(^)(id target, SEL btnSEL))btnAction;

/**
 扩展button的点击范围
 [hidePasswordBtn setHitTestEdgeInsets:UIEdgeInsetsMake(44, -44, 44, -44)];
 @param hitTestEdgeInsets 传入的范围
 */

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
