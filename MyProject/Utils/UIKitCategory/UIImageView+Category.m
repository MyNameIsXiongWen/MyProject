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

+ (UIImageView *(^)(void))ivInit {
    return ^(void) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        return imgView;
    };
}

+ (UIImageView *(^)(CGRect))ivFrame {
    return ^(CGRect ivFrame) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:ivFrame];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        return imgView;
    };
}

- (UIImageView *(^)(NSString *))ivImageUrl {
    return ^(NSString *ivImageUrl) {
        if (self.image) {
            [self sd_setImageWithURL:[NSURL URLWithString:ivImageUrl] placeholderImage:self.image];
        } else {
            [self sd_setImageWithURL:[NSURL URLWithString:ivImageUrl] placeholderImage:nil];
        }
        return self;
    };
}

- (UIImageView *(^)(UIColor *))ivBkgColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIImageView *(^)(UIViewContentMode))ivMode {
    return ^(UIViewContentMode ivMode) {
        self.contentMode = ivMode;
        return self;
    };
}

- (UIImageView *(^)(UIImage *))ivImage {
    return ^(UIImage *ivImage) {
        self.image = ivImage;
        return self;
    };
}

- (UIImageView *(^)(CGFloat))ivCornerRadius {
    return ^(CGFloat ivCornerRadius) {
        self.layer.cornerRadius = ivCornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

- (UIImageView *(^)(UIColor *))ivBorderColor {
    return ^(UIColor *ivBorderColor) {
        self.layer.borderColor = ivBorderColor.CGColor;
        self.layer.borderWidth = 0.5;
        return self;
    };
}

@end
