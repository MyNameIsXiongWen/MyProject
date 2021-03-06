//
//  SideViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "SideViewController.h"
#import "FaceRecognitionViewController.h"

@interface SideViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerBgView;

@end

@implementation SideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    vvv.backgroundColor = UIColor.grayColor;
    [self.view addSubview:vvv];
    [vvv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapvvv)]];
}

- (void)tapvvv {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideSideVC" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"contentOffsetY=====%f", y);
    // 控制表头图片的放大
    if (y < 0) {
        // 向下拉多少
        // 表头就向上移多少
        // 高度就增加多少
        CGFloat totalOffset = 200-y;
        CGFloat f = totalOffset / 200;
        self.headerBgView.frame = CGRectMake(-(300*f-300)*0.5, y, 300*f, totalOffset);
    } else {
        self.headerBgView.y = 0;
        self.headerBgView.height = 200;
    }
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
        FaceRecognitionViewController *faceVC = FaceRecognitionViewController.new;
        self.didSelectedIndexPath(indexPath, faceVC);
        [NSNotificationCenter.defaultCenter postNotificationName:@"HideSideVC" object:nil];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView initWithFrame:CGRectMake(0, 0, 300, kScreenH) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        [_headerView addSubview:self.headerBgView];
    }
    return _headerView;
}

- (UIImageView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [UIImageView initWithFrame:self.headerView.bounds ImageUrl:@"" Image:UIImageMake(@"登陆页") ContentMode:UIViewContentModeScaleAspectFill];
        _headerBgView.clipsToBounds = YES;
    }
    return _headerBgView;
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
