//
//  QHWPhotoBrowser.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/29.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWPhotoBrowser : UIView

- (QHWPhotoBrowser *)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex;
- (void)show;
- (void)dismiss;
@property (nonatomic, copy) void (^ dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
