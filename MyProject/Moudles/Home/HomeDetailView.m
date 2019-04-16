//
//  HomeDetailView.m
//  MyProject
//
//  Created by jason on 2019/4/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "HomeDetailView.h"

@implementation HomeDetailView

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
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.imgView];
    [self addSubview:self.name];
    [self addSubview:self.desc];
    [self addSubview:self.price];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn = [UIButton initWithFrame:CGRectMake(20, 30, 60, 40) Title:@"返回" Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:ColorFromHexString(@"ff2a2a") BackgroundColor:UIColor.whiteColor CornerRadius:0];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    });
}

- (void)showWithImg:(UIImageView *)imgView {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [[UIApplication sharedApplication].delegate.window addSubview:imgView];
    [UIView animateWithDuration:0.5 animations:^{
        imgView.frame = CGRectMake(0, 0, kScreenW, 300);
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.bounds));
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
        self.imgView.hidden = NO;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView initWithFrame:CGRectMake(0, 0, kScreenW, 300) ImageUrl:@"" Image:nil ContentMode:UIViewContentModeScaleAspectFill];
        _imgView.hidden = YES;
    }
    return _imgView;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel initWithFrame:CGRectMake(20, 310, kScreenW-40, 30) Text:@"" Font:FONT_SIZE(20) TextColor:ColorFromHexString(@"333333") BackgroundColor:UIColor.clearColor];
    }
    return _name;
}

- (UILabel *)desc {
    if (!_desc) {
        _desc = [UILabel initWithFrame:CGRectMake(20, 350, kScreenW-40, 20) Text:@"" Font:FONT_SIZE(14) TextColor:ColorFromHexString(@"7d7d7d") BackgroundColor:UIColor.clearColor];
    }
    return _desc;
}

- (UILabel *)price {
    if (!_price) {
        _price = [UILabel initWithFrame:CGRectMake(20, 370, kScreenW-40, 30) Text:@"" Font:FONT_SIZE(20) TextColor:ColorFromHexString(@"ff2a2a") BackgroundColor:UIColor.clearColor];
    }
    return _price;
}

@end
