//
//  NSString+Category.m
//  beichoo_N_ios
//
//  Created by 陈健 on 2017/8/21.
//  Copyright © 2017年 陈健. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)

- (NSString *)md5Str
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

- (NSString*)sha1Str {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int) data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)passwordEncrypt {
    NSString *password = [NSString stringWithFormat:@"%@%@",@"pony-b:",self];
    password = [password sha1Str];
    return password;
}

- (CGSize)getSizeWithFont:(CGFloat)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font],
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}

- (CGFloat)getHeightWithFont:(CGFloat)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}

- (CGFloat)getWidthWithFont:(CGFloat)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}
-(NSString *)getAleberNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    return [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInteger:[self integerValue]]]];
}
// 纯数字
- (BOOL)iSNumStr {
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
- (BOOL)isLegalMoneyInput
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^\\d+$|^\\d*\\.\\d+$/g";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
// 纯数字
- (BOOL)iSNumStrExceptDot {
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo {
    
    if ([self length] != 11) {
        return NO;
    }
    NSString *one = [self substringWithRange:NSMakeRange(0, 1)];
    NSString *two = [self substringWithRange:NSMakeRange(1, 1)];
    NSString *three = [self substringWithRange:NSMakeRange(2, 1)];
    
    if ([one isEqualToString:@"1"]) {
        if ([two integerValue] == 3 || [two integerValue] == 5 || [two integerValue] == 8) {
            return YES;
        }
        else if ([two integerValue] == 4 && [three integerValue] != 0 && [three integerValue] != 2 && [three integerValue] != 3 && [three integerValue] != 9) {
            return YES;
        }
        else if ([two integerValue] == 6 && [three integerValue] == 6) {
            return YES;
        }
        else if ([two integerValue] == 7 && [three integerValue] != 2 && [three integerValue] != 9) {
            return YES;
        }
        else if ([two integerValue] == 9) {
            if (([three integerValue] == 8 || [three integerValue] == 9)) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (BOOL)valiMobile:(NSString *)mobile {
    if (mobile.length != 11)
    {
        //判断手机号码是否为11位
        return NO;
    }else{
        //使用正则表达式的方法来判断手机号
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        //初始化NSPredicate对象
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        //与具体对象进行筛选判断, 返回为BOOL值
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
-(NSString *)getDoubleString
{
    return [NSString stringWithFormat:@"%.2f",self.doubleValue];
}
- (BOOL)isBankNo
{
    NSString *passwordRegex = @"^\\d{15,19}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];
}
-(NSString *)getMoneyFormatter
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
    return formattedNumberString;
}
- (BOOL)checkPassword {
    NSString *passwordRegex = @"[A-Z0-9a-z]{6,16}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];
}

- (BOOL)isGK {
    NSString *gkRegex = @"[A-Z0-9a-z-_]{3,32}";
    NSPredicate *gkTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gkRegex];
    return [gkTest evaluateWithObject:self];
}
- (BOOL)isFileName {
    NSString *phoneRegex = @"[a-zA-Z0-9\\u4e00-\\u9fa5\\./_-]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

+ (NSString*)encodeString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString {
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
+ (NSString *)shortUrlString:(NSString *)longUrlString
{
    //待解决
    return longUrlString;
}
/**
 判断字符串是否为空
 
 */
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}
#pragma mark -- 处理json格式的字符串中的换行符、回车符
+ (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

//字符串去掉最后一个
+(NSString*)removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData){  NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

- (id)convertToObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return object;
}

///判断是否是网址
- (BOOL)isUrlString {
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}

- (NSString *)formatterTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self substringToIndex:10].longLongValue];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
///string to pinyin
-(NSString *)transformToPinyin
{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

@end

