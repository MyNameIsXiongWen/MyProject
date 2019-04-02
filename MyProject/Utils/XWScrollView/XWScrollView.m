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
@property (nonatomic, strong) NSMutableArray *imageArray;

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
        [imgArray insertObject:imgArray.lastObject atIndex:0];
        [imgArray addObject:imgArray[1]];
        self.imageArray = imgArray;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
        
    };
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x/kScreenW;
    if (index == 0) {
        [scrollView setContentOffset:CGPointMake((self.imageArray.count - 2) * kScreenW, 0)];
    }
    else if (index == self.imageArray.count - 1) {
        [scrollView setContentOffset:CGPointMake(kScreenW, 0)];
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

@end
