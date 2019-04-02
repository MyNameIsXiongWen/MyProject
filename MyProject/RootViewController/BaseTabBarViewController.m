//
//  BaseTabBarViewController.m
//  MANKUProject
//
//  Created by zhaoxiafei on 2018/6/11.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
@interface BaseTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.view.backgroundColor = UIColor.whiteColor;
    [self createChildViewControllers];
}

-(void)createChildViewControllers {
    NSArray *controllers = @[@"HomeViewController",@"MiddleViewController",@"MineViewController"];
    NSArray *icon = @[@"tab_goodsstore",@"tab_crm",@"tab_knowstore",@"tab_workspace"];
    NSArray *titleArray = @[@"AAA",@"BBB",@"CCC",@"DDD"];
    for (int i = 0; i < controllers.count; i++) {
        id vc = [NSClassFromString(controllers[i]) new];
        BaseNavigationController *navC = [[BaseNavigationController alloc]initWithRootViewController:vc];
        navC.navigationBar.tintColor = [UIColor blackColor];
        navC.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",icon[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navC.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",icon[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navC.tabBarItem.title = titleArray[i];
        [navC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.orangeColor} forState:UIControlStateSelected];
        [self addChildViewController:navC];
    }
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.backgroundColor = UIColor.whiteColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
