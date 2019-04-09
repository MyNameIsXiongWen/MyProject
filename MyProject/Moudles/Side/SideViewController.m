//
//  SideViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "SideViewController.h"
#import "SettingViewController.h"
#import "FaceRecognitionViewController.h"

@interface SideViewController () <UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    vvv.backgroundColor = UIColor.grayColor;
    [self.view addSubview:vvv];
    [vvv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapvvv)]];
}

- (void)tapvvv {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideSideVC" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectedIndexPath) {
        FaceRecognitionViewController *setting = FaceRecognitionViewController.new;
        self.didSelectedIndexPath(indexPath, setting);
        [NSNotificationCenter.defaultCenter postNotificationName:@"HideSideVC" object:nil];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView initWithFrame:CGRectZero Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        UIImageView *headerView = [UIImageView initWithFrame:CGRectMake(0, 0, kScreenW, 200) ImageUrl:@"" Image:UIImageMake(@"1") ContentMode:UIViewContentModeScaleAspectFill];
        _tableView.tableHeaderView = headerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
