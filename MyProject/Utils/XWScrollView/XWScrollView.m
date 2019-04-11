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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.row);
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
