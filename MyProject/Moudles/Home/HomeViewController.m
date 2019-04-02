//
//  HomeViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    vvv.backgroundColor = UIColor.orangeColor;
    vvv.userInteractionEnabled = YES;
    [self.view addSubview:vvv];
    [vvv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapvvv)]];
}

- (void)tapvvv {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSideVC" object:nil];
//    UIViewController *vvv = (UIViewController *)[NSClassFromString(@"ViewController") new];
//    [self.navigationController pushViewController:vvv animated:YES];
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
