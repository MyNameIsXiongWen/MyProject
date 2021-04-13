//
//  UploadFileBlock.m
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UploadFileBlock.h"

@implementation UploadFileBlock

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"fileFragments": UploadFileFragment.class};
}

- (instancetype)initFileBlcokAtPath:(NSString *)path
                             fileId:(NSString *)fileId
                           sourceId:(NSString *)sourceId {
    if (self = [super init]) {
        /// 验证路径的有效性
        if (![self _fetchFileInfoAtPath:path]) {
            return nil;
        }
        self.fileId = fileId;
        self.sourceId = sourceId;
        
        /// 切片
        [self _cutFileForFragments];
    }
    return self;
}

/// 获取文件信息
- (BOOL)_fetchFileInfoAtPath:(NSString*)path {
    /// 验证文件存在
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    /// 拼接路径，path 是相对路径
    NSString *absolutePath = [dirPath stringByAppendingPathComponent:path];
    if (![fileMgr fileExistsAtPath:absolutePath]) {
        NSLog(@"+++ 文件不存在 +++：%@",absolutePath);
        return NO;
    }
    /// 存取文件路径
    self.filePath = path;
    
    /// 文件大小
    NSDictionary *attr =[fileMgr attributesOfItemAtPath:absolutePath error:nil];
    self.totalFileSize = attr.fileSize;
    
    /// 文件名
    NSString *fileName = [path lastPathComponent];
    self.fileName = fileName;
    
    /// 文件类型
    self.fileType = ([fileName.pathExtension.lowercaseString isEqualToString:@"mp4"]) ? FileTypeVideo:FileTypePhoto;
    
    return YES;
}

#pragma mark - 读操作
// 切分文件片段
- (void)_cutFileForFragments {
    NSUInteger offset = UploadFileFragmentMaxSize;
    // 总片数
    NSUInteger totalFileFragment = (self.totalFileSize%offset==0)?(self.totalFileSize/offset):(self.totalFileSize/(offset) + 1);
    self.totalFileFragment = totalFileFragment;
    NSMutableArray<UploadFileFragment *> *fragments = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSUInteger i = 0; i < totalFileFragment; i ++) {
        
        UploadFileFragment *fFragment = [[UploadFileFragment alloc] init];
        fFragment.fragmentIndex = i;
        fFragment.uploadStatus = FileUploadStatusWaiting;
        fFragment.fragmentOffset = i * offset;
        if (i != totalFileFragment - 1) {
            fFragment.fragmentSize = offset;
        } else {
            fFragment.fragmentSize = self.totalFileSize - fFragment.fragmentOffset;
        }
        
        /// 关联属性
        fFragment.fileId = self.fileId;
        fFragment.sourceId = self.sourceId;
        fFragment.filePath = self.filePath;
        fFragment.totalFileFragment = self.totalFileFragment ;
        fFragment.totalFileSize = self.totalFileSize;
        
        fFragment.fileType = self.fileType;
        fFragment.fileName = [NSString stringWithFormat:@"%@-%ld.%@",self.fileId , (long)i , self.fileName.pathExtension];
        
        [fragments addObject:fFragment];
    }
    self.fileFragments = fragments.copy;
}

/// 将图片写入磁盘
+ (NSString *)writePictureFileToDisk:(NSData *)srcData {
    /// 文件后缀
    NSString *suffix = @"png";
    /// 文件夹路径
    NSString *dirPath = [NSString stringWithFormat:@"%@",UploadFileCacheDirName];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileDirPath = [cachesDir stringByAppendingPathComponent:dirPath];
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if (![fileManager fileExistsAtPath:fileDirPath]) {
        [fileManager createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", HttpManager.sharedInstance.getRandomString,suffix];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    /// 文件路径 这里的文件路劲必须为相对路径，千万不要设置为绝对路径，因为随着版本的更新和升级，绝对路径会变 切记@！
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    /// 目标路径
    NSString *dstPath = [fileDirPath stringByAppendingPathComponent:fileName];
    /// 存图片过大 内存开销较大 ，需要优化处理
    BOOL rst = [srcData writeToFile:dstPath atomically:YES];
    NSLog(@" 存储图片文件（%@） 文件路径（%@） -----  %@" , fileName , filePath, rst?@"成功":@"失败");
    return rst ? filePath : nil;
}

+ (NSString *)moveVideoFileAtPath:(NSString *)srcPath {
    /// 文件后缀
    NSString *suffix = srcPath.pathExtension;
    /// 文件夹路径
    NSString *dirPath = [NSString stringWithFormat:@"%@", UploadFileCacheDirName];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileDirPath = [cachesDir stringByAppendingPathComponent:dirPath];
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if (![fileManager fileExistsAtPath:srcPath]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", srcPath];
        return nil;
    }
    
    if (![fileManager fileExistsAtPath:fileDirPath]) {
        [fileManager createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", HttpManager.sharedInstance.getRandomString,suffix];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    /// 文件路径 这里的文件路劲必须为相对路径，千万不要设置为绝对路径，因为随着版本的更新和升级，绝对路径会变 切记@！
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    /// 目标路径
    NSString *dstPath = [fileDirPath stringByAppendingPathComponent:fileName];
    
    // 如果目标路径存在，那就把之前的旧数据删了
    if ([fileManager fileExistsAtPath:dstPath]) {
        [fileManager removeItemAtPath:dstPath error:nil];
    }
    
    /// 移动文件 <剪切>
    BOOL rst = [fileManager moveItemAtPath:srcPath toPath:dstPath error:nil];
    NSLog(@" 移动视频文件（%@） 文件路径（%@） -----  %@" , fileName , filePath, rst?@"成功":@"失败");
    return rst ? filePath : nil;
}

- (void)removeFileFromCache {
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileDirPath = [cachesDir stringByAppendingPathComponent:self.filePath];
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if (![fileManager fileExistsAtPath:fileDirPath]) {
//        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", fileDirPath];
        NSLog(@"源文件路径%@不存在，请检查源文件路径", fileDirPath);
        return;
    }
    BOOL success = [fileManager removeItemAtPath:fileDirPath error:nil];
    NSLog(@"removeFileFromCache=====%d",success);
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
