//
//  MiddleViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MiddleViewController.h"
#import "XWScrollView.h"

@interface MiddleViewController ()

@end

@implementation MiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XWScrollView *scroll = [[XWScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 200) ImgArray:@[@"1",@"2",@"3",@"4",@"5"].mutableCopy CurrentIndex:0];
    scroll.selectItemBlock = ^(NSInteger index) {
        NSLog(@"======%d",index);
    };
    [self.view addSubview:scroll];
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
