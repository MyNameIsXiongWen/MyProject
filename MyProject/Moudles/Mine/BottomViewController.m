//
//  BottomViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/4/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BottomViewController.h"

@interface BottomViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGFloat panStartOriginX;//手势的起始点
@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation BottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(0, 0, kScreenW, 50) Text:@"这个是title" Font:[UIFont systemFontOfSize:17] TextColor:UIColor.brownColor BackgroundColor:ColorFromHexString(@"eeeeee")];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.collectionView];
    
//    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    self.pan.delegate = self;
//    [self.view addGestureRecognizer:self.pan];
    self.cellArray = NSMutableArray.array;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        CGFloat startPointX = [gesture locationInView:self.view].x;
//        self.panStartOriginX = startPointX;
//    } else if (gesture.state == UIGestureRecognizerStateChanged) {
//        
//    }
//    [self.delegate BtmViewPanGes:gesture];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate BtmViewTouchBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate BtmViewTouchMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate BtmViewTouchEnd:touches];
}

- (void)setCellCanScroll:(BOOL)cellCanScroll {
    _cellCanScroll = cellCanScroll;
    for (DetailCollectionViewCell *cell in self.cellArray) {
        cell.cellCanScroll = cellCanScroll;
        if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
            cell.tableView.contentOffset = CGPointZero;
        }
    }
}

- (void)setTableviewOffset:(CGFloat)tableviewOffset {
    _tableviewOffset = tableviewOffset;
    for (DetailCollectionViewCell *cell in self.cellArray) {
        [cell.tableView setContentOffset:CGPointMake(0, tableviewOffset) animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(DetailCollectionViewCell.class) forIndexPath:indexPath];
    cell.cellTitle = indexPath.row % 2 == 0 ? @"影评" : @"评论";
    [self.cellArray addObject:cell];
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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.itemSize = CGSizeMake(kScreenW, kScreenH-50-64);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [UICollectionView initWithFrame:CGRectMake(0, 50, kScreenW, kScreenH-50-64) Layout:layout Object:self];
        [_collectionView registerClass:DetailCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(DetailCollectionViewCell.class)];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end

@implementation DetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.tableView = [UITableView initWithFrame:CGRectZero Style:UITableViewStylePlain Object:self];
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.cellCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        NSLog(@"subScroll======%f", scrollView.contentOffset.y);
        if (scrollView.contentOffset.y <= 0) {
            self.cellCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeSwipeLeaveTop" object:nil];//到顶通知父视图改变状态
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@====第%ld行内容", self.cellTitle, indexPath.row];
    cell.contentView.backgroundColor = Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
    return cell;
}

@end
