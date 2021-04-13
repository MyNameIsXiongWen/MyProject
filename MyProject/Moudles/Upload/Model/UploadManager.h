//
//  UploadManager.h
//  MyProject
//
//  Created by xiaobu on 2020/9/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileSource.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UploadFileSourcePath = @"com.myproject.uploadFileSource";
/// 上传资源发生改变（增减）
static NSString *const UploadFileSourceChangedNotification = @"UploadFileSourceChangedNotification";
/// 某资源上传状态改变
static NSString *const FileUploadStatusDidChangedNotification = @"FileUploadStatusDidChangedNotification";
/// 某资源的状态
static NSString *const FileUploadStatusDidChangedKey = @"FileUploadStatusDidChangedKey";


/// 某资源上传进度
static NSString *const FileUploadProgressDidChangedNotification = @"FileUploadProgressDidChangedNotification";
/// 某资源的进度Key
static NSString *const FileUploadProgressDidChangedKey = @"FileUploadProgressDidChangedKey";
/// 某资源的id
static NSString *const FileUploadSourceIdKey = @"FileUploadSourceIdKey";

@interface UploadManager : NSObject

@property (nonatomic, strong) NSMutableArray <UploadFileSource *>*fileSourceArray;

+ (instancetype)sharedManager;

/// 根据filesourceid暂停上传当前这个filesource
- (void)suspendUploadOperationQueueWithFileSourceId:(NSString *)fileSourceId;
/// 根据filesourceid重启上传当前这个filesource
- (void)resumeUploadOperationQueueWithFileSourceId:(NSString *)fileSourceId;

///根据sourceid拿到filesource
- (UploadFileSource *)fetchFileSourceWithFileSourceId:(NSString *)fileSourceId;
///找到下一个待上传的filesource
- (UploadFileSource *)fetchWaitingFileSource;
///根据sourceid找到这个filesource下所有未上传的文件片
- (NSMutableArray *)fetchAllUnuploadFragmentWithFileSourceId:(NSString *)fileSourceId;

- (void)addSourceWithFileSource:(UploadFileSource *)fileSource;
///上传当前这个filesource
- (void)uploadSourceWithFileSource:(UploadFileSource *)fileSource;
/// 归档
- (void)archiveUploadFileSource:(nullable UploadFileSource *)fileSource;
///解归档
- (NSMutableArray *)unArchiveUploadFileSource;
///从沙盒目录删除掉当前filesource
- (void)removeFileSourceFromCache:(UploadFileSource *)fileSource;

@end

NS_ASSUME_NONNULL_END
