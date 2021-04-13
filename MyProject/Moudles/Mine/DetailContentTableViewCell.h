//
//  DetailContentTableViewCell.h
//  MyProject
//
//  Created by xiaobu on 2020/8/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailContentTableViewCell : UITableViewCell <BtmVCDelegate>

@property (nonatomic, strong) BottomViewController *bottomViewController;

@end

NS_ASSUME_NONNULL_END
