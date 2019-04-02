//
//  UITableView+Category.h
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Category)

+ (UITableView *)initWithFrame:(CGRect)rect Style:(UITableViewStyle)style Object:(id)object;

@end

NS_ASSUME_NONNULL_END
