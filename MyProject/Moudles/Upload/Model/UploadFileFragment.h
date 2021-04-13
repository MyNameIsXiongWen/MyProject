//
//  UploadFileFragment.h
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileFragment : NSObject <NSCoding>

/// 文件资源ID
@property (nonatomic, copy) NSString *sourceId;
/// 文件块ID
@property (nonatomic, copy) NSString *fileId;
/// 该文件片所处的文件块的文件路径
@property (nonatomic, copy) NSString *filePath;
/// 片的大小
@property (nonatomic, assign) NSUInteger fragmentSize;
/// 片的偏移量
@property (nonatomic, assign) NSUInteger fragmentOffset;
/// 片的索引 --- 对应接口<`blockNo` 从1开始>
@property (nonatomic, assign) NSUInteger fragmentIndex;
/// 上传状态 <默认是FileUploadStatusWaiting>
@property (nonatomic, assign) FileUploadStatus uploadStatus;

/// 该文件片所处的文件块总大小
@property (nonatomic, assign) NSInteger totalFileSize;
/// 该文件片所处的文件块总片数
@property (nonatomic, assign) NSInteger totalFileFragment;
/// 包括文件后缀名的文件名
@property (nonatomic, copy) NSString *fileName;
/// fileType 文件类型
@property (nonatomic, assign) FileType fileType;

#pragma mark - Method
/// 获取请求头信息
- (NSDictionary *)fetchUploadParamsInfo;
/// 获取文件大小
- (NSData *)fetchFileFragmentData;

@end

NS_ASSUME_NONNULL_END
