//
//  SideViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "SideViewController.h"

@interface SideViewController ()

@end

@implementation SideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    vvv.backgroundColor = UIColor.grayColor;
    [self.view addSubview:vvv];
    [vvv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapvvv)]];
}

- (void)tapvvv {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideSideVC" object:nil];
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
