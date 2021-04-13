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

+ (UILabel *(^)(void))labelInit {
    return ^(void) {
        return [[UILabel alloc] init];
    };
}

+ (UILabel *(^)(CGRect))labelFrame {
    return ^(CGRect labelFrame) {
        return [[UILabel alloc] initWithFrame:labelFrame];
    };
}

- (UILabel *(^)(NSString *))labelText {
    return ^(NSString *labelText) {
        self.text = labelText;
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelTitleColor {
    return ^(UIColor *labelTitleColor) {
        self.textColor = labelTitleColor;
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelBkgColor {
    return ^(UIColor *labelBkgColor) {
        self.backgroundColor = labelBkgColor;
        return self;
    };
}

- (UILabel *(^)(NSInteger))labelNumberOfLines {
    return ^(NSInteger number) {
        self.numberOfLines = number;
        return self;
    };
}

- (UILabel *(^)(UIFont *))labelFont {
    return ^(UIFont *labelFont) {
        self.font = labelFont;
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment ))labelTextAlignment {
    return ^(NSTextAlignment alignment) {
        self.textAlignment = alignment;
        return self;
    };
}

- (UILabel *(^)(BOOL))labelCopyEnable {
    return ^(BOOL labelCopyEnable) {
        self.userInteractionEnabled = labelCopyEnable;
        if (labelCopyEnable) {
            UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
            [self addGestureRecognizer:longpress];
        }
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelBorderColor {
    return ^(UIColor *labelBorderColor) {
        self.layer.borderColor = labelBorderColor.CGColor;
        self.layer.borderWidth = 0.5;
        return self;
    };
}

- (UILabel *(^)(CGFloat))labelCornerRadius {
    return ^(CGFloat labelCornerRadius) {
        self.layer.cornerRadius = labelCornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

- (void)longPressGes:(UILongPressGestureRecognizer *)recognizer {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (!menu.isMenuVisible) {
        if ([self becomeFirstResponder]) {
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
            menu.menuItems = @[item1];
            [menu setTargetRect:self.bounds inView:self];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyText:)) {
        return YES;
    }
    return NO;
}

- (void)copyText:(UIMenuController *)menu {
    if (!self.text) return;
    UIPasteboard.generalPasteboard.string = self.text;
    [SVProgressHUD showInfoWithStatus:@"已复制到粘贴板"];
}

@end
