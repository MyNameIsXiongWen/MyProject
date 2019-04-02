//
//  MKShadowTableViewCell.m
//  ManKu_Merchant
//
//  Created by jason on 2019/2/27.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKShadowTableViewCell.h"

@interface MKShadowTableViewCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation MKShadowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42);
            make.right.mas_equalTo(-42);
            make.top.mas_equalTo(13);
            make.bottom.mas_equalTo(-13);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView initWithFrame:CGRectZero BackgroundColor:UIColor.clearColor CornerRadius:0];
        [self.contentView addSubview:_shadowView];
        _shadowView.userInteractionEnabled = YES;
    }
    return _shadowView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView initWithFrame:CGRectZero ImageUrl:@"" Image:[UIImageMake(@"bgimg_10") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] ContentMode:UIViewContentModeScaleToFill];
        _bgImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImgView];
    }
    return _bgImgView;
}

@end
