//
//  RootViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "RootViewController.h"
#import "SettingViewController.h"

@interface RootViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) BaseTabBarViewController *tabbarVC;
@property (nonatomic, strong) SideViewController *sideVC;

@property (nonatomic, assign) CGFloat alpha;//阴影view透明度
@property (nonatomic, assign) CGFloat rightSpace;//左侧抽出的时候距离右边的距离
@property (nonatomic, assign) CGFloat panStartOriginX;//手势的起始点

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightSpace = 75;
    self.panStartOriginX = 0;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (UIViewController *)initWithSideVC:(SideViewController *)side TabbarVC:(BaseTabBarViewController *)tabbar {
    if (self == [super initWithNibName:nil bundle:nil]) {
        self.sideVC = side;
        self.tabbarVC = tabbar;
        [self addChildViewController:side];
        [self.view addSubview:side.view];
        side.view.frame = CGRectMake((self.rightSpace-kScreenW)/2, 0, kScreenW, kScreenH);
        
        [self addChildViewController:tabbar];
        [self.view addSubview:tabbar.view];
        tabbar.view.frame = self.view.bounds;
        [tabbar.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        self.alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.alphaView.hidden = YES;
        [self.view addSubview:self.alphaView];
        
        side.didSelectedIndexPath = ^(NSIndexPath * _Nonnull indexPath) {
            SettingViewController *setting = SettingViewController.new;
            UINavigationController *nav = (UINavigationController *)self.tabbarVC.selectedViewController;
            [nav pushViewController:setting animated:YES];
        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSideVC)];
        tap.delegate = self;
        [self.alphaView addGestureRecognizer:tap];
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        self.pan.delegate = self;
        [self.view addGestureRecognizer:self.pan];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(showSideVC:) name:@"ShowSideVC" object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hideSideVC:) name:@"HideSideVC" object:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = [change[@"new"] CGRectValue];
        self.alphaView.frame = newFrame;
        self.alphaView.hidden = self.alphaView.frame.origin.x == 0;
    }
}

- (void)showSideVC:(NSNotification *)notification {
    [self showSide];
}

- (void)hideSideVC:(NSNotification *)notification {
    [self hideSide:YES];
}

- (CGFloat)getDistance {
    return kScreenW - self.rightSpace;
}

- (void)tapSideVC {
    [self hideSide:YES];
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat startPointX = [gesture locationInView:self.view].x;
        self.panStartOriginX = startPointX;
    }
    UIView *rootView = self.tabbarVC.view;
    UIView *sideView = self.sideVC.view;
    if (self.panStartOriginX >= 40 && rootView.frame.origin.x == 0) {
        return;
    }
    CGFloat translationX = [gesture translationInView:rootView].x;
    CGFloat rootViewX = rootView.frame.origin.x;
    CGFloat sideViewX = sideView.frame.origin.x;
    
    if (rootViewX + translationX < kScreenW-self.rightSpace) {
        rootViewX = rootViewX + translationX;
    }
    else {
        rootViewX = kScreenW-self.rightSpace;
    }
    if (sideViewX + translationX/2 < 0) {
        sideViewX = sideViewX + translationX/2;
    }
    else {
        sideViewX = 0;
    }
    CGRect rootViewFrame = rootView.frame;
    CGRect sideViewFrame = sideView.frame;
    rootViewFrame.origin.x = rootViewX;
    sideViewFrame.origin.x = sideViewX;
    rootView.frame = rootViewFrame;
    sideView.frame = sideViewFrame;
    
    self.alphaView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25*(rootView.frame.origin.x / (kScreenW - self.rightSpace))];
    [self.pan setTranslation:CGPointZero inView:rootView];
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (rootViewX >= [self getDistance]/2) {
            [self showSide];
        }
        else {
            [self hideSide:YES];
        }
    }
}

- (void)showSide {
    [UIView animateWithDuration:[self getAnimationDurationShow:YES] animations:^{
        CGRect rootViewFrame = self.tabbarVC.view.frame;
        CGRect sideViewFrame = self.sideVC.view.frame;
        sideViewFrame.origin.x = 0;
        rootViewFrame.origin.x = kScreenW-self.rightSpace;
        self.tabbarVC.view.frame = rootViewFrame;
        self.sideVC.view.frame = sideViewFrame;
        self.alphaView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
    }];
}

- (void)hideSide:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:[self getAnimationDurationShow:NO] animations:^{
            CGRect rootViewFrame = self.tabbarVC.view.frame;
            CGRect sideViewFrame = self.sideVC.view.frame;
            sideViewFrame.origin.x = (self.rightSpace-kScreenW)/2;
            rootViewFrame.origin.x = 0;
            self.tabbarVC.view.frame = rootViewFrame;
            self.sideVC.view.frame = sideViewFrame;
            self.alphaView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0];
        }];
    }
    else {
        CGRect rootViewFrame = self.tabbarVC.view.frame;
        CGRect sideViewFrame = self.sideVC.view.frame;
        sideViewFrame.origin.x = (self.rightSpace-kScreenW)/2;
        rootViewFrame.origin.x = 0;
        self.tabbarVC.view.frame = rootViewFrame;
        self.sideVC.view.frame = sideViewFrame;
        self.alphaView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0];
    };
}

- (CGFloat)getAnimationDurationShow:(BOOL)show {
    CGFloat timeDuration = 0.25;
    CGFloat distance = 0;
    if (show) {
        distance = [self getDistance] - self.tabbarVC.view.frame.origin.x;
    }
    else {
        distance = self.tabbarVC.view.frame.origin.x;
    }
    return distance/[self getDistance] * timeDuration;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self.tabbarVC.view name:@"frame" object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.pan) {
        NSArray *controllers = @[@"HomeViewController",@"MiddleViewController",@"MineViewController"];
        UINavigationController *nav = (UINavigationController *)self.tabbarVC.selectedViewController;
        if (![controllers containsObject:NSStringFromClass(nav.visibleViewController.class)]) {
            return NO;
        }
    }
    return YES;
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
