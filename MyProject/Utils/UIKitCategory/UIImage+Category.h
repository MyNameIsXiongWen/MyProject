//
//  UIImage+Category.h
//  ManKu_Merchant
//
//  Created by zhaoxiafei on 2019/1/23.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular;
@end

NS_ASSUME_NONNULL_END
