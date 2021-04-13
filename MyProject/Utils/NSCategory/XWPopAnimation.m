//
//  XWPopAnimation.m
//  MyProject
//
//  Created by jason on 2019/4/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "XWPopAnimation.h"

@implementation XWPopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
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
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
    fromView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    toView.frame = CGRectMake(-kScreenW, 0, kScreenW, kScreenH);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = CGRectMake(kScreenW, 0, kScreenW, kScreenH);
        toView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
