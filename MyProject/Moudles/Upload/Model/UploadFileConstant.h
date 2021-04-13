//
//  UploadFileConstant.h
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 每片大小 512k
#define UploadFileFragmentMaxSize  512*1024
/// 最多同时开启2个队列
#define UploadQueueMaxConut  2

/// 最多上传50个文件
FOUNDATION_EXTERN NSInteger const UploadFileMaxCount;
/// 上传资源存放的文件夹名称
FOUNDATION_EXTERN NSString *const UploadFileCacheDirName;
/// 下载资源存放的文件夹名称
FOUNDATION_EXTERN NSString *const DownloadFileCacheDirName;

typedef enum : NSUInteger {
    FileUploadStatusWaiting = 0,    //等待中（可以自动上传）
    FileUploadStatusSuspend,        //暂停（不可以自动上传）
    FileUploadStatusUploading,      //上传中
    FileUploadStatusFinished,       //已上传完成
    FileUploadStatusDraft,          //草稿箱
} FileUploadStatus;

typedef enum : NSUInteger {
    FileDownloadStatusWaiting = 0,    //等待中（可以自动下载）
    FileDownloadStatusSuspend,        //暂停（不可以自动下载）
    FileDownloadStatusDownloading,    //下载中
    FileDownloadStatusFinished,       //已下载完成
    FileDownloadStatusDraft,          //草稿箱
} FileDownloadStatus;

typedef enum : NSUInteger {
    FileTypeNone = -1,  // 添加按钮
    FileTypePhoto = 0,  // 图片
    FileTypeVideo = 1,  // 视频
} FileType;

@interface UploadFileConstant : NSObject

@end

NS_ASSUME_NONNULL_END
