//
//  HttpManager.h
//  MANKUProject
//
//  Created by jason on 2018/6/27.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HttpManager : AFHTTPSessionManager

/**
 单例
 
 @return AFHTTPSessionManager
 */
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithJson;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 发送delete请求

 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param success 请求成功的回调
 @param fail 请求失败的回调
 */
- (void)DELETE:(NSString *)URLString
    parameters:(NSDictionary *)parameters
       success:(void (^)(id responseObject))success
          fail:(void (^)(NSError *error))fail;

/**
 *  发送put请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param fail       请求失败的回调
 */
- (void)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(id responseObject))success
       fail:(void (^)(NSError *error))fail;

/**
 *  上传图片
 *
 *  @param URLString    上传图片的网址字符串
 *  @param parameters   上传图片的参数
 *  @param uploadParams 上传图片的信息
 *  @param success      上传成功的回调
 *  @param failure      上传失败的回调
 */
- (void)UPLOAD:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(NSArray *)uploadParams
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
      progress:(void (^)(NSProgress *uploadProgress))progress;

/**
 *  下载数据
 *
 *  @param URLString   下载数据的网址
 *  @param parameters  下载数据的参数
 *  @param success     下载成功的回调
 *  @param failure     下载失败的回调
 */
- (void)DOWNLOAD:(NSString *)URLString
      parameters:(id)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
        progerss:(void (^)(NSProgress *downloadProgress))progress;

@end
