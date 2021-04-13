//
//  DownloadFileSource.h
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadFileSource : NSObject <NSCoding>

/// 文件资源ID 手动设置
@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) UIImage *sourceImg;
@property (nonatomic, copy) NSString *sourceUrlPath;
@property (nonatomic, copy) NSString *downloadStatusName;
@property (nonatomic, copy) NSString *downloadFullUrlPath;
/// 文件资源总大小 <所有文件块的总大小之和>
@property (nonatomic, assign) NSInteger totalFileSize;
/// 文件资源总片数 <所有文件块的总片数之和>
@property (nonatomic, assign) NSInteger totalFileFragment;
/// 上传完成成功的总片数
@property (nonatomic, assign) NSInteger totalSuccessFileFragment;
///上传进度
@property (nonatomic, assign) CGFloat downloadProgress;
/// 上传状态 <默认：队列数达到最大时是FileDownloadStatusWaiting，没达到时是FileDownloadStatusDownloading>
@property (nonatomic, assign) FileDownloadStatus downloadStatus;

//@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
//@property (nonatomic, strong) NSData *resumeData;
//@property (nonatomic, strong) NSURLSession *session;


@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) long long currentSize;
@property (nonatomic, strong, nullable) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

NS_ASSUME_NONNULL_END
