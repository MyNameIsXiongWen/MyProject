//
//  MKBigImageView.m
//  MANKUProject
//
//  Created by jason on 2019/1/11.
//  Copyright © 2019年 MANKU. All rights reserved.
//

#import "MKBigImageView.h"
#import "MKBigImageCollectionViewCell.h"
#import "MKThumbImageCollectionViewCell.h"

static NSString *const ImageCellIdentifier = @"imageCellIdentifier";
static NSString *const ThumbImageCellIdentifier = @"ThumbImageCellIdentifier";
@interface MKBigImageView () <UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *thumbCollectionView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MKBigImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (MKBigImageView *)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = currentIndex;
        [self handleImgWithData:imgArray];
        [self.collectionView reloadData];
        [self.thumbCollectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self.thumbCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        self.tagLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)currentIndex+1, (unsigned long)imgArray.count];
    }
    return self;
}

- (void)handleImgWithData:(NSMutableArray *)array {
    for (NSString *str in array) {
        MKImageModel *model = MKImageModel.new;
        model.imgUrl = str;
        model.imgSelected = self.currentIndex == [array indexOfObject:str];
        [self.imageArray addObject:model];
    }
}

#pragma mark ------------UICollectionView-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKImageModel *model = self.imageArray[indexPath.row];
    if (collectionView.tag == 111) {
        MKBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:@""];
        cell.singltTapBlock = ^{
            [self dismiss];
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        };
        return cell;
    }
    else {
        MKThumbImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ThumbImageCellIdentifier forIndexPath:indexPath];
        [cell.thumgImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:@""];
        cell.itemSelected = model.imgSelected;
        return cell;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 111) {
        int a = scrollView.contentOffset.x/kScreenW;
        if (self.currentIndex == a) {
            return;
        }
        MKImageModel *oldmodel = self.imageArray[self.currentIndex];
        oldmodel.imgSelected = NO;
        [self.thumbCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentIndex inSection:0]]];
        
        self.tagLabel.text = [NSString stringWithFormat:@"%d / %lu", a+1, (unsigned long)self.imageArray.count];
        self.currentIndex = a;
        
        MKImageModel *newmodel = self.imageArray[self.currentIndex];
        newmodel.imgSelected = YES;
        [self.thumbCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentIndex inSection:0]]];
        [self.thumbCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 111) {
        [self dismiss];
    }
    else if (collectionView.tag == 999) {
        if (self.currentIndex == indexPath.row) {
            return;
        }
        MKImageModel *oldmodel = self.imageArray[self.currentIndex];
        oldmodel.imgSelected = NO;
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentIndex inSection:0]]];
        
        self.currentIndex = indexPath.row;
        
        MKImageModel *newmodel = self.imageArray[self.currentIndex];
        newmodel.imgSelected = YES;
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentIndex inSection:0]]];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)dismiss {
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark ------------UI初始化-------------
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backgroundView.backgroundColor = Color(0, 0, 0, 0.55);
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(kScreenW, kScreenH-175-20);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, kScreenH-175-20) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"MKBigImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ImageCellIdentifier];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.tag = 111;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionView *)thumbCollectionView {
    if (!_thumbCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(185, 135);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _thumbCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenH-175, kScreenW, 175) collectionViewLayout:layout];
        _thumbCollectionView.backgroundColor = UIColor.clearColor;
        [_thumbCollectionView registerNib:[UINib nibWithNibName:@"MKThumbImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ThumbImageCellIdentifier];
        _thumbCollectionView.showsVerticalScrollIndicator = NO;
        _thumbCollectionView.showsHorizontalScrollIndicator = NO;
        _thumbCollectionView.delegate = self;
        _thumbCollectionView.dataSource = self;
        _thumbCollectionView.tag = 999;
        [self addSubview:_thumbCollectionView];
    }
    return _thumbCollectionView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel initWithFrame:CGRectMake(0, kScreenH-20, kScreenW, 20) Text:@"" Font:FONT_SIZE(13) TextColor:UIColor.whiteColor BackgroundColor:UIColor.clearColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tagLabel];
        [self bringSubviewToFront:_collectionView];
    }
    return _tagLabel;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[].mutableCopy;
    }
    return _imageArray;
}

@end

@implementation MKImageModel

@end
