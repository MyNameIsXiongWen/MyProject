//
//  XWScrollView.m
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "XWScrollView.h"
#import "MKBigImageCollectionViewCell.h"

static NSString *const ImageCellIdentifier = @"imageCellIdentifier";
@interface XWScrollView () <UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL timerActivity;

@end

@implementation XWScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex {
    if (self == [super initWithFrame:frame]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [imgArray insertObject:imgArray.lastObject atIndex:0];
        [imgArray addObject:imgArray[1]];
        self.imageArray = imgArray;
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
        /// 图片总数
        self.pageControl.numberOfPages = self.imageArray.count - 2;
        self.pageControl.currentPage = currentIndex;
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        WEAKSELF
        dispatch_source_set_event_handler(self.timer, ^{
            int index = self.collectionView.contentOffset.x/kScreenW;
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            if (index == self.imageArray.count - 2) {
                [self.collectionView setContentOffset:CGPointMake(0, 0)];
                self.pageControl.currentPage = 0;
            }
            else {
                self.pageControl.currentPage = index;
            }
        });
        dispatch_resume(self.timer);
        self.timerActivity = YES;
    }
    return self;
}

#pragma mark ------------UICollectionView-------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    cell.imgView.image = UIImageMake(self.imageArray[indexPath.row]);
    cell.singltTapBlock = ^{
        if (self.selectItemBlock) {
            self.selectItemBlock(indexPath.row);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.row);
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.timerActivity) {
        self.timerActivity = NO;
        dispatch_suspend(self.timer);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"decelerate========%f",scrollView.contentOffset.x);
    int index = scrollView.contentOffset.x/kScreenW;
    if (index == 0) {
        [scrollView setContentOffset:CGPointMake((self.imageArray.count - 2) * kScreenW, 0)];
        self.pageControl.currentPage = self.imageArray.count - 3;
    }
    else if (index == self.imageArray.count - 1) {
        [scrollView setContentOffset:CGPointMake(kScreenW, 0)];
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = index-1;
    }
    if (!self.timerActivity) {
        self.timerActivity = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_resume(self.timer);
        });
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(kScreenW, 200);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [UICollectionView initWithFrame:CGRectZero Layout:layout Object:self];
        [_collectionView registerNib:[UINib nibWithNibName:@"MKBigImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ImageCellIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.enabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

@end
