//
//  SettingViewController.h
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@end

@interface SettingImgCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@protocol SettingLayoutDelegate <NSObject>

- (CGFloat)getCellHeightFromIndexPath:(NSIndexPath *)indexPath;

@end

@interface SettingFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <SettingLayoutDelegate>delegate;

/**
 瀑布流布局方法
 
 @param itemWidth item 的宽度
 @param itemHeightArray item 的高度数组
 */
- (void)flowLayoutWithItemWidth:(CGFloat)itemWidth itemHeightArray:(NSArray<NSNumber *> *)itemHeightArray;

@end

NS_ASSUME_NONNULL_END
