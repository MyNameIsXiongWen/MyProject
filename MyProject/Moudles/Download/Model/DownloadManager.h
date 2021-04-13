//
//  DownloadManager.h
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadFileSource.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const DownloadFileSourcePath = @"com.myproject.downloadFileSource";
/// 下载资源发生改变（增减）
static NSString *const DownloadFileSourceChangedNotification = @"DownloadFileSourceChangedNotification";
/// 某资源下载状态改变
static NSString *const FileDownloadStatusDidChangedNotification = @"FileDownloadStatusDidChangedNotification";
/// 某资源的状态
static NSString *const FileDownloadStatusDidChangedKey = @"FileDownloadStatusDidChangedKey";

/// 某资源上传进度
static NSString *const FileDownloadProgressDidChangedNotification = @"FileDownloadProgressDidChangedNotification";
/// 某资源的进度Key
static NSString *const FileDownloadProgressDidChangedKey = @"FileDownloadProgressDidChangedKey";
/// 某资源的id
static NSString *const FileDownloadSourceIdKey = @"FileDownloadSourceIdKey";

@interface DownloadManager : NSObject

@property (nonatomic, strong) NSMutableArray <DownloadFileSource *>*fileSourceArray;

+ (instancetype)sharedManager;

/// 根据filesourceid暂停下载当前这个filesource
- (void)suspendDownloadOperationQueueWithFileSourceId:(NSString *)fileSourceId;
/// 根据filesourceid重启下载当前这个filesource
- (void)resumeDownloadOperationQueueWithFileSourceId:(NSString *)fileSourceId;

///根据sourceid拿到filesource
- (DownloadFileSource *)fetchFileSourceWithFileSourceId:(NSString *)fileSourceId;
///找到下一个待下载的filesource
- (DownloadFileSource *)fetchWaitingFileSource;

- (void)addSourceWithFileSource:(DownloadFileSource *)fileSource;
///下载当前这个filesource
- (void)downloadSourceWithFileSource:(DownloadFileSource *)fileSource;
/// 归档
- (void)archiveDownloadFileSource:(nullable DownloadFileSource *)fileSource;
///解归档
- (NSMutableArray *)unArchiveDownloadFileSource;

@end

NS_ASSUME_NONNULL_END
