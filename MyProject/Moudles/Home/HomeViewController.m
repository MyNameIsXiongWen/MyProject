//
//  HomeViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "HomeViewController.h"
#import "XWScrollView.h"

@interface HomeViewController ()

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
    scroll.selectItemBlock = ^(NSInteger index) {
        NSLog(@"======%d",index);
    };
    [self.view addSubview:scroll];
}

- (void)leftNavBtnAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSideVC" object:nil];
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
