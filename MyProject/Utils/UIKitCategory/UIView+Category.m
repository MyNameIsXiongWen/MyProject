//
//  UIView+Category.m
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

+ (UIView *)initWithFrame:(CGRect)rect
          BackgroundColor:(UIColor *)backgroundColor
             CornerRadius:(CGFloat)radius {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backgroundColor;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    return view;
}

- (UIViewController *)getParentViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
