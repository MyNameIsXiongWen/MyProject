//
//  UIView+Category.h
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

/**
 创建view

 @param rect view大小
 @param backgroundColor view背景色
 @return view
 */
+ (UIView *)initWithFrame:(CGRect)rect
          BackgroundColor:(UIColor *)backgroundColor
             CornerRadius:(CGFloat)radius;

- (UIViewController *)getParentViewController;

@end
