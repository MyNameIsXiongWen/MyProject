//
//  SideViewController.h
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideViewController : UIViewController

@property (nonatomic, copy) void (^ didSelectedIndexPath)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
