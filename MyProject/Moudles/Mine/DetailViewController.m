//
//  DetailViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/4/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DetailViewController.h"
#import "BottomViewController.h"
#import "DetailContentTableViewCell.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource, BtmVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BottomViewController *bottomViewController;
@property (nonatomic, assign) BottomViewState btmViewState;
@property (nonatomic, assign) CGFloat btmViewPanStartOriginY;//手势的起始点
@property (nonatomic, assign) CGFloat contentOffsetY;

@property (nonatomic, assign) CGFloat startContentOffsetY;
@property (nonatomic, assign) CGFloat endContentOffsetY;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL toBottom;
@property (nonatomic, assign) CGFloat velocityY;

@property (nonatomic, strong) DetailContentTableViewCell *contentCell;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomViewController.view];
    self.btmViewState = BottomViewStateCollapse;
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatusNotification) name:@"HomeSwipeLeaveTop" object:nil];
}

- (void)changeScrollStatusNotification {//改变主视图的状态
    self.canScroll = YES;
//    self.bottomViewController.cellCanScroll = NO;
    self.contentCell.bottomViewController.cellCanScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = 800;
    if (contentOffsetY >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.bottomViewController.cellCanScroll = YES;
        }
    } else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    
    return;
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"contentOffsetY====%f", contentOffsetY);
//    CGFloat contentSizeH = self.tableView.contentSize.height;
//    CGFloat tableH = self.tableView.height;
//    //列表可位移的距离
//    CGFloat totalValiableOffset = contentSizeH-tableH;
//    if (contentOffsetY < totalValiableOffset) {
//        self.toBottom = NO;
//        self.btmViewState = BottomViewStateCollapse;
//    } else if (contentOffsetY > contentSizeH-64) {
//        self.toBottom = YES;
//        self.btmViewState = BottomViewStateExtend;
//    } else {
//        self.toBottom = YES;
//        self.btmViewState = BottomViewStateScrolling;
//    }
//    NSLog(@"==========%lu", (unsigned long)self.btmViewState);
////    if (self.btmViewState == BottomViewStateExtend) {
////        self.bottomViewController.view.y = 64;
////    } else {
////        if (self.btmViewState == BottomViewStateScrolling) {
////            CGFloat btmViewOffsetY = contentOffsetY - (totalValiableOffset);
////            NSLog(@"btmViewOffsetY====%f", btmViewOffsetY);
////            self.bottomViewController.view.y = kScreenH-50-btmViewOffsetY;
////        }
////    }
//    if (contentOffsetY >= totalValiableOffset) {
//        scrollView.contentOffset = CGPointMake(0, totalValiableOffset);
//        if (self.canScroll) {
//            self.canScroll = NO;
//            self.bottomViewController.cellCanScroll = YES;
//        }
//        //松手时根据速度算出大概要滑动的距离
//        CGFloat finalY = self.velocityY * 500;
//        //已经滑了的距离
//        CGFloat offseted = fabs(self.endContentOffsetY-self.startContentOffsetY);
//        if (finalY > offseted) {
//            //剩下要模拟的位移距离
//            CGFloat restOffset = finalY-offseted;
//            CGFloat targetOffset = MIN(restOffset, kScreenH-50-64);
//            CGFloat time = 0;
//            if (restOffset > kScreenH-50-64) {
//                time = (kScreenH-50-64)/finalY;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1-time) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    self.bottomViewController.tableviewOffset = restOffset - (kScreenH-50-64);
//                });
//            } else {
//                time = restOffset/finalY;
//            }
//            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{ //slideFactor秒内做完改变center的动画，动画效果快进慢出（先快后慢）
//                self.tableView.y = -targetOffset;
//                self.bottomViewController.view.y = kScreenH-50-targetOffset;
//            } completion:nil];
//        }
//    } else {
//        if (!self.canScroll) {//子视图没到顶部
//            scrollView.contentOffset = CGPointMake(0, totalValiableOffset);
//        }
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"velocity====%f", velocity.y);
    self.velocityY = velocity.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.endContentOffsetY = scrollView.contentOffset.y;
    NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"DidEndScrolling===%f", scrollView.contentOffset.y);
}

#pragma mark ------------BtmVCDelegate-------------
- (void)BtmViewTouchBegan:(NSSet<UITouch *> *)touches {
    CGFloat currentPointY = [touches.anyObject locationInView:self.view].y-20;
    self.btmViewPanStartOriginY = currentPointY;
    self.contentOffsetY = self.tableView.contentOffset.y;
    self.bottomViewController.view.y = currentPointY;
}

- (void)BtmViewTouchMoved:(NSSet<UITouch *> *)touches {
    CGFloat currentPointY = [touches.anyObject locationInView:self.view].y-20;
    if (currentPointY < 64) {
        currentPointY = 64;
    } else if (currentPointY > kScreenH-50) {
        currentPointY = kScreenH-50;
    }
    self.bottomViewController.view.y = currentPointY;
    if (self.toBottom) {
        self.tableView.y = 64-self.tableView.height+currentPointY;
    }
}

- (void)BtmViewTouchEnd:(NSSet<UITouch *> *)touches {
    CGFloat currentPointY = [touches.anyObject locationInView:self.view].y-20;
    CGFloat distance = fabs(currentPointY-self.btmViewPanStartOriginY);
    CGFloat resultY = 64;
    if (distance >= (kScreenH-50-64)/2) {
        if (self.btmViewState == BottomViewStateExtend) {
            resultY = kScreenH-50;
            self.btmViewState = BottomViewStateCollapse;
        } else if (self.btmViewState == BottomViewStateCollapse) {
            resultY = 64;
            self.btmViewState = BottomViewStateExtend;
        } else {
            if (currentPointY > self.btmViewPanStartOriginY) {
                resultY = kScreenH-50;
                self.btmViewState = BottomViewStateCollapse;
            } else {
                resultY = 64;
                self.btmViewState = BottomViewStateExtend;
            }
        }
    } else {
        if (self.btmViewState == BottomViewStateExtend) {
            resultY = 64;
        } else if (self.btmViewState == BottomViewStateCollapse) {
            resultY = kScreenH-50;
        } else {
            if (currentPointY > self.btmViewPanStartOriginY) {
                resultY = 64;
                self.btmViewState = BottomViewStateExtend;
            } else {
                resultY = kScreenH-50;
                self.btmViewState = BottomViewStateCollapse;
            }
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewController.view.y = resultY;
        if (self.toBottom) {
            if (self.btmViewState == BottomViewStateExtend) {
                self.tableView.y = 64-self.tableView.height;
            } else {
                self.tableView.y = 64;
            }
        }
    }];
}

- (void)BtmViewContentOffset:(CGFloat)contentOffset {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < 4 ? 200 : (kScreenH-50-64);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.backgroundColor = Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
        return cell;
    }
    DetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DetailContentTableViewCell.class)];
    return cell;
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
        _tableView = [UITableView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-50) Style:UITableViewStylePlain Object:self];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView registerClass:DetailContentTableViewCell.class forCellReuseIdentifier:NSStringFromClass(DetailContentTableViewCell.class)];
    }
    return _tableView;
}

- (BottomViewController *)bottomViewController {
    if (!_bottomViewController) {
        _bottomViewController = [[BottomViewController alloc] init];
        _bottomViewController.view.frame = CGRectMake(0, kScreenH-50, kScreenW, kScreenH-64);
        _bottomViewController.delegate = self;
        [_bottomViewController.view addBezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight CornerSize:CGSizeMake(5, 5)];
        [self addChildViewController:_bottomViewController];
    }
    return _bottomViewController;
}

@end
