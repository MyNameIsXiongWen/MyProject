//
//  UITextField+Category.m
//  MANKUProject
//
//  Created by jason on 2018/8/9.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category)

+ (UITextField *)initWithFrame:(CGRect)rect
                          Text:(NSString *)text
                   Placeholder:(NSString *)placeholder
                          Font:(UIFont *)font
                     TextColor:(UIColor *)textColor
                   BorderColor:(UIColor *)borderColor
                  CornerRadius:(CGFloat)radius {
    UITextField *textfield = [[UITextField alloc] initWithFrame:rect];
    textfield.text = text;
    textfield.placeholder = placeholder;
    textfield.font = font;
    textfield.textColor = textColor;
    textfield.layer.borderColor = borderColor.CGColor;
    textfield.layer.borderWidth = 0.5;
    textfield.layer.cornerRadius = radius;
    textfield.layer.masksToBounds = YES;
//    textfield.leftViewMode = UITextFieldViewModeAlways;
//    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
//    leftLabel.text = @"  ";
//    textfield.leftView = leftLabel;
    return textfield;
}

@end
