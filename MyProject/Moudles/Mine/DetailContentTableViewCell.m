//
//  DetailContentTableViewCell.m
//  MyProject
//
//  Created by xiaobu on 2020/8/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DetailContentTableViewCell.h"

@implementation DetailContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bottomViewController.view];
    }
    return self;
}

#pragma mark ------------BtmVCDelegate-------------
- (void)BtmViewTouchBegan:(NSSet<UITouch *> *)touches {
//    CGFloat currentPointY = [touches.anyObject locationInView:self.view].y-20;
//    self.btmViewPanStartOriginY = currentPointY;
//    self.contentOffsetY = self.tableView.contentOffset.y;
//    self.bottomViewController.view.y = currentPointY;
}

- (void)BtmViewTouchMoved:(NSSet<UITouch *> *)touches {
//    CGFloat currentPointY = [touches.anyObject locationInView:self.view].y-20;
//    if (currentPointY < 64) {
//        currentPointY = 64;
//    } else if (currentPointY > kScreenH-50) {
//        currentPointY = kScreenH-50;
//    }
//    self.bottomViewController.view.y = currentPointY;
//    if (self.toBottom) {
//        self.tableView.y = 64-self.tableView.height+currentPointY;
//    }
}

- (void)BtmViewTouchEnd:(NSSet<UITouch *> *)touches {
}

- (BottomViewController *)bottomViewController {
    if (!_bottomViewController) {
        _bottomViewController = [[BottomViewController alloc] init];
        _bottomViewController.view.frame = CGRectMake(0, 0, kScreenW, kScreenH-64-50);
        _bottomViewController.delegate = self;
        [_bottomViewController.view addBezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight CornerSize:CGSizeMake(5, 5)];
        [self.getCurrentMethodCallerVC addChildViewController:_bottomViewController];
    }
    return _bottomViewController;
}

@end
