//
//  UIViewController+Category.h
//  ManKuIPad
//
//  Created by jason on 2018/9/15.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category) <UINavigationControllerDelegate>

//导航栏左边边按钮
@property (nonatomic, strong) UIButton *leftNavBtn;
//导航栏右边按钮
@property (nonatomic, strong) UIButton *rightNavBtn;
@property (nonatomic, strong) UIButton *rightAnotherNavBtn;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

//左侧按钮事件
- (void)leftNavBtnAction:(UIButton *)sender;
//右侧按钮事件
- (void)rightNavBtnAction:(UIButton *)sender;
//右侧按钮事件
- (void)rightAnotherNavBtnAction:(UIButton *)sender;

@end
