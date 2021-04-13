//
//  UITextField+Category.h
//  MANKUProject
//
//  Created by jason on 2018/8/9.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Category)

+ (UITextField *)initWithFrame:(CGRect)rect
                          Text:(NSString *)text
                   Placeholder:(NSString *)placeholder
                          Font:(UIFont *)font
                     TextColor:(UIColor *)textColor
                   BorderColor:(UIColor *)borderColor
                  CornerRadius:(CGFloat)radius;

+ (UITextField *(^)(CGRect tfFrame))tfFrame;
- (UITextField *(^)(NSString *tfText))tfText;
- (UITextField *(^)(NSString *tfPlaceholder))tfPlaceholder;
- (UITextField *(^)(UIFont *tfFont))tfFont;
- (UITextField *(^)(UIColor *tfTextColor))tfTextColor;
- (UITextField *(^)(UIColor *tfBorderColor))tfBorderColor;
- (UITextField *(^)(CGFloat tfCornerRadius))tfCornerRadius;

@end
