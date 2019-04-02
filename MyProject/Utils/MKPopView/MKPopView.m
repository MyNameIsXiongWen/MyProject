//
//  MKPopView.m
//  ManKu_Merchant
//
//  Created by jason on 2019/3/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKPopView.h"

@interface MKPopView ()

@end

@implementation MKPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)setPopOrPush:(BOOL)popOrPush {
    _popOrPush = popOrPush;
    if (popOrPush) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
}

- (void)setShowNavView:(BOOL)showNavView {
    _showNavView = showNavView;
    [self addSubview:self.navView];
}

- (void)popView_cancel {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(MKPopView_cancelAction)]) {
        [self.delegate MKPopView_cancelAction];
    }
}

- (void)selet_navLeftBtn:(UIButton *)leftBtn navView:(MKNavView *)navView {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(MKPopView_leftAction)]) {
        [self.delegate MKPopView_leftAction];
    }
}

- (void)selet_navRightBtn:(UIButton *)leftBtn navView:(MKNavView *)navView {
    if ([self.delegate respondsToSelector:@selector(MKPopView_rightAction)]) {
        [self.delegate MKPopView_rightAction];
    }
}

#pragma mark ------------ 点击事件 ----------

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.3;
        if (self.popOrPush) {
            self.alpha = 1;
        }
        else {
            self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.bounds), 0);
        }
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        if (self.popOrPush) {
            self.alpha = 0;
        }
        else {
            self.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark ------------UI初始化-------------

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backgroundView.backgroundColor = ColorFromHexString(@"000");
        _backgroundView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popView_cancel)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

-(MKNavView *)navView {
    if (!_navView) {
        _navView = [[MKNavView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 64)];
        _navView.titleLab.text = @"";
        [_navView.leftBtn setImage:UIImageMake(@"nav_back") forState:UIControlStateNormal];
        _navView.delegate = self;
        _navView.lineView.backgroundColor = UIColor.clearColor;
        _navView.backgroundColor = UIColor.clearColor;
    }
    return _navView;
}

@end
