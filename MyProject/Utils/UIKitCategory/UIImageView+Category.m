//
//  UIImageView+Category.m
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

+ (UIImageView *)initWithFrame:(CGRect)rect
                      ImageUrl:(NSString *)imageUrl
                         Image:(UIImage *)image
                   ContentMode:(UIViewContentMode)mode {
    UIImageView *img = [[UIImageView alloc] initWithFrame:rect];
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
    img.contentMode = mode;
    img.layer.masksToBounds = YES;
    return img;
}

@end
