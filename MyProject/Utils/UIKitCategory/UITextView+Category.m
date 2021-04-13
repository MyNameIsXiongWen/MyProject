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

+ (UITextView * _Nonnull (^)(CGRect))tvFrame {
    return ^(CGRect tvFrame) {
        return [[UITextView alloc] initWithFrame:tvFrame];
    };
}

- (UITextView * _Nonnull (^)(NSString * _Nonnull))tvText {
    return ^(NSString *tvText) {
        self.text = tvText;
        return self;
    };
}

- (UITextView * _Nonnull (^)(NSString * _Nonnull))tvPlaceholder {
    return ^(NSString *tvPlaceholder) {
        UILabel *label = UILabel.labelFrame(CGRectMake(5, 9, 200, 16)).labelText(tvPlaceholder).labelTitleColor(kColorFromHexString(@"bfbfbf")).labelFont(self.font);
        [label sizeToFit];
        [self addSubview:label];
        [self setValue:label forKey:@"_placeholderLabel"];
        return self;
    };
}

- (UITextView * _Nonnull (^)(UIFont * _Nonnull))tvFont {
    return ^(UIFont *tvFont) {
        self.font = tvFont;
        return self;
    };
}

- (UITextView * _Nonnull (^)(UIColor * _Nonnull))tvTextColor {
    return ^(UIColor *tvTextColor) {
        self.textColor = tvTextColor;
        return self;
    };
}


- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, @"placeholderLabel");
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, @"placeholderLabel", placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
