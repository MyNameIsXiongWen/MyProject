//
//  NSDictionary+Category.m
//  ManKu_Merchant
//
//  Created by jason on 2018/10/24.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (NSString *)convertToJsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *mutStr = [NSString stringWithString:jsonString];
    mutStr = [mutStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    mutStr = [mutStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return mutStr;
}

@end
