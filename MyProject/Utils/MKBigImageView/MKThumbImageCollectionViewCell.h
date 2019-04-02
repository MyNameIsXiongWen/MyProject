//
//  MKThumbImageCollectionViewCell.h
//  ManKu_Merchant
//
//  Created by jason on 2019/3/1.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKThumbImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumgImgView;
@property (nonatomic, assign) BOOL itemSelected;

@end

NS_ASSUME_NONNULL_END
