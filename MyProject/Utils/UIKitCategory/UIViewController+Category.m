//
//  UIViewController+Category.m
//  ManKuIPad
//
//  Created by jason on 2018/9/15.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
//#import <UMMobClick/MobClick.h>

@implementation UIViewController (Category)

- (void)um_viewDidLoad {
    [self um_viewDidLoad];
    UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.bounds = CGRectMake(0, 0, 70, 40);
    [leftBtn setImage:UIImageMake(@"nav_back") forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
    [leftBtn setTitleColor:ColorFromHexString(@"323232") forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.leftNavBtn = leftBtn;
    
    UIButton *rightBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [rightBtn setTitleColor:ColorFromHexString(@"323232") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightNavBtn = rightBtn;
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
}

- (UIButton *)leftNavBtn{
    return objc_getAssociatedObject(self, @"LeftButton");
}

- (void)setLeftNavBtn:(UIButton *)leftNavBtn {
    objc_setAssociatedObject(self, @"LeftButton", leftNavBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)rightNavBtn{
    return objc_getAssociatedObject(self, @"RightButton");
}

- (void)setRightNavBtn:(UIButton *)rightNavBtn {
    objc_setAssociatedObject(self, @"RightButton", rightNavBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//左侧按钮事件
- (void)leftNavBtnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧按钮事件
- (void)rightNavBtnAction:(UIButton *)sender{
    
}

/**
 在NSObject的load方法中交换方法内容。
 先走load方法再走viewdidload
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self method_exchange:@selector(viewDidLoad) with:@selector(um_viewDidLoad)];
        [self method_exchange:@selector(viewWillAppear:)with:@selector(um_viewWillAppear:)];
        [self method_exchange:@selector(viewWillDisappear:)with:@selector(um_viewWillDisappear:)];
        [self method_exchange:@selector(viewDidDisappear:) with:@selector(um_viewDidDisappear:)];
    });
}

/**
 交换方法，将IMP部分交换
 
 @param oldMethod 旧方法
 @param newMethod 新方法
 */
+ (void)method_exchange:(SEL)oldMethod with:(SEL)newMethod{
    Class class = [self class];
    SEL originalSelector = oldMethod;
    SEL swizzledSelector = newMethod;
    
    Method originalMethod =class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod =class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success =class_addMethod(class, originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 重写后的viewWillAppear方法
 */
- (void)um_viewWillAppear:(BOOL)animated {
    //这里调用自身并不会产生循环调用的死循环，因为在调用时，这个方法已被替换成系统的viewWillAppear方法了。
    [self um_viewWillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

/**
 重写后的viewWillDisappear方法
 */
-(void)um_viewWillDisappear:(BOOL)animated {
    [self um_viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)um_viewDidDisappear:(BOOL)animated {
    [self um_viewDidDisappear:animated];
}

@end
