//
//  TakeVideoViewController.h
//  MyProject
//
//  Created by xiaobu on 2020/8/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeVideoViewController : UIViewController

@end

@interface CircleView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *strokeLayer;

@end

NS_ASSUME_NONNULL_END
