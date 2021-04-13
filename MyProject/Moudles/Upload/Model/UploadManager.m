//
//  UploadManager.m
//  MyProject
//
//  Created by xiaobu on 2020/9/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UploadManager.h"

@interface UploadManager ()

@property (nonatomic, strong) NSMutableDictionary *uploadOperationQueueDict;

@end

@implementation UploadManager

+ (instancetype)sharedManager {
    static UploadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = UploadManager.new;
    });
    return manager;
}

- (UploadFileSource *)fetchFileSourceWithFileSourceId:(NSString *)fileSourceId {
    for (UploadFileSource *source in self.fileSourceArray) {
        if ([source.sourceId isEqualToString:fileSourceId]) {
            return source;
        }
    }
    return nil;
}

- (UploadFileSource *)fetchWaitingFileSource {
    for (UploadFileSource *tmpSource in self.fileSourceArray) {
        if (tmpSource.uploadStatus == FileUploadStatusWaiting) {
            return tmpSource;
        }
    }
    return nil;
}

- (NSMutableArray *)fetchAllUnuploadFragmentWithFileSourceId:(NSString *)fileSourceId {
    NSMutableArray *fragmentArray = NSMutableArray.array;
    for (UploadFileSource *source in self.fileSourceArray) {
        if ([source.sourceId isEqualToString:fileSourceId]) {
            for (UploadFileFragment *fragment in source.fileFragments) {
                if (fragment.uploadStatus != FileUploadStatusFinished) {
                    [fragmentArray addObject:fragment];
                }
            }
            break;
        }
    }
    return fragmentArray;
}

- (void)addSourceWithFileSource:(UploadFileSource *)fileSource {
    NSInteger uploadingQueueCount = 0;
    for (NSOperationQueue *queue in self.uploadOperationQueueDict.allValues) {
        if (!queue.isSuspended) {
            uploadingQueueCount++;
        }
    }
    if (uploadingQueueCount == UploadQueueMaxConut) {
        fileSource.uploadStatus = FileUploadStatusWaiting;
    } else {
        fileSource.uploadStatus = FileUploadStatusUploading;
        [self uploadSourceWithFileSource:fileSource];
    }
}

- (void)uploadSourceWithFileSource:(UploadFileSource *)fileSource {
    NSMutableArray *operationArray = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    for (UploadFileBlock *fileBlock in fileSource.fileBlocks) {
        for (UploadFileFragment *grament in fileBlock.fileFragments) {
            if (grament.uploadStatus != FileUploadStatusFinished) {
                dispatch_group_enter(group);
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *data = [grament fetchFileFragmentData];
                        // 模拟上传数据延迟
                        NSInteger randomNum = (NSInteger)((arc4random() % (2))+1);
                        [NSThread sleepForTimeInterval:randomNum];
                        NSLog(@"currentThread====%@", NSThread.currentThread);
                        grament.uploadStatus = FileUploadStatusFinished;
                        fileBlock.totalSuccessFileFragment++;
                        fileSource.totalSuccessFileFragment++;
                        //  有时候已经暂停了，但是队列操作已经发出去了，造成已经暂停却还在更新进度
                        if (fileSource.uploadStatus == FileUploadStatusUploading) {
                            [NSNotificationCenter.defaultCenter postNotificationName:FileUploadProgressDidChangedNotification object:@{FileUploadProgressDidChangedKey: @(fileSource.uploadProgress), FileUploadSourceIdKey: fileSource.sourceId}];
                        }
                        if (fileBlock.totalSuccessFileFragment == fileBlock.totalFileFragment) {
                            [fileBlock removeFileFromCache];
                        }
                        dispatch_group_leave(group);
                        /// 信号量+1 向下运行
                        dispatch_semaphore_signal(semaphore);
                    });
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                }];
                [operationArray addObject:operation];
            }
        }
    }
    
    NSOperationQueue *queue = NSOperationQueue.new;
    queue.maxConcurrentOperationCount = UploadQueueMaxConut;
    [queue addOperations:operationArray waitUntilFinished:NO];
    [self.uploadOperationQueueDict setValue:queue forKey:fileSource.sourceId];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        fileSource.uploadStatus = FileUploadStatusFinished;
        [self.uploadOperationQueueDict removeObjectForKey:fileSource.sourceId];
        [self removeFileSourceDataFromCache:fileSource];
        [NSNotificationCenter.defaultCenter postNotificationName:UploadFileSourceChangedNotification object:nil];
        NSLog(@"sourceId===%@上传完成", fileSource.sourceId);
        [self uploadWaitingFileSource];
    });
}

- (void)uploadWaitingFileSource {
    UploadFileSource *waitingSource = [self fetchWaitingFileSource];
    if (waitingSource) {
        waitingSource.uploadStatus = FileUploadStatusUploading;
        [NSNotificationCenter.defaultCenter postNotificationName:FileUploadStatusDidChangedNotification object:@{FileUploadSourceIdKey: waitingSource.sourceId, FileUploadStatusDidChangedKey: @(waitingSource.uploadStatus)}];
        NSOperationQueue *queue = self.uploadOperationQueueDict[waitingSource.sourceId];
        if (queue) {
            [queue setSuspended:NO];
        } else {
            [self uploadSourceWithFileSource:waitingSource];
        }
    } else {
        NSLog(@"++++ 未找到待上传资源 ++++");
    }
}

