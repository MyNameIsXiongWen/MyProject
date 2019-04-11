//
//  XWChartsView.h
//  MyProject
//
//  Created by jason on 2019/4/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWChartsView : UIView

@property (nonatomic, assign) NSInteger ySplitNumber;
@property (nonatomic, strong) NSArray *xAxisData;
@property (nonatomic, strong) NSArray *chartsData;

@end

NS_ASSUME_NONNULL_END
