//
//  MKShadowCollectionViewCell.m
//  ManKu_Merchant
//
//  Created by jason on 2019/2/27.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKShadowCollectionViewCell.h"

@interface MKShadowCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation MKShadowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImgView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView initWithFrame:CGRectZero BackgroundColor:UIColor.clearColor CornerRadius:0];
        [self.contentView addSubview:_shadowView];
    }
    return _shadowView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView initWithFrame:CGRectMake(-12, -12, self.bounds.size.width+24, self.bounds.size.height+24) ImageUrl:@"" Image:[UIImageMake(@"bgimg_10") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] ContentMode:UIViewContentModeScaleToFill];
    }
    return _bgImgView;
}

@end
