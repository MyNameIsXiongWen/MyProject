//
//  UINavigationBar+Category.m
//  ManKu_Merchant
//
//  Created by jason on 2019/4/15.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UINavigationBar+Category.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Category)

+ (void)load {
    [super load];
    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(customlayoutSubviews));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)customlayoutSubviews {
    [self customlayoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
            for (UIView *subsubView in subview.subviews) {
                if (subsubView.x < 100) {
                    UIEdgeInsets earlyEdge = subview.layoutMargins;
                    earlyEdge.left -= 20;
                    subview.layoutMargins = earlyEdge;
                }
            }
        }
    }
}

@end
