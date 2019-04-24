//
//  HomeTableViewCell.h
//  MyProject
//
//  Created by jason on 2019/4/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UILabel *price;

@end

NS_ASSUME_NONNULL_END
