//
//  HomeTableViewCell.m
//  MyProject
//
//  Created by jason on 2019/4/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView initWithFrame:CGRectMake(10, 10, 80, 80) ImageUrl:@"" Image:nil ContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel initWithFrame:CGRectMake(100, 10, kScreenW-120, 15) Text:@"" Font:FONT_SIZE(15) TextColor:ColorFromHexString(@"333333") BackgroundColor:UIColor.clearColor];
        [self.contentView addSubview:_name];
    }
    return _name;
}

- (UILabel *)desc {
    if (!_desc) {
        _desc = [UILabel initWithFrame:CGRectMake(100, 35, kScreenW-120, 15) Text:@"" Font:FONT_SIZE(12) TextColor:ColorFromHexString(@"7d7d7d") BackgroundColor:UIColor.clearColor];
        [self.contentView addSubview:_desc];
    }
    return _desc;
}

- (UILabel *)price {
    if (!_price) {
        _price = [UILabel initWithFrame:CGRectMake(100, 65, kScreenW-120, 25) Text:@"" Font:FONT_SIZE(18) TextColor:ColorFromHexString(@"ff2a2a") BackgroundColor:UIColor.clearColor];
        [self.contentView addSubview:_price];
    }
    return _price;
}

@end
