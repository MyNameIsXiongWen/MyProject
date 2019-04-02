//
//  MKPullDownView.m
//  ManKu_Merchant
//
//  Created by jason on 2019/3/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKPullDownView.h"

static NSString *const PullDownCellIdentifier = @"PullDownCellIdentifier";
@interface MKPullDownView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation MKPullDownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-15);
            make.right.mas_equalTo(15);
            make.top.mas_equalTo(-15);
            make.bottom.mas_equalTo(15);
        }];
    }
    return self;
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PullDownCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = ColorFromHexString(@"323232");
    cell.textLabel.font = FONT_SIZE(14);
    cell.contentView.backgroundColor = UIColor.clearColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.row);
    }
    [self dismiss];
}

#pragma mark ------------ 点击事件 ----------

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.frame.size.width, 0) style:UITableViewStylePlain];
        _tableview.backgroundColor = UIColor.clearColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 40;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
        [_tableview registerClass:UITableViewCell.class forCellReuseIdentifier:PullDownCellIdentifier];
        [self addSubview:_tableview];
        UIView *headerView = [UIView initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10) BackgroundColor:UIColor.clearColor CornerRadius:0];
        _tableview.tableHeaderView = headerView;
        _tableview.tableFooterView = headerView;
    }
    return _tableview;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView initWithFrame:CGRectZero ImageUrl:@"" Image:[UIImageMake(@"bgimg_5") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] ContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_bgView];
    }
    return _bgView;
}

@end
