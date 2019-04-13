//
//  XWScrollView.h
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex;
@property (nonatomic, copy) void (^ selectItemBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
