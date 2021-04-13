//
//  NSString+Category.h
//  beichoo_N_ios
//
//  Created by 陈健 on 2017/8/21.
//  Copyright © 2017年 陈健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

//加密
- (NSString *)md5Str;
- (NSString *)sha1Str;
- (NSString *)passwordEncrypt;

//根据font和size拿到文字宽度
- (CGSize)getSizeWithFont:(CGFloat)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(CGFloat)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(CGFloat)font constrainedToSize:(CGSize)size;
-(NSString *)getAleberNumber;
-(NSString *)getDoubleString;
///string to pinyin
-(NSString *)transformToPinyin;
-(NSString *)getMoneyFormatter;
// 纯数字(contain .)
- (BOOL)iSNumStr;
//[0-9]one dot
-(BOOL)isLegalMoneyInput;
// 纯数字(except dot .)
- (BOOL)iSNumStrExceptDot;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo;
- (BOOL)isBankNo;
- (BOOL)isEmail;
+ (BOOL)valiMobile:(NSString *)mobile;
//判断密码是否标准
- (BOOL)checkPassword;
- (BOOL)isGK;
- (BOOL)isFileName;

/**
 UrlEncode/UrlDecode方法的实现 URLDEcode
 
 @param unencodedString 进行编码
 @return 返回到编码
 */
+ (NSString*)encodeString:(NSString*)unencodedString;

/**
 反URL编码
 
 @param encodedString 进行的编码
 @return 返回的编码
 */
+ (NSString *)decodeString:(NSString*)encodedString;


+ (NSString *)shortUrlString:(NSString *)longUrlString;
/**
 判断字符串是否为空
 
 */
+ (BOOL)isBlankString:(NSString *)string;
/**
 处理json格式的字符串中的换行符、回车符
 */
+ (NSString *)deleteSpecialCodeWithStr:(NSString *)str;
//字符串去掉最后一个
+(NSString*)removeLastOneChar:(NSString*)origin;
+(NSString *)convertToJSONData:(NSDictionary *)dict;
- (id)convertToObject;

///判断是否是网址
- (BOOL)isUrlString;
///nstimeinterval转时间
- (NSString *)formatterTime;
///获取当前时间
+ (NSString *)getCurrentTime;
+ (NSString *)getMsgTimeByDate:(NSDate *)date;
//根据网络图片url获取图片高度
- (void)getImageHeightWithWidth:(CGFloat)width Complete:(void (^)(CGFloat height))complete;
//date转换成周几
- (NSString *)convertWeeks;
//视频链接生成封面图(第一帧)
- (void)thumbnailImageForVideoWithComplete:(void (^)(UIImage *img))complete;

+ (NSString *)stringWithTimeStamp;

@end
