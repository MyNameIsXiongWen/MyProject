//
//  UITextView+Category.m
//  ManKu_Merchant
//
//  Created by jason on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UITextView+Category.h"
#import <objc/runtime.h>

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
    UILabel *label = [UILabel initWithFrame:CGRectMake(5, 9, 200, 16) Text:placeholder Font:font TextColor:ColorFromHexString(@"bfbfbf") BackgroundColor:UIColor.clearColor];
    [textView addSubview:label];
    textView.placeholderLabel = label;
    return textView;
}

- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, @"placeholderLabel");
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, @"placeholderLabel", placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
