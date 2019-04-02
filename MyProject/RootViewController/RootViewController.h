//
//  RootViewController.h
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideViewController.h"
#import "BaseTabBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootViewController : UIViewController

- (UIViewController *)initWithSideVC:(SideViewController *)side TabbarVC:(BaseTabBarViewController *)tabbar;

@end

NS_ASSUME_NONNULL_END
