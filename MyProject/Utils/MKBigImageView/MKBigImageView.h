//
//  MKBigImageView.h
//  MANKUProject
//
//  Created by jason on 2019/1/11.
//  Copyright © 2019年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBigImageView : UIView

- (MKBigImageView *)initWithFrame:(CGRect)frame ImgArray:(NSMutableArray *)imgArray CurrentIndex:(NSInteger)currentIndex;
- (void)show;
- (void)dismiss;
@property (nonatomic, copy) void (^ dismissBlock)(void);

@end

@interface MKImageModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) BOOL imgSelected;

@end

NS_ASSUME_NONNULL_END
