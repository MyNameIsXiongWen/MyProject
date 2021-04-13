//
//  BottomViewController.h
//  MyProject
//
//  Created by xiaobu on 2020/4/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BottomViewStateCollapse,
    BottomViewStateScrolling,
    BottomViewStateExtend,
} BottomViewState;

@protocol BtmVCDelegate <NSObject>

- (void)BtmViewPanGes:(UIPanGestureRecognizer *)gesture;
- (void)BtmViewTouchBegan:(NSSet<UITouch *> *)touches;
- (void)BtmViewTouchMoved:(NSSet<UITouch *> *)touches;
- (void)BtmViewTouchEnd:(NSSet<UITouch *> *)touches;

@end

@interface BottomViewController : UIViewController

@property (nonatomic, assign) BottomViewState *selfState;
@property (nonatomic, weak) id <BtmVCDelegate>delegate;
@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, assign) CGFloat tableviewOffset;

@end

@protocol SubTableDelegate <NSObject>

- (void)BtmViewContentOffset:(CGFloat)contentOffset;

@end

@interface DetailCollectionViewCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id <SubTableDelegate>subDelegate;

@end

NS_ASSUME_NONNULL_END
