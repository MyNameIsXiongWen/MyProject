//
//  UploadFileFragment.m
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UploadFileFragment.h"

@implementation UploadFileFragment

/// 获取请求头信息
- (NSDictionary *)fetchUploadParamsInfo {
    /// 拼接服务器所需的上传参数
    /// {'id':'43','totalSize':19232,'blockTotal':2,'blockNo':1}
    return @{@"id"        : self.fileId,
             @"totalSize" : @(self.totalFileSize),
             @"blockTotal": @(self.totalFileFragment),
             @"blockNo"   : @(self.fragmentIndex + 1)};
}

/// 获取文件大小
- (NSData *)fetchFileFragmentData {
    NSData *data = nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    /// 资源文件的绝对路径
    NSString *absolutePath = [dirPath stringByAppendingPathComponent:self.filePath];

    if ([fileMgr fileExistsAtPath:absolutePath]) {
        NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:absolutePath];
        [readHandle seekToFileOffset:self.fragmentOffset];
        /// 读取文件
        data = [readHandle readDataOfLength:self.fragmentSize];
        /// CoderMikeHe Fixed Bug: 获取了数据，要关闭文件
        [readHandle closeFile];
        NSLog(@"😭😭😭+++ 上传文件片大小%lu +++😭😭😭》〉", (unsigned long)data.length);
    } else {
        NSLog(@"😭😭😭+++ 上传文件不存在 +++😭😭😭》〉");
    }
    return data;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
        for (i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_name];
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (propertyValue) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
        free(properties);
    }
    return self;
}

@end
