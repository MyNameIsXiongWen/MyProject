//
//  QHWBaseSubContentTableViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseSubContentTableViewCell.h"
#import "QHWBaseScrollContentViewController.h"

@implementation QHWBaseSubContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark Setter
- (void)setViewControllers:(NSMutableArray *)viewControllers {
    _viewControllers = viewControllers;
}

- (void)setCellCanScroll:(BOOL)cellCanScroll {
    _cellCanScroll = cellCanScroll;
    for (QHWBaseScrollContentViewController *VC in _viewControllers) {
        VC.vcCanScroll = cellCanScroll;
        if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
            if (VC.collectionView) {
                VC.collectionView.contentOffset = CGPointZero;
            } else {
                VC.tableView.contentOffset = CGPointZero;
            }
        }
    }
}

@end
