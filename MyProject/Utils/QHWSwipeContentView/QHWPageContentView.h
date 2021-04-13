//
//  QHWPageContentView.h
//  Huim
//
//  Created by huim on 2017/4/28.
//  Copyright © 2017年 huim. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QHWPageContentView;

@protocol QHWPageContentViewDelegate <NSObject>

@optional

/**
 QHWPageContentView开始滑动

 @param contentView QHWPageContentView
 */
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView;

/**
 QHWPageContentView滑动调用

 @param contentView QHWPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)QHWContentViewDidScroll:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 QHWPageContentView结束滑动

 @param contentView QHWPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

@interface QHWPageContentView : UIView

/**
 对象方法创建QHWPageContentView

 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return QHWPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<QHWPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<QHWPageContentViewDelegate>delegate;
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong, readonly) NSArray *childsVCs;//子视图数组

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;
- (void)setContentViewCurrentIndexWithAnimation:(NSInteger)contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end
