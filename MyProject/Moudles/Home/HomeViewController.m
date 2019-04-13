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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.leftNavBtn.bounds = CGRectMake(0, 0, 40, 40);
    [self.leftNavBtn setImage:UIImageMake(@"avatar") forState:0];
    XWScrollView *scroll = [[XWScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 200) ImgArray:@[@"1",@"2",@"3",@"4",@"5"].mutableCopy CurrentIndex:0];
    WEAKSELF
    scroll.selectItemBlock = ^(NSInteger index) {
        NSLog(@"======%ld",index);
        [weakSelf changeAppIconName:@"bigicon"];
    };
    [self.view addSubview:scroll];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    NSString *imgUrl = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.imageView.image = UIImageMake(imgUrl);
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    SettingViewController *settingVC = SettingViewController.new;
    settingVC.image = cell.imageView.image;
    [self.navigationController pushViewController:settingVC animated:YES];
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
        _tableView = [UITableView initWithFrame:CGRectMake(0, 264, kScreenW, kScreenH-264-49) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"HomeCell"];
    }
    return _tableView;
}

@end
