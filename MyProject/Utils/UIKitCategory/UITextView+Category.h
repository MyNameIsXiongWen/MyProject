//
//  UITextView+Category.h
//  ManKu_Merchant
//
//  Created by jason on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Category)

/**
  创建textView

 @param rect 大小
 @param text 内容
 @param placeholder 默认内容
 @param font 字体大小
 @param textColor 字体颜色
 @return textView
 */
+ (UITextView *)initWithFrame:(CGRect)rect
                         Text:(NSString *)text
                  Placeholder:(NSString *)placeholder
                         Font:(UIFont *)font
                    TextColor:(UIColor *)textColor;

@property (nonatomic, strong) UILabel *placeholderLabel;

+ (UITextView *(^)(CGRect tvFrame))tvFrame;
- (UITextView *(^)(NSString *tvText))tvText;
- (UITextView *(^)(UIFont *tvFont))tvFont;
- (UITextView *(^)(UIColor *tvTextColor))tvTextColor;
///要先调用tvFont，这样tvPlaceholder才能获得font
- (UITextView *(^)(NSString *tvPlaceholder))tvPlaceholder;

@end

NS_ASSUME_NONNULL_END
