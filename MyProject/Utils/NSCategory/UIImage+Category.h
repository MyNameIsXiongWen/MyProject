//
//  UIImage+Category.h
//  MyProject
//
//  Created by jason on 2019/4/13.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

- (UIColor *)getColorByImage;
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
                       text:(NSString *)text
             textAttributes:(NSDictionary *)textAttributes
                   circular:(BOOL)isCircular;

@end

NS_ASSUME_NONNULL_END
