//
//  MKPassWordView.h
//  AJCash
//
//  Created by 熊文 on 2017/11/24.
//  Copyright © 2017年 熊文. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKPassWordView;

@protocol  MKPassWordViewDelegate<NSObject>

@optional

///监听输入的改变
- (void)passWordDidChange:(MKPassWordView *)passWord;

///监听输入的完成时
- (void)passWordCompleteInput:(MKPassWordView *)passWord;

///监听开始输入
- (void)passWordBeginInput:(MKPassWordView *)passWord;

@end

@interface MKPassWordView : UIView <UIKeyInput>

@property (assign, nonatomic) NSUInteger passWordNum;//密码的位数
@property (assign, nonatomic) CGFloat squareWidth;//外框长
@property (assign, nonatomic) CGFloat squareHeight;//外框宽
@property (assign, nonatomic) CGFloat pointRadius;//黑点的半径
@property (strong, nonatomic) UIColor *pointColor;//黑点的颜色
@property (strong, nonatomic) UIColor *rectColor;//边框的颜色
@property (weak, nonatomic) id<MKPassWordViewDelegate> delegate;
@property (strong, nonatomic) NSMutableString *textStore;//保存密码的字符串

@end
