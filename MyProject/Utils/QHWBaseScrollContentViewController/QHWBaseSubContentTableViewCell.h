//
//  QHWBaseSubContentTableViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWPageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWBaseSubContentTableViewCell : UITableViewCell

@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, assign) BOOL fingerIsTouch;

@end

NS_ASSUME_NONNULL_END
