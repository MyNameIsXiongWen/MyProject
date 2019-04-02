//
//  UIButton+Category.m
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

@implementation UIButton (Category)
static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

+ (UIButton *)initWithFrame:(CGRect)rect
                      Title:(NSString *)title
                      Image:(UIImage *)image
              SelectedImage:(UIImage *)selectedImage
                       Font:(UIFont *)font
                 TitleColor:(UIColor *)titleColor
            BackgroundColor:(UIColor *)backgroundColor
               CornerRadius:(CGFloat)radius {
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    btn.titleLabel.font = font;
    btn.backgroundColor = backgroundColor;
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    return btn;
}


- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }
    else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end
