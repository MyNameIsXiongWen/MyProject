//
//  UICollectionView+Category.m
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UICollectionView+Category.h"

@implementation UICollectionView (Category)

+ (UICollectionView *)initWithFrame:(CGRect)rect Layout:(UICollectionViewFlowLayout *)layout Object:(id)object {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = object;
    collectionView.dataSource = object;
    collectionView.pagingEnabled = YES;
    return collectionView;
}

@end
