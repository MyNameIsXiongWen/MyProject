//
//  UIViewController+Category.m
//  ManKuIPad
//
//  Created by jason on 2018/9/15.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
#import "XWPushAnimation.h"
#import "XWPopAnimation.h"

@implementation UIViewController (Category)

@dynamic percentDrivenTransition;

//这里调用自身并不会产生循环调用的死循环，因为在调用时，这个方法已被替换成系统的viewWillAppear方法了。
// 重写后的viewWillAppear方法
- (void)xw_viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
    [self xw_viewWillAppear:animated];
}

// 重写后的viewWillDisappear方法
-(void)xw_viewWillDisappear:(BOOL)animated {
    [self xw_viewWillDisappear:animated];
}

// 重写后的viewDidDisappear方法
- (void)xw_viewDidDisappear:(BOOL)animated {
    [self xw_viewDidDisappear:animated];
}

// 重写后的viewDidLoad方法
- (void)xw_viewDidLoad {
    [self xw_viewDidLoad];
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
    
    UIScreenEdgePanGestureRecognizer *screenPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgPanGesture:)];
    screenPan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenPan];
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
        [self method_exchange:@selector(viewDidLoad) with:@selector(xw_viewDidLoad)];
        [self method_exchange:@selector(viewWillAppear:)with:@selector(xw_viewWillAppear:)];
        [self method_exchange:@selector(viewWillDisappear:)with:@selector(xw_viewWillDisappear:)];
        [self method_exchange:@selector(viewDidDisappear:) with:@selector(xw_viewDidDisappear:)];
        [self method_exchange:@selector(presentViewController:animated:completion:) with:@selector(xw_presentViewController:animated:completion:)];
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
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 重写后的presentViewController方法(修改app icon时用)
- (void)xw_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:UIAlertController.class]) {
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        }
    }
    [self xw_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

// 自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [XWPushAnimation new];
    }
    else if (operation == UINavigationControllerOperationPop) {
        return [XWPopAnimation new];
    }
    return nil;
}

// 手势返回
- (void)edgPanGesture:(UIScreenEdgePanGestureRecognizer *)edgPan {
    CGFloat progress = [edgPan translationInView:self.view].x/kScreenW;
    if (edgPan.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (edgPan.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }
    else if (edgPan.state == UIGestureRecognizerStateCancelled || edgPan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }
        else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:XWPopAnimation.class]) {
        return self.percentDrivenTransition ?: nil;
    }
    return nil;
}

- (UIPercentDrivenInteractiveTransition *)percentDrivenTransition {
    return objc_getAssociatedObject(self, @"percentDrivenTransitionObject");
}

- (void)setPercentDrivenTransition:(UIPercentDrivenInteractiveTransition *)percentDrivenTransition {
    objc_setAssociatedObject(self, @"percentDrivenTransitionObject", percentDrivenTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
