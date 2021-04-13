//
//  UIView+Category.m
//  MANKUProject
//
//  Created by jason on 2018/7/23.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

+ (UIView *)initWithFrame:(CGRect)rect
          BackgroundColor:(UIColor *)backgroundColor
             CornerRadius:(CGFloat)radius {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backgroundColor;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    return view;
}

+ (UIView *(^)(void))viewInit {
    return ^{
        return [[UIView alloc] init];
    };
}

+ (UIView *(^)(CGRect))viewFrame {
    return ^(CGRect viewFrame) {
        return [[UIView alloc] initWithFrame:viewFrame];
    };
}

- (UIView *(^)(UIColor *))bkgColor {
    return ^(UIColor *bkgColor) {
        self.backgroundColor = bkgColor;
        return self;
    };
}

- (UIView *(^)(CGFloat))cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        return self;
    };
}

- (void)showNodataView:(BOOL)show offsetY:(CGFloat)offsetY button:(UIButton *)button{
    for (UIView *vvv in self.subviews) {
        if ([vvv isKindOfClass:NoDataView.class]) {
            [vvv removeFromSuperview];
            break;
        }
    }
    if (show) {
        CGFloat height = 150 + 15;
        if (button) {
            height = 150 + 55;
        }
        NoDataView *nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, (self.height-offsetY-height)/2+offsetY, self.width, height) Text:@"暂无数据" Image:@"" button:button];
        [self addSubview:nodataView];
        [self bringSubviewToFront:nodataView];
    }
}

- (void)showNoInternetView:(BOOL)show retry:(void (^)(void))retryBlock {
    if (retryBlock) {
        self.RetryBlock = retryBlock;
    }
    for (UIView *vvv in self.subviews) {
        if ([vvv isKindOfClass:NoDataView.class]) {
            [vvv removeFromSuperview];
            break;
        }
    }
    if (show) {
        UIButton *btn = [UIButton initWithFrame:CGRectMake((kScreenW-80)/2, 250, 80, 30) Title:@"" Image:nil SelectedImage:nil Font:kFontTheme10 TitleColor:UIColor.orangeColor BackgroundColor:UIColor.clearColor CornerRadius:0];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"点击重新加载" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: UIColor.orangeColor}];
        [btn setAttributedTitle:attr forState:0];
        [btn addTarget:self action:@selector(clickRetryBtn) forControlEvents:UIControlEventTouchUpInside];
        NoDataView *nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, (self.height-280)/2, self.width, 280) Text:@"当前网络较差，请重试" Image:@"" button:btn];
        [self addSubview:nodataView];
        [self bringSubviewToFront:nodataView];
    }
}

- (void)clickRetryBtn {
    if (self.RetryBlock) {
        self.RetryBlock();
    }
}

- (void (^)(void))RetryBlock {
    return objc_getAssociatedObject(self, @"kRetryBlock");
}

- (void)setRetryBlock:(void (^)(void))RetryBlock {
    objc_setAssociatedObject(self, @"kRetryBlock", RetryBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addBezierPathByRoundingCorners:(UIRectCorner)roundingCorners CornerSize:(CGSize)cornerSize {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:cornerSize];
    CAShapeLayer *layer = CAShapeLayer.new;
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

@dynamic x;
@dynamic y;

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setTop:(CGFloat)t
{
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b
{
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l
{
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r
{
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)w
{
    self.frame = CGRectMake(self.left, self.top, w, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h
{
    self.frame = CGRectMake(self.left, self.top, self.width, h);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}


@end


@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)msg Image:(NSString *)image button:(UIButton *)button {
    if (self == [super initWithFrame:frame]) {
        UIImageView *imgView = UIImageView.ivFrame(CGRectMake((self.width - 150)/2, 0, 150, 150)).ivImage(UIImageMake(image));
        [self addSubview:imgView];
        UILabel *label = UILabel.labelFrame(CGRectMake(0, 150, kScreenW, 15)).labelText(msg).labelFont(kFontTheme14).labelTitleColor(kColorTheme000).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:label];
        if (button) {
            button.top = label.bottom + 10;
            [self addSubview:button];
        }
    }
    return self;
}

@end
