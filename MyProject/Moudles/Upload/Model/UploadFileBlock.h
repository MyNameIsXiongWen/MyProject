//
//  UploadFileBlock.h
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileFragment.h"
#import "UploadFileConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileBlock : NSObject <NSCoding>

/// 文件所属资源ID
@property (nonatomic, copy) NSString *sourceId;
/// 文件块ID
@property (nonatomic, copy) NSString *fileId;
/// 包括文件后缀名的文件名
@property (nonatomic, copy) NSString *fileName;
/// 文件所在路径 <相对路径>
@property (nonatomic, copy) NSString *filePath;
/// PHAsset 的唯一标识 ，用这个去获取 PHAsset对象，但是可能会因为用户从相册中删除，而获取不到 PHAsset
@property (nonatomic, copy) NSString *fileLocalIdentifier;
/// 缩略图
@property (nonatomic, copy) NSString *fileThumbImagePath;
@property (nonatomic, strong) UIImage *fileThumbImage;
/// 文件类型
@property (nonatomic, assign) FileType fileType;

/// 文件块总大小
@property (nonatomic, assign) NSInteger totalFileSize;
/// 文件块总片数
@property (nonatomic, assign) NSInteger totalFileFragment;
/// 上传成功的总片数
@property (nonatomic, assign) NSInteger totalSuccessFileFragment;
/// 文件分片数组
@property (nonatomic, copy) NSArray <UploadFileFragment*> *fileFragments;


/**
 初始化文件块
 @param path 文件所处Cache文件夹的相对路径
 @param fileId 文件ID
 @param sourceId 资源ID
 @return 文件块
 */
- (instancetype)initFileBlcokAtPath:(NSString *)path
                             fileId:(NSString *)fileId
                           sourceId:(NSString *)sourceId;

/// 将图片写入磁盘  返回文件相对路径 可为nil
+ (NSString *)writePictureFileToDisk:(NSData *)srcData;
/// 将文件移动到指定的文件夹中,主要作用就是将录制或者选择的视频文件，移动到指定的文件  返回文件相对路径 可为nil
+ (NSString *)moveVideoFileAtPath:(NSString *)srcPath;
/// 上传成功后从沙盒删除
- (void)removeFileFromCache;

@end

NS_ASSUME_NONNULL_END