- (void)suspendUploadOperationQueueWithFileSourceId:(NSString *)fileSourceId {
    NSOperationQueue *queue = self.uploadOperationQueueDict[fileSourceId];
    if (queue) {
        [queue setSuspended:YES];
    } else {
        NSLog(@"++++ 未找到要暂停的上传队列 ++++");
    }
    
    UploadFileSource *source = [self fetchFileSourceWithFileSourceId:fileSourceId];
    source.uploadStatus = FileUploadStatusSuspend;
    [NSNotificationCenter.defaultCenter postNotificationName:FileUploadStatusDidChangedNotification object:@{FileUploadSourceIdKey: fileSourceId, FileUploadStatusDidChangedKey: @(source.uploadStatus)}];
    for (UploadFileBlock *fileBlock in source.fileBlocks) {
        for (UploadFileFragment *fragment in fileBlock.fileFragments) {
            if (fragment.uploadStatus != FileUploadStatusFinished) {
                fragment.uploadStatus = FileUploadStatusSuspend;
            }
        }
    }
    
//    暂停了当前这一个就要去开始下一个待上传的资源了
    [self uploadWaitingFileSource];
}

- (void)resumeUploadOperationQueueWithFileSourceId:(NSString *)fileSourceId {
    NSInteger uploadingQueueCount = 0;
    for (NSOperationQueue *queue in self.uploadOperationQueueDict.allValues) {
        if (!queue.isSuspended) {
            uploadingQueueCount++;
        }
    }
    UploadFileSource *source = [self fetchFileSourceWithFileSourceId:fileSourceId];
    //如果有正在上传的队列（肯定不是自己，如果是自己的话那么就不会走resume方法），那么自己的状态就只是等待中
    if (uploadingQueueCount == UploadQueueMaxConut) {
        source.uploadStatus = FileUploadStatusWaiting;
    } else {
        //如果没有正在上传的队列，再看当前资源是否存在上传队列，如果存在，那么重启就可以（正常情况下肯定有的，因为是resume）
        NSOperationQueue *existCurrentSourceQueue = self.uploadOperationQueueDict[fileSourceId];
        source.uploadStatus = FileUploadStatusUploading;
        if (existCurrentSourceQueue) {
            [existCurrentSourceQueue setSuspended:NO];
        } else {
            [self uploadSourceWithFileSource:source];
        }
    }
    [NSNotificationCenter.defaultCenter postNotificationName:FileUploadStatusDidChangedNotification object:@{FileUploadSourceIdKey: fileSourceId, FileUploadStatusDidChangedKey: @(source.uploadStatus)}];
}

- (void)archiveUploadFileSource:(UploadFileSource *)fileSource {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:UploadFileSourcePath];
    
    if (fileSource) {
        if (self.fileSourceArray.count == 0) {
            [self.fileSourceArray addObject:fileSource];
        } else {
            BOOL exist = NO;
            for (int i=0; i<self.fileSourceArray.count; i++) {
                UploadFileSource *source = self.fileSourceArray[i];
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

- (NSMutableArray *)unArchiveUploadFileSource {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:UploadFileSourcePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if ([data isKindOfClass:NSData.class]) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return [NSMutableArray arrayWithArray:array];
    } else {
        return NSMutableArray.array;
    }
}

- (void)removeFileSourceDataFromCache:(UploadFileSource *)fileSource {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:UploadFileSourcePath];
    
    for (int i=0; i<self.fileSourceArray.count; i++) {
        UploadFileSource *source = self.fileSourceArray[i];
        if ([source.sourceId isEqualToString:fileSource.sourceId]) {
            [self.fileSourceArray removeObjectAtIndex:i];
            break;
        }
    }
    BOOL success = [NSKeyedArchiver archiveRootObject:self.fileSourceArray toFile:path];
    NSLog(@"removeFileSourceDataFromCache=====%d",success);
}

- (NSMutableDictionary *)uploadOperationQueueDict {
    if (!_uploadOperationQueueDict) {
        _uploadOperationQueueDict = NSMutableDictionary.dictionary;
    }
    return _uploadOperationQueueDict;
}

- (NSMutableArray *)fileSourceArray {
    if (!_fileSourceArray) {
        _fileSourceArray = [self unArchiveUploadFileSource];
        for (UploadFileSource *source in _fileSourceArray.reverseObjectEnumerator) {
            if (source.uploadStatus == FileUploadStatusFinished) {
                [_fileSourceArray removeObject:source];
            }
            if (source.uploadStatus == FileUploadStatusUploading) {
                source.uploadStatus = FileUploadStatusSuspend;
            }
        }
    }
    return _fileSourceArray;
}

@end
