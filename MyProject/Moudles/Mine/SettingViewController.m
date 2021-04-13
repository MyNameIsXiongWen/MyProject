//
//  SettingViewController.m
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettingLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImageView *imgView = [UIImageView initWithFrame:CGRectMake(0, 64, kScreenW, 200) ImageUrl:@"" Image:self.image ContentMode:UIViewContentModeScaleAspectFill];
//    [self.view addSubview:imgView];
//    self.view.backgroundColor = [self.image getColorByImage];
    self.collectionView = ({
        SettingFlowLayout *flowLayout = SettingFlowLayout.new;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 20, 20);
        NSMutableArray *tempArray = NSMutableArray.array;
        for (int i=0; i<100; i++) {
            [tempArray addObject:[NSNumber numberWithInteger:100+arc4random()%100]];
        }
        [flowLayout flowLayoutWithItemWidth:(kScreenW-60)/3 itemHeightArray:tempArray];
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[SettingImgCell class] forCellWithReuseIdentifier:NSStringFromClass(SettingImgCell.class)];
        collectionView;
    });
    [self.view addSubview:self.collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW-60)/3, 100+arc4random()%100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SettingImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SettingImgCell.class) forIndexPath:indexPath];
    NSString *imgStr = [NSString stringWithFormat:@"%ld", indexPath.row % 4+1];
    cell.imgView.image = UIImageMake(imgStr);
    return cell;
}

- (CGFloat)getCellHeightFromIndexPath:(NSIndexPath *)indexPath {
    return 0;
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


@implementation SettingImgCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.imgView = [UIImageView initWithFrame:CGRectZero ImageUrl:@"" Image:UIImageMake(@"") ContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

@end

@interface SettingFlowLayout ()

/**
 item 的高度数组
 */
@property (nonatomic, copy) NSArray<NSNumber *> *arrItemHeight;
@property (nonatomic, assign) double maxHeight;

/**
 cell 布局属性集
 */
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *arrAttributes;

@end

@implementation SettingFlowLayout

- (void)flowLayoutWithItemWidth:(CGFloat)itemWidth itemHeightArray:(NSArray<NSNumber *> *)itemHeightArray {
    self.itemSize = CGSizeMake(itemWidth, 0);
    self.arrItemHeight = itemHeightArray;
//    [self.collectionView reloadData];
}

- (void)prepareLayout {
    [super prepareLayout];
    // item 数量为零不做处理
    if ([self.arrItemHeight count] == 0) {
        return;
    }
    
    // 计算一行可以放多少个项
    NSInteger nItemInRow = (self.collectionViewContentSize.width - self.sectionInset.left - self.sectionInset.right + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing);
    // 对列的长度进行累计
    NSMutableArray *arrmColumnLength = [NSMutableArray arrayWithCapacity:100];
    for (NSInteger i = 0; i < nItemInRow; i++) {
        [arrmColumnLength addObject:@0];
    }
    
    //很多时候这个高度数据不是能一开始就能给的出来，所以就可以在下面layoutAttributesForItemAtIndexPath方法里面执行下面相关操作
    NSMutableArray *arrmTemp = [NSMutableArray arrayWithCapacity:100];
    // 遍历设置每一个item的布局
    for (NSInteger i = 0; i < [self.arrItemHeight count]; i++) {
        
        CGRect recFrame = CGRectZero;
        recFrame.size.width = self.itemSize.width;
        // 有数组得到的高度
        recFrame.size.height = [self.arrItemHeight[i] doubleValue];
        // 最短列序号
        __block NSInteger nNumShort = 0;
        // 最短的长度
        __block CGFloat fShortLength = [arrmColumnLength[0] doubleValue];
        // 比较是否存在更短的列
        [arrmColumnLength enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.doubleValue < fShortLength) {
                fShortLength = obj.doubleValue;
                nNumShort = idx;
            }
        }];
        // 插入到最短的列中
        recFrame.origin.x = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing) * nNumShort;
        recFrame.origin.y = fShortLength + self.minimumLineSpacing;
        // 更新列的累计长度
        arrmColumnLength[nNumShort] = [NSNumber numberWithDouble:CGRectGetMaxY(recFrame)];
        
        // 设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        // 创建每一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes *attris = [self layoutAttributesForItemAtIndexPath:index];
        // 更新布局
        attris.frame = recFrame;
        [arrmTemp addObject:attris];
    }
    self.arrAttributes = arrmTemp;
    
    // 最长的长度
    __block CGFloat fLongLength = [arrmColumnLength[0] doubleValue];
    // 比较是否存在更长的列
    [arrmColumnLength enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.doubleValue > fLongLength) {
            fLongLength = obj.doubleValue;
        }
    }];
    self.maxHeight = fLongLength;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat cellHeight = 0;
//    if ([self.delegate respondsToSelector:@selector(getCellHeightFromIndexPath:)]) {
//        cellHeight = [self.delegate getCellHeightFromIndexPath:indexPath];
//    }
////    先找出最短的列，拿到它的index（在高度数组里面的index），就可以计算出它的横、纵坐标x、y
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attributes.frame = CGRectMake(x, y, cellWidth, cellHeight);
//    return attributes;
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return NO;
//}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.arrAttributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(kScreenW, self.maxHeight+self.sectionInset.bottom);
}

@end
