//
//  MKPopView.h
//  ManKu_Merchant
//
//  Created by jason on 2019/3/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNavView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKPopViewDelegate <NSObject>

@optional
- (void)MKPopView_cancelAction;
- (void)MKPopView_leftAction;
- (void)MKPopView_rightAction;

@end

@interface MKPopView : UIView <MKNavViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;

///是中间pop出来的还是旁边push过来的 YES:pop   NO:push
@property (nonatomic, assign) BOOL popOrPush;

@property (nonatomic, strong) MKNavView *navView;
///显示navView
@property (nonatomic, assign) BOOL showNavView;
@property (nonatomic, weak) id <MKPopViewDelegate>delegate;
- (void)show;
- (void)dismiss;
- (void)popView_cancel;

@end

NS_ASSUME_NONNULL_END
