//
//  XWPushAnimation.m
//  MyProject
//
//  Created by jason on 2019/4/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "XWPushAnimation.h"

@implementation XWPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = nil;
    UIView *toView = nil;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        fromView = fromVC.view;
        toView = toVC.view;
    }
    [[transitionContext containerView] addSubview:toView];
    toView.frame = CGRectMake(kScreenW, 0, kScreenW, kScreenH);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        fromView.frame = CGRectMake(-kScreenW, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
