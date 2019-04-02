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

@end
