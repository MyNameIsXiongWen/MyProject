//
//  MineTableViewCell.m
//  MyProject
//
//  Created by jason on 2019/4/17.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MineTableViewCell.h"
#import "MineSubTableViewCell.h"

@interface MineTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MineTableViewCell

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
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataCount:(NSInteger)dataCount {
    _dataCount = dataCount;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tableView.contentSize.height);
    }];
}

#pragma mark ------------UITableViewDelegate-------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MineSubTableViewCell.class)];
    NSString *imgUrl = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.imageView.image = UIImageMake(imgUrl);
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row+1];
    cell.detailTextLabel.text = @"这是个啥啊  这也太好吃了吧";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"DetailViewController").new animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView initWithFrame:CGRectZero Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 60;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:MineSubTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MineSubTableViewCell.class)];
        _tableView.backgroundColor = ColorFromHexString(@"ff7919");
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

@end
