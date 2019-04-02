//
//  MKNavView.m
//  ManKuIPad
//
//  Created by YKK on 2018/1/27.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "MKNavView.h"

@implementation MKNavView

#pragma mark ---------------------------------- Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.hidden = NO;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        [self addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(leftBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.width.greaterThanOrEqualTo(@20);
        }];
       [_leftBtn setHitTestEdgeInsets:UIEdgeInsetsMake(44, -44, 44, -44)];
    }
    return _leftBtn;
}
- (void)leftBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(selet_navLeftBtn:navView:)]) {
        [_delegate selet_navLeftBtn:sender navView:self];
    }
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        [self addSubview:_titleLab];
        _titleLab.text = @"";
        _titleLab.textColor = ColorFromHexString(@"323232");
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    return _titleLab;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [self addSubview:_rightBtn];
        [_rightBtn setTitle:@"右btn"
                   forState:UIControlStateNormal];
        [_rightBtn addTarget:self
                      action:@selector(rightBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.width.equalTo(@70);
        }];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightBtn;
}
- (void)rightBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(selet_navRightBtn:navView:)]) {
        [_delegate selet_navRightBtn:sender navView:self];
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView  = [[UIView alloc]init];
        [self addSubview:_lineView];
        _lineView.backgroundColor = ColorFromHexString(@"f5f5f5");
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _lineView;
}
@end
