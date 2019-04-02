//
//  MKBigImageCollectionViewCell.h
//  MANKUProject
//
//  Created by jason on 2019/1/11.
//  Copyright © 2019年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBigImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (nonatomic, copy) void (^ singltTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
