//
//  MineViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNavBtn setImage:UIImageMake(@"") forState:0];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ------------UITableViewDelegate-------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MineTableViewCell.class)];
    cell.contentView.backgroundColor = indexPath.row%2 == 0 ? ColorFromHexString(@"f5f5f5") : UIColor.whiteColor;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView initWithFrame:CGRectZero Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:MineTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MineTableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
