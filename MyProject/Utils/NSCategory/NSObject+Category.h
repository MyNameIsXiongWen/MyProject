//
//  NSObject+Category.h
//  ManKu_Merchant
//
//  Created by jason on 2019/3/13.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Category) <NSMutableCopying>

- (NSDictionary *)dicFromObject:(NSObject *)object;
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentMethodCallerVC;

@end

NS_ASSUME_NONNULL_END
