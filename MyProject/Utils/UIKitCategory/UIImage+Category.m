//
//  UIImage+Category.m
//  ManKu_Merchant
//
//  Created by zhaoxiafei on 2019/1/23.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
