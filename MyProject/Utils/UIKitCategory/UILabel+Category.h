//
//  UILabel+Category.h
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 创建UILabel

 @param rect frame
 @param text text
 @param font font
 @param textColor textcolor
 @return label
 */
+ (UILabel *)initWithFrame:(CGRect)rect
                      Text:(NSString *)text
                      Font:(UIFont *)font
                 TextColor:(UIColor *)textColor
           BackgroundColor:(UIColor *)backgroundColor;

@end
