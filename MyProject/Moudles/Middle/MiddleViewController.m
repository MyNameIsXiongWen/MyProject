//
//  MiddleViewController.m
//  PPPPP
//
//  Created by jason on 2019/4/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MiddleViewController.h"
#import "XWChartsView.h"

@interface MiddleViewController () <CAAnimationDelegate>

@property (nonatomic, strong) XWChartsView *chartsView;

@end

@implementation MiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNavBtn setImage:UIImageMake(@"") forState:0];
    self.chartsView = [[XWChartsView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 330)];
    self.chartsView.ySplitNumber = 6;
    self.chartsView.xAxisData = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"];
    self.chartsView.chartsData = @[@"3",@"12",@"8",@"35.6",@"28",@"19"];
    [self.view addSubview:self.chartsView];
    
    UIButton *btn = [UIButton initWithFrame:CGRectMake((kScreenW-100)/2, 350, 100, 40) Title:@"变" Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:ColorFromHexString(@"ffffff") BackgroundColor:ColorFromHexString(@"ff7919") CornerRadius:5];
    [btn addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self drawWord];
}

- (void)changeData:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.chartsView.xAxisData = @[@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        self.chartsView.chartsData = @[@"14",@"9",@"27",@"16",@"20",@"13"];
    }
    else {
        self.chartsView.xAxisData = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"];
        self.chartsView.chartsData = @[@"3",@"12",@"8",@"35.6",@"28",@"19"];
    }
}

- (void)drawWord {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 2.0;
    animation.delegate = self;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = ColorFromHexString(@"ff7919").CGColor;
    lineLayer.lineWidth = 2.0f;
    [self.view.layer addSublayer:lineLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [path moveToPoint:CGPointMake(20, 400)];
    [path addLineToPoint:CGPointMake(20, 500)];
    [path moveToPoint:CGPointMake(20, 450)];
    [path addLineToPoint:CGPointMake(70, 450)];
    [path moveToPoint:CGPointMake(70, 400)];
    [path addLineToPoint:CGPointMake(70, 500)];
    
    [path moveToPoint:CGPointMake(77, 475)];
    [path addArcWithCenter:CGPointMake(102, 475) radius:25 startAngle:0 endAngle:M_PI_4 clockwise:NO];
    
    [path moveToPoint:CGPointMake(134, 400)];
    [path addLineToPoint:CGPointMake(134, 475)];
    [path addArcWithCenter:CGPointMake(159, 475) radius:25 startAngle:M_PI endAngle:M_PI_4 clockwise:NO];
    
    [path moveToPoint:CGPointMake(191, 400)];
    [path addLineToPoint:CGPointMake(191, 475)];
    [path addArcWithCenter:CGPointMake(216, 475) radius:25 startAngle:M_PI endAngle:M_PI_4 clockwise:NO];
    
    [path moveToPoint:CGPointMake(273, 450)];
    [path addArcWithCenter:CGPointMake(273, 475) radius:25 startAngle:M_PI_2*3 endAngle:0 clockwise:NO];
    [path addArcWithCenter:CGPointMake(273, 475) radius:25 startAngle:0 endAngle:M_PI_2*3 clockwise:NO];
    
    [path moveToPoint:CGPointMake(325, 400)];
    [path addLineToPoint:CGPointMake(325, 480)];
    
    [path moveToPoint:CGPointMake(325, 495)];
    [path addLineToPoint:CGPointMake(325, 500)];
    
    lineLayer.path = path.CGPath;
    [lineLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"=====animationDidStop");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
