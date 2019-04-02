//
//  MKThumbImageCollectionViewCell.m
//  ManKu_Merchant
//
//  Created by jason on 2019/3/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKThumbImageCollectionViewCell.h"

@implementation MKThumbImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 2;
}

- (void)setItemSelected:(BOOL)itemSelected {
    if (itemSelected) {
        self.contentView.layer.borderColor = ColorFromHexString(@"ff7919").CGColor;
        self.thumgImgView.frame = CGRectMake(13, 9, 159, 117);
    }
    else {
        self.contentView.layer.borderColor = UIColor.clearColor.CGColor;
        self.thumgImgView.frame = CGRectMake(0, 0, 185, 135);
    }
}

@end
