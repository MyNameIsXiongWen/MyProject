//
//  UploadFileSource.m
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UploadFileSource.h"

@implementation UploadFileSource

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"fileBlocks": UploadFileBlock.class, @"fileFragments": UploadFileFragment.class};
}

- (void)setFileBlocks:(NSArray<UploadFileBlock *> *)fileBlocks {
    _fileBlocks = fileBlocks.copy;
    
    NSMutableArray *fileFragments = [NSMutableArray array];
    self.totalFileFragment = 0;
    self.totalFileSize = 0;
    
    for (UploadFileBlock *fileBlock in fileBlocks) {
        [fileFragments addObjectsFromArray:fileBlock.fileFragments];
        self.totalFileFragment += fileBlock.totalFileFragment;
        self.totalFileSize += fileBlock.totalFileSize;
    }
    self.fileFragments = fileFragments.copy;
    
    NSLog(@"👉 self.totalFileFragment --- %ld" , (long)self.totalFileFragment);
    NSLog(@"👉 self.totalFileSize --- %ld" , (long)self.totalFileSize);
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

- (NSString *)sourceName {
    if (!_sourceName) {
        _sourceName = self.sourceId;
    }
    return _sourceName;
}

- (NSString *)uploadStatusName {
    switch (self.uploadStatus) {
        case FileUploadStatusFinished:
            return @"已完成";
            break;
            
        case FileUploadStatusUploading:
            return @"上传中";
            break;
            
        case FileUploadStatusSuspend:
            return @"已暂停";
            break;
            
        case FileUploadStatusWaiting:
            return @"等待中";
            break;
            
        default:
            return @"草稿箱";
            break;
    }
}

- (CGFloat)uploadProgress {
    if (self.totalFileFragment == 0) {
        return 0.0;
    }
    return (CGFloat)self.totalSuccessFileFragment / self.totalFileFragment;
}

@end
