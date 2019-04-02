//
//  UILabel+Category.m
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (UILabel *)initWithFrame:(CGRect)rect
                      Text:(NSString *)text
                      Font:(UIFont *)font
                 TextColor:(UIColor *)textColor
           BackgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    return label;
}

@end
