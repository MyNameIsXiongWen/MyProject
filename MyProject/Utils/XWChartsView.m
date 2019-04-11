//
//  XWChartsView.m
//  MyProject
//
//  Created by jason on 2019/4/9.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "XWChartsView.h"

static CGFloat const kLeftSpace = 45;//距离左边边距
static CGFloat const kRightSpace = 15;//距离右边边距
static CGFloat const kTopSpace = 15;//距离顶部边距
static CGFloat const kSplitY = 40;//纵向间隔

@interface XWChartsView ()

@property (nonatomic, assign) CGFloat kSplitX;//横向间隔
@property (nonatomic, strong) NSMutableArray *yAxisData;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation XWChartsView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    for (int i=1; i<=self.ySplitNumber; i++) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        bezierPath.lineWidth = 1;
        [bezierPath moveToPoint:CGPointMake(kLeftSpace, kTopSpace+i*kSplitY)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-kRightSpace, kTopSpace+i*kSplitY)];
        UIColor *color = ColorFromHexString(@"eeeeee");
        if (i == self.ySplitNumber) {
            color = ColorFromHexString(@"999999");
        }
        [color set];
        [bezierPath stroke];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)drawLabel {
    for (UIView *vvv in self.subviews) {
        [vvv removeFromSuperview];
    }
    for (int i=1; i<=self.ySplitNumber; i++) {
        UILabel *yLable = [UILabel initWithFrame:CGRectMake(0, kTopSpace+i*kSplitY-10, kLeftSpace-10, 20) Text:self.yAxisData[i-1] Font:FONT_SIZE(10) TextColor:ColorFromHexString(@"7d7d7d") BackgroundColor:UIColor.clearColor];
        yLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:yLable];
    }
    for (int i=0; i<self.chartsData.count; i++) {
        CGFloat totalHeight = (self.ySplitNumber)*kSplitY;
        UILabel *xLable = [UILabel initWithFrame:CGRectMake(kLeftSpace+self.kSplitX*(i+0.5)-20, totalHeight+kTopSpace, 40, 20) Text:self.xAxisData[i] Font:FONT_SIZE(12) TextColor:ColorFromHexString(@"7d7d7d") BackgroundColor:UIColor.clearColor];
        xLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:xLable];
    }
}

- (void)drawCurve {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.f;
    
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.strokeColor = ColorFromHexString(@"ff7919").CGColor;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.shapeLayer.lineWidth = 2;
        [self.layer addSublayer:self.shapeLayer];
    }
    else {
        [self.shapeLayer removeAllAnimations];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i=0; i<self.chartsData.count; i++) {
        CGFloat totalHeight = (self.ySplitNumber)*kSplitY;
        if (i>0) {
            CGFloat maxH = [self.yAxisData[self.yAxisData.count - 2] floatValue] * self.ySplitNumber;
            CGFloat oldPercent = (maxH-[self.chartsData[i-1] floatValue])/maxH;
            CGFloat nowPercent = (maxH-[self.chartsData[i] floatValue])/maxH;
            CGPoint oldPoint = CGPointMake(kLeftSpace+self.kSplitX*(i-0.5), kTopSpace+oldPercent*totalHeight);
            [path moveToPoint:oldPoint];
            CGPoint nowPoint = CGPointMake(kLeftSpace+self.kSplitX*(i+0.5), kTopSpace+nowPercent*totalHeight);
            [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((oldPoint.x+nowPoint.x)/2, oldPoint.y) controlPoint2:CGPointMake((oldPoint.x+nowPoint.x)/2, nowPoint.y)];
        }
    }
    self.shapeLayer.path = path.CGPath;
    [self.shapeLayer addAnimation:animation forKey:nil];
}

- (void)setXAxisData:(NSArray *)xAxisData {
    _xAxisData = xAxisData;
    self.kSplitX = (CGRectGetWidth(self.bounds)-60)/xAxisData.count;
}

- (void)setChartsData:(NSArray *)chartsData {
    _chartsData = chartsData;
    NSNumber *number = [chartsData valueForKeyPath:@"@max.floatValue"];
    NSInteger maxInteger = ceil(number.doubleValue);
    NSInteger perInteger = ceil(maxInteger/(CGFloat)(self.ySplitNumber-1));
    [self.yAxisData removeAllObjects];
    for (NSInteger i=self.ySplitNumber-1; i>=0; i--) {
        [self.yAxisData addObject:[NSString stringWithFormat:@"%ld",perInteger * i]];
    }
    [self drawLabel];
    [self drawCurve];
}

- (NSMutableArray *)yAxisData {
    if (!_yAxisData) {
        _yAxisData = NSMutableArray.array;
    }
    return _yAxisData;
}

@end
