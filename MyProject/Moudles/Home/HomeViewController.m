//
//  HomeViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "HomeViewController.h"
#import "XWScrollView.h"
#import "SettingViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDetailView.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftNavBtn.bounds = CGRectMake(0, 0, 40, 40);
    [self.leftNavBtn setImage:UIImageMake(@"avatar") forState:0];
    [self.view addSubview:self.tableView];
}

- (void)changeAppIconName:(nullable NSString *)name {
    /*⚠️注意
     如果是更换iPad图标，要把info.plist的 Icon files (iOS 5) 改成 CFBundleIcons~ipad
     并且要修改的图片不能放assets里面
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![UIApplication sharedApplication].supportsAlternateIcons) {
            return;
        }
        NSString *iconName = [[UIApplication sharedApplication] alternateIconName];
        if (iconName) {
            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                
            }];
        }
        else {
            [[UIApplication sharedApplication] setAlternateIconName:name completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"---报错啦----:%@",error.description);
                }
            }];
        }
    });
}

- (void)leftNavBtnAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSideVC" object:nil];
}

#pragma mark ------------UITableViewDelegate-------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    NSString *imgUrl = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.imgView.image = UIImageMake(imgUrl);
    cell.name.text = [NSString stringWithFormat:@"第%ld行",indexPath.row+1];
    cell.desc.text = @"这是个啥啊  这也太好吃了吧";
    cell.price.text = [NSString stringWithFormat:@"¥ %u",arc4random()%100];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.imgView.frame toView:UIApplication.sharedApplication.keyWindow];
    UIImageView *imgView = [UIImageView initWithFrame:rect ImageUrl:nil Image:cell.imgView.image ContentMode:UIViewContentModeScaleAspectFill];
    HomeDetailView *detailView = [[HomeDetailView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
    detailView.imgView.image = cell.imgView.image;
    detailView.name.text = cell.name.text;
    detailView.desc.text = cell.desc.text;
    detailView.price.text = cell.price.text;
    [detailView showWithImg:imgView];
    cell.imgView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.imgView.hidden = NO;
    });
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
        _tableView = [UITableView initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-49-64) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 100;
        [_tableView registerClass:HomeTableViewCell.class forCellReuseIdentifier:@"HomeCell"];
        XWScrollView *scroll = [[XWScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200) ImgArray:@[@"1",@"2",@"3",@"4",@"5"].mutableCopy CurrentIndex:0];
        WEAKSELF
        scroll.selectItemBlock = ^(NSInteger index) {
            NSLog(@"======%ld",index);
//            [weakSelf changeAppIconName:@"bigicon"];
            SettingViewController *settingVC = SettingViewController.new;
//            settingVC.image = cell.imageView.image;
            [self.navigationController pushViewController:settingVC animated:YES];
        };
        _tableView.tableHeaderView = scroll;
    }
    return _tableView;
}

@end
