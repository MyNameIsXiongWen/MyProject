//
//  UITextView+Category.m
//  ManKu_Merchant
//
//  Created by jason on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UITextView+Category.h"

@implementation UITextView (Category)

+ (UITextView *)initWithFrame:(CGRect)rect
                         Text:(NSString *)text
                  Placeholder:(NSString *)placeholder
                         Font:(UIFont *)font
                    TextColor:(UIColor *)textColor {
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.text = text;
    textView.font = font;
    textView.textColor = textColor;
    UILabel *placeholderLabel = [UILabel initWithFrame:CGRectMake(5, 9, 200, 16) Text:placeholder Font:font TextColor:ColorFromHexString(@"bfbfbf") BackgroundColor:UIColor.clearColor];
    placeholderLabel.tag = 111;
    [textView addSubview:placeholderLabel];
    return textView;
}

@end
