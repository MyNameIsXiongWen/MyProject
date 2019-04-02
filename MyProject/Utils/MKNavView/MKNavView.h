//
//  MKNavView.h
//  ManKuIPad
//
//  Created by YKK on 2018/1/27.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MKNavView;
@protocol MKNavViewDelegate <NSObject>
@optional
- (void)selet_navLeftBtn:(UIButton *)leftBtn navView:(MKNavView *)navView;
- (void)selet_navRightBtn:(UIButton *)leftBtn navView:(MKNavView *)navView;
@end

@interface MKNavView : UIView
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, weak) id<MKNavViewDelegate>delegate;

@end
