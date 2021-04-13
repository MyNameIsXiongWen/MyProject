//
//  UploadFileSource.h
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileConstant.h"
#import "UploadFileBlock.h"
#import "UploadFileFragment.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileSource : NSObject <NSCoding>

/// 文件资源ID 手动设置
@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSString *sourceImgPath;
@property (nonatomic, copy) NSString *uploadStatusName;
@property (nonatomic, strong) UIImage *sourceImg;
/// 字符串数组，文件ID列表，服务器返回的文件ID列表
@property (nonatomic, copy) NSString *fileIds;
/// 文件资源总大小 <所有文件块的总大小之和>
@property (nonatomic, assign) NSInteger totalFileSize;
/// 文件资源总片数 <所有文件块的总片数之和>
@property (nonatomic, assign) NSInteger totalFileFragment;
/// 上传完成成功的总片数
@property (nonatomic, assign) NSInteger totalSuccessFileFragment;
///上传进度
@property (nonatomic, assign) CGFloat uploadProgress;
/// 上传状态 <默认：队列数达到最大时是FileUploadStatusWaiting，没达到时是FileUploadStatusUploading>
@property (nonatomic, assign) FileUploadStatus uploadStatus;
/// fileBlocks (该资源下的所有文件块)
@property (nonatomic, copy) NSArray <UploadFileBlock *> *fileBlocks;
/// fileFragments 该资源下的所有文件片
@property (nonatomic, copy) NSArray <UploadFileFragment *> *fileFragments;

@end

NS_ASSUME_NONNULL_END
