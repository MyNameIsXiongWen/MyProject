//
//  DownloadFileSource.m
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DownloadFileSource.h"
#import "UploadFileConstant.h"

@implementation DownloadFileSource

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        id propertyValue = [self valueForKey:propertyName];
        if (![propertyName isEqualToString:@"dataTask"] && ![propertyName isEqualToString:@"fileHandle"]) {
            if (propertyValue) {
                [aCoder encodeObject:propertyValue forKey:propertyName];
            }
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

- (NSString *)downloadFullUrlPath {
    if (!_downloadFullUrlPath) {
        _downloadFullUrlPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.sourceId];
//        _downloadFullUrlPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", self.sourceId]];
    }
    return _downloadFullUrlPath;
}

- (NSString *)sourceName {
    if (!_sourceName) {
        _sourceName = self.sourceId;
    }
    return _sourceName;
}

- (NSString *)downloadStatusName {
    switch (self.downloadStatus) {
        case FileDownloadStatusFinished:
            return @"已完成";
            break;
            
        case FileDownloadStatusDownloading:
            return @"下载中";
            break;
            
        case FileDownloadStatusSuspend:
            return @"已暂停";
            break;
            
        case FileDownloadStatusWaiting:
            return @"等待中";
            break;
            
        default:
            return @"草稿箱";
            break;
    }
}

@end
