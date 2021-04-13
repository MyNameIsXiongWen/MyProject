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

+ (UITextField *(^)(CGRect))tfFrame {
    return ^(CGRect tfFrame) {
        return [[UITextField alloc] initWithFrame:tfFrame];
    };
}

- (UITextField *(^)(NSString *))tfText {
    return ^(NSString *tfText) {
        self.text = tfText;
        return self;
    };
}

- (UITextField *(^)(NSString *))tfPlaceholder {
    return ^(NSString *tfPlaceholder) {
        self.placeholder = tfPlaceholder;
        return self;
    };
}

- (UITextField *(^)(UIFont *))tfFont {
    return ^(UIFont *tfFont) {
        self.font = tfFont;
        return self;
    };
}

- (UITextField *(^)(UIColor *))tfTextColor {
    return ^(UIColor *tfTextColor) {
        self.textColor = tfTextColor;
        return self;
    };
}

- (UITextField *(^)(UIColor *))tfBorderColor {
    return ^(UIColor *tfBorderColor) {
        self.layer.borderColor = tfBorderColor.CGColor;
        self.layer.borderWidth = 0.5;
        return self;
    };
}

- (UITextField *(^)(CGFloat))tfCornerRadius {
    return ^(CGFloat tfCornerRadius) {
        self.layer.cornerRadius = tfCornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

@end
