//
//  QHWPhotoBrowser.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/29.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWPhotoBrowser.h"
#import "QHWPhotoBrowserCollectionViewCell.h"
#import "QHWImageModel.h"

@interface QHWPhotoBrowser () <UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation QHWPhotoBrowser

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (QHWPhotoBrowser *)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.blackColor;
        [self addSubview:self.collectionView];
        [self addSubview:self.topView];
        [self.topView addSubview:self.tagLabel];
        [self.topView addSubview:self.backButton];
        self.imageArray = imgArray;
        self.currentIndex = currentIndex;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        self.tagLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)currentIndex+1, (unsigned long)imgArray.count];
    }
    return self;
}

#pragma mark ------------UICollectionView-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWPhotoBrowserCollectionViewCell.class) forIndexPath:indexPath];
    id object = self.imageArray[indexPath.row];
    if ([object isKindOfClass:QHWImageModel.class]) {
        QHWImageModel *model = (QHWImageModel *)object;
        if (model.imageSrc) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:UIImageMake(@"")];
        } else {
            cell.imgView.image = model.image;
        }
    } else if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *fileDic = (NSDictionary *)object;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:fileDic[@"path"]] placeholderImage:UIImageMake(@"")];
    } else if ([object isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)object;
        cell.imgView.image = image;
    } else {
        NSString *imgSrc = (NSString *)object;
//        imgSrc = kFormat(@"%@?x-oss-process=image/resize,l_3000", imgSrc);
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgSrc] placeholderImage:UIImageMake(@"")];
    }
    cell.singltTapBlock = ^{
        [self dismiss];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int a = scrollView.contentOffset.x/kScreenW;
    self.tagLabel.text = [NSString stringWithFormat:@"%d / %lu", a+1, (unsigned long)self.imageArray.count];
    self.currentIndex = a;
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark ------------UI初始化-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(kScreenW, kScreenH);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [UICollectionView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) Layout:layout Object:self];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"QHWPhotoBrowserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QHWPhotoBrowserCollectionViewCell.class)];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, kStatusBarHeight + 44));
    }
    return _topView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = UIButton.btnFrame(CGRectMake(20, kStatusBarHeight + 7, 30, 30)).btnImage(UIImageMake(@"btn_back_circle_black"));
        _backButton.showsTouchWhenHighlighted = NO;
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = UILabel.labelFrame(CGRectMake(50, kStatusBarHeight, kScreenW - 100, 44)).labelFont(kFontTheme14).labelTitleColor(kColorThemefff).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _tagLabel;
}

@end
