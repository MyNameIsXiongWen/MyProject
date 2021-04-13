//
//  QHWPhotoBrowserCollectionViewCell.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/29.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "QHWPhotoBrowserCollectionViewCell.h"

@interface QHWPhotoBrowserCollectionViewCell () <UIScrollViewDelegate>

@end

@implementation QHWPhotoBrowserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrView.maximumZoomScale = 2.0;
    self.scrView.minimumZoomScale = 1.0;
    self.scrView.delegate = self;
    self.scrView.scrollEnabled = YES;
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singletap.numberOfTapsRequired = 1;
    [self.scrView addGestureRecognizer:singletap];
    [self.imgView addGestureRecognizer:singletap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.imgView addGestureRecognizer:doubleTap];
    [singletap requireGestureRecognizerToFail:doubleTap];
    self.contentView.backgroundColor = UIColor.clearColor;
}

- (void)singleTap:(UITapGestureRecognizer *)sender {
    if (self.singltTapBlock) {
        self.singltTapBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:sender.view];
    BOOL zoomOut = self.scrView.zoomScale == self.scrView.minimumZoomScale;
    CGFloat scale = zoomOut ? self.scrView.maximumZoomScale : self.scrView.minimumZoomScale;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrView.zoomScale = scale;
        if(zoomOut){
            CGFloat x = touchPoint.x*scale - self.scrView.bounds.size.width / 2;
            CGFloat maxX = self.scrView.contentSize.width - self.scrView.bounds.size.width;
            CGFloat minX = 0;
            x = x > maxX ? maxX : x;
            x = x < minX ? minX : x;

            CGFloat y = touchPoint.y * scale - self.scrView.bounds.size.height / 2;
            CGFloat maxY = self.scrView.contentSize.height - self.scrView.bounds.size.height;
            CGFloat minY = 0;
            y = y > maxY ? maxY : y;
            y = y < minY ? minY : y;
            self.scrView.contentOffset = CGPointMake(x, y);
        }
    } completion:^(BOOL finished) {
        NSLog(@"=====completed");
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"=====scrollViewDidZoom");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"=====scrollViewDidEndZooming====%f",scale);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"=====scrollViewWillBeginZooming");
}

@end
