//
//  DownloadManager.m
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DownloadManager.h"
#import <objc/runtime.h>

@interface DownloadManager () <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableDictionary *downloadOperationQueueDict;

@end

@implementation DownloadManager

+ (instancetype)sharedManager {
    static DownloadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = DownloadManager.new;
    });
    return manager;
}

- (DownloadFileSource *)fetchFileSourceWithFileSourceId:(NSString *)fileSourceId {
    for (DownloadFileSource *source in self.fileSourceArray) {
        if ([source.sourceId isEqualToString:fileSourceId]) {
            return source;
        }
    }
    return nil;
}

- (DownloadFileSource *)fetchWaitingFileSource {
    for (DownloadFileSource *tmpSource in self.fileSourceArray) {
        if (tmpSource.downloadStatus == FileDownloadStatusWaiting) {
            return tmpSource;
        }
    }
    return nil;
}

- (void)addSourceWithFileSource:(DownloadFileSource *)fileSource {
    NSInteger downloadingQueueCount = 0;
    for (DownloadFileSource *source in self.fileSourceArray) {
        if (source.dataTask.state == NSURLSessionTaskStateRunning) {
            downloadingQueueCount++;
        }
    }
    if (downloadingQueueCount >= UploadQueueMaxConut) {
        fileSource.downloadStatus = FileDownloadStatusWaiting;
    } else {
        fileSource.downloadStatus = FileDownloadStatusDownloading;
        [self downloadSourceWithFileSource:fileSource];
    }
}

- (void)downloadSourceWithFileSource:(DownloadFileSource *)fileSource {
    if (!fileSource.dataTask) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileSource.sourceUrlPath]];
        NSString *fullUrlPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileSource.sourceId];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:fullUrlPath error:nil];
        if (fileDict) {
            fileSource.currentSize = [[fileDict valueForKey:@"NSFileSize"] integerValue];
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-",fileSource.currentSize];
            [request setValue:range forHTTPHeaderField:@"Range"];
        }
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        objc_setAssociatedObject(session, @"FileSourceId", fileSource.sourceId, OBJC_ASSOCIATION_COPY_NONATOMIC);
        fileSource.dataTask = [session dataTaskWithRequest:request];
        [fileSource.dataTask resume];
    } else {
        [fileSource.dataTask resume];
    }
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileSource.sourceUrlPath]];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:NSOperationQueue.mainQueue];
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
//    [downloadTask resume];
//    fileSource.downloadTask = downloadTask;
}

//#pragma mark ------------NSURLSessionDownloadDelegate-------------
///**
// * 写数据
// * @param bytesWritten 本次写入数据大小
// * @param totalBytesWritten 下载数据总大小
// * @param totalBytesExpectedToWrite 文件总大小
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
////1.文件下载进度
//    CGFloat progress = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
//    NSLog(@"--%.2f%%",100.0*progress);
//    NSString *sourceId = objc_getAssociatedObject(session, @"FileSourceId");
//    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:sourceId];
//    source.downloadProgress = progress;
//    if (source.downloadStatus == FileDownloadStatusDownloading) {
//        [NSNotificationCenter.defaultCenter postNotificationName:FileDownloadProgressDidChangedNotification object:@{FileDownloadProgressDidChangedKey: @(source.downloadProgress), FileDownloadSourceIdKey: source.sourceId}];
//    }
//}
///**
// * 恢复下载
// * @param fileOffset 恢复从哪里位置下载
// * @param expectedTotalBytes 文件总大小
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
//
//}
///**
// * 下载完成
// * @param location 文件临时存储路径
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
//    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
//    NSLog(@"%@",fullPath);
//
//    NSString *sourceId = objc_getAssociatedObject(session, @"FileSourceId");
//    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:sourceId];
//    source.downloadStatus = FileDownloadStatusFinished;
//    [NSNotificationCenter.defaultCenter postNotificationName:DownloadFileSourceChangedNotification object:nil];
//    [self downloadWaitingFileSource];
//}
///**
// * 请求结束
// */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    NSLog(@"didCompleteWithError");
//}

#pragma mark ------------NSURLSessionDataDelegate-------------
//1.接收服务器的响应，默认取消该请求
//completionHandler 回调 传给系统
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    NSURLSessionResponseCancel = 0,取消
//    NSURLSessionResponseAllow = 1,接收
//    NSURLSessionResponseBecomeDownload = 2,下载任务
//    NSURLSessionResponseBecomeStream API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) = 3,下载任务
    NSString *sourceId = objc_getAssociatedObject(session, @"FileSourceId");
    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:sourceId];
    if (source.currentSize == 0) {
        [[NSFileManager defaultManager] createFileAtPath:source.downloadFullUrlPath contents:nil attributes:nil];
    }
    
    source.fileHandle = [NSFileHandle fileHandleForWritingAtPath:source.downloadFullUrlPath];
    source.totalSize = response.expectedContentLength+source.currentSize;
    if (response.expectedContentLength == -1) {
        completionHandler(NSURLSessionResponseCancel);
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}
//2.收到返回数据，多次调用
//拼接存储数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *sourceId = objc_getAssociatedObject(session, @"FileSourceId");
    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:sourceId];
    [source.fileHandle seekToEndOfFile];
    [source.fileHandle writeData:data];
    source.currentSize += data.length;
    CGFloat progress = (CGFloat)source.currentSize / source.totalSize;
    source.downloadProgress = progress;
    if (source.downloadStatus == FileDownloadStatusDownloading) {
        [NSNotificationCenter.defaultCenter postNotificationName:FileDownloadProgressDidChangedNotification object:@{FileDownloadProgressDidChangedKey: @(source.downloadProgress), FileDownloadSourceIdKey: source.sourceId}];
    }
}
//3.请求结束或失败时调用
//解析数据
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSString *sourceId = objc_getAssociatedObject(session, @"FileSourceId");
    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:sourceId];
    [source.fileHandle closeFile];
    source.fileHandle = nil;
    NSLog(@"didCompleteWithError:%@",source.downloadFullUrlPath);
    source.downloadStatus = FileDownloadStatusFinished;
    [NSNotificationCenter.defaultCenter postNotificationName:DownloadFileSourceChangedNotification object:nil];
    [self downloadWaitingFileSource];
}

