//
//  QHWPhotoBrowserCollectionViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/29.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWPhotoBrowserCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (nonatomic, copy) void (^ singltTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