- (void)downloadWaitingFileSource {
    DownloadFileSource *waitingSource = [self fetchWaitingFileSource];
    if (waitingSource) {
        waitingSource.downloadStatus = FileDownloadStatusDownloading;
        [NSNotificationCenter.defaultCenter postNotificationName:FileDownloadStatusDidChangedNotification object:@{FileDownloadSourceIdKey: waitingSource.sourceId, FileDownloadStatusDidChangedKey: @(waitingSource.downloadStatus)}];
        if (waitingSource.dataTask) {
            [waitingSource.dataTask resume];
        } else {
            [self downloadSourceWithFileSource:waitingSource];
        }
    } else {
        NSLog(@"++++ 未找到待下载资源 ++++");
    }
}

- (void)suspendDownloadOperationQueueWithFileSourceId:(NSString *)fileSourceId {
    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:fileSourceId];
    source.downloadStatus = FileDownloadStatusSuspend;
    [NSNotificationCenter.defaultCenter postNotificationName:FileDownloadStatusDidChangedNotification object:@{FileDownloadSourceIdKey: fileSourceId, FileDownloadStatusDidChangedKey: @(source.downloadStatus)}];
    if (source.dataTask) {
        [source.dataTask suspend];
    }
    
//    暂停了当前这一个就要去开始下一个待下载的资源了
    [self downloadWaitingFileSource];
}

- (void)resumeDownloadOperationQueueWithFileSourceId:(NSString *)fileSourceId {
    NSInteger downloadingQueueCount = 0;
    for (DownloadFileSource *source in self.fileSourceArray) {
        if (source.dataTask.state == NSURLSessionTaskStateRunning) {
            downloadingQueueCount++;
        }
    }
    DownloadFileSource *source = [self fetchFileSourceWithFileSourceId:fileSourceId];
    //如果有正在下载的队列（肯定不是自己，如果是自己的话那么就不会走resume方法），那么自己的状态就只是等待中
    if (downloadingQueueCount >= UploadQueueMaxConut) {
        source.downloadStatus = FileDownloadStatusWaiting;
    } else {
        source.downloadStatus = FileDownloadStatusDownloading;
        if (source.dataTask) {
            [source.dataTask resume];
        } else {
            [self downloadSourceWithFileSource:source];
        }
    }
    [NSNotificationCenter.defaultCenter postNotificationName:FileDownloadStatusDidChangedNotification object:@{FileDownloadSourceIdKey: fileSourceId, FileDownloadStatusDidChangedKey: @(source.downloadStatus)}];
}

- (void)archiveDownloadFileSource:(DownloadFileSource *)fileSource {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:DownloadFileSourcePath];
    
    if (fileSource) {
        if (self.fileSourceArray.count == 0) {
            [self.fileSourceArray addObject:fileSource];
        } else {
            BOOL exist = NO;
            for (int i=0; i<self.fileSourceArray.count; i++) {
                DownloadFileSource *source = self.fileSourceArray[i];
                if ([source.sourceId isEqualToString:fileSource.sourceId]) {
                    [self.fileSourceArray replaceObjectAtIndex:i withObject:fileSource];
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
                [self.fileSourceArray addObject:fileSource];
            }
        }
    }
    BOOL success = [NSKeyedArchiver archiveRootObject:self.fileSourceArray toFile:path];
    NSLog(@"archiveUploadFileSource=====%d",success);
}

- (NSMutableArray *)unArchiveDownloadFileSource {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:DownloadFileSourcePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if ([data isKindOfClass:NSData.class]) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return [NSMutableArray arrayWithArray:array];
    } else {
        return NSMutableArray.array;
    }
}

- (NSMutableArray *)fileSourceArray {
    if (!_fileSourceArray) {
        _fileSourceArray = [self unArchiveDownloadFileSource];
        for (DownloadFileSource *source in _fileSourceArray.reverseObjectEnumerator) {
            if (source.downloadStatus == FileDownloadStatusFinished) {
                [_fileSourceArray removeObject:source];
            }
            if (source.downloadStatus == FileDownloadStatusDownloading) {
                source.downloadStatus = FileDownloadStatusSuspend;
            }
        }
    }
    return _fileSourceArray;
}

@end
