//
//  HttpManager.m
//  MANKUProject
//
//  Created by jason on 2018/6/27.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "HttpManager.h"
#import "NSString+Category.h"

@implementation HttpManager

static id _instance = nil;

+ (instancetype)sharedInstance {
    static HttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HttpManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json", @"text/html",@"text/plain",@"application/x-www-form-urlencoded", nil];
        manager.requestSerializer.timeoutInterval = 30;
    });
    return manager;
}

+ (instancetype)sharedInstanceWithJson {
    static HttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HttpManager manager];
        manager.requestSerializer = AFJSONRequestSerializer.serializer;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json", @"text/html",@"text/plain",@"application/x-www-form-urlencoded", nil];
        manager.requestSerializer.timeoutInterval = 30;
    });
    return manager;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [super allocWithZone:zone];
//    });
//    return _instance;
//}

- (void)monitorInternet {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无法联网");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"当前在WIFI网络下");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"当前使用的是2G/3G/4G网络");
            }
        }
    }];
}

- (void)configSuccessResponseResult:(id  _Nullable)responseObject url:(NSString *)url {
    [SVProgressHUD dismiss];
    if ([[responseObject allKeys] containsObject:@"returnCode"]
        && [responseObject[@"returnCode"] integerValue] == 0) {
    }
//    else if ([responseObject[@"returnCode"] integerValue] == 1 || [responseObject[@"returnCode"] integerValue] == 2)
//    {
//        [SVProgressHUD showErrorWithStatus:@" 登录已过期,请退出登陆后重新登录"];
//    }
    else {
        [SVProgressHUD showErrorWithStatus:responseObject[@"returnMsg"]];
    }
}

- (void)configFailResult:(NSError * _Nonnull)error {
    [SVProgressHUD dismiss];
    if (error.code == 1001) [SVProgressHUD showErrorWithStatus:@"请求超时"];
    else [SVProgressHUD showErrorWithStatus:@"请求失败"];
}

#pragma mark -- GET请求 --
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    [self setRequestHttpHeaderWithParameters:parameters];
    [self GET:[NSString stringWithFormat:@"%@%@",kMainURL,URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:nil];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    [self setRequestHttpHeaderWithParameters:parameters];
    [self POST:[NSString stringWithFormat:@"%@%@",kMainURL,URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:URLString];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- DELETE请求 --
- (void)DELETE:(NSString *)URLString
    parameters:(NSDictionary *)parameters
       success:(void (^)(id))success
          fail:(void (^)(NSError *))fail {
    [self setRequestHttpHeaderWithParameters:parameters];
    [self DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:URLString];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (fail) {
            fail(error);
        }
    }];
}
#pragma mark -- PUT请求 --
- (void)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(id))success
       fail:(void (^)(NSError *))fail {
    [self setRequestHttpHeaderWithParameters:parameters];
    [self PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:URLString];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark -- 上传数据 --
- (void)UPLOAD:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(NSArray *)uploadParams
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure
      progress:(void (^)(NSProgress *))progress {
    [self setRequestHttpHeaderWithParameters:parameters];
    [self POST:[NSString stringWithFormat:@"%@%@",kMainURL,URLString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<uploadParams.count; i++) {
            UIImage *image = uploadParams[i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            NSUInteger size =  [imageData length]/1024;
            if (size > 100){
                imageData = UIImageJPEGRepresentation(image,100/size);
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *time = [formatter stringFromDate:[NSDate date]];
//            NSString *name = [NSString stringWithFormat:@"%@%dimage",time,i];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",time,i];
            [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self configSuccessResponseResult:responseObject url:URLString];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self configFailResult:error];
        if (failure) {
            failure(error);
        }
    }];
}
 
#pragma mark -- 下载数据 --
- (void)DOWNLOAD:(NSString *)URLString
      parameters:(id)parameters
         success:(void (^)(id))success
         failure:(void (^)(NSError *))failure
        progerss:(void (^)(NSProgress *))progress {
//    [self setRequestHttpHeaderWithParameters:parameters];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:fullPath];
//        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (success) {
            success(filePath);
        }
        if (failure) {
            failure(error);
        }
    }];
    [downLoadTask resume];
}

#pragma mark ------------设置请求头-------------
- (void)setRequestHttpHeaderWithParameters:(id)parameters {
//    NSString *timeStamp = [self stringWithTimeStamp];
//    NSString *randomStr = [self getRandomString];
//    [self.requestSerializer setValue:[self sortDataWithParams:parameters timeStamp:timeStamp randomStr:randomStr] forHTTPHeaderField:@"signature"];
//    [self.requestSerializer setValue:randomStr forHTTPHeaderField:@"noncestr"];
//    [self.requestSerializer setValue:timeStamp forHTTPHeaderField:@"timestamp"];
//    [self.requestSerializer setValue:kAppKey forHTTPHeaderField:@"authorization"];
//    if (kTOKEN) {
//        [self.requestSerializer setValue:kTOKEN forHTTPHeaderField:@"mkshoptoken"];
//    }
//    else {
//        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"mkshoptoken"];
//    }
//    if (kSHOPID) {
//        [self.requestSerializer setValue:kSHOPID forHTTPHeaderField:@"mkshopid"];
//    }
//    else {
//        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"mkshopid"];
//    }
}

#pragma mark 获得时间戳
- (NSString *)stringWithTimeStamp {
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld",(long)([date timeIntervalSince1970] * 1000)];
    return dateStr;
}

- (NSString *)getRandomString {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}

///处理参数及排序
//- (NSString *)sortDataWithParams:(NSDictionary *)dic timeStamp:(NSString *)timeStamp randomStr:(NSString *)randomStr {
//    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    resultDic[@"authorization"] = kAppKey;
//    resultDic[@"timestamp"] = timeStamp;
//    resultDic[@"noncestr"] = randomStr;
//    if (kTOKEN) {
//        resultDic[@"token"] = kTOKEN;
//    }
//    NSString *sortStr = @"";
//    for (NSString *keyStr in [resultDic.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
//        if ([resultDic[keyStr] isKindOfClass:[NSArray class]]) {
//            if (((NSArray *)resultDic[keyStr]).count == 0) {
//                continue;
//            }
//        }
//        if ([resultDic[keyStr] isKindOfClass:[NSString class]]) {
//            if (((NSString *)resultDic[keyStr]).length == 0) {
//                continue;
//            }
//        }
//        if ([resultDic[keyStr] isKindOfClass:[NSDictionary class]]) {
//            if (((NSDictionary *)resultDic[keyStr]).allKeys.count == 0) {
//                continue;
//            }
//        }
//        sortStr = [sortStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keyStr,resultDic[keyStr]]];
//    }
//    if (sortStr.length > 0) {
//        sortStr = [sortStr substringToIndex:sortStr.length - 1];
//    }
//    sortStr = [NSString stringWithFormat:@"%@&key=%@",sortStr,kAppSecret];
//    NSString *signature = [sortStr.md5Str uppercaseString];
////    NSLog(@"\n%@==========%@",sortStr,signature);
//    return signature;
//}

//处理url(get时 URL里面的参数在包装签名时拿不到，所以要处理一下)
- (NSString *)seperateURL:(NSString *)url paramsDic:(NSMutableDictionary *)paramsDic {
    if (![url containsString:@"?"]) {
        return url;
    }
    NSString *paramsStr = [url componentsSeparatedByString:@"?"].lastObject;
    for (NSString *str in [paramsStr componentsSeparatedByString:@"&"]) {
        NSArray *array = [str componentsSeparatedByString:@"="];
        if (array.count == 2) {
            [paramsDic setObject:array.lastObject forKey:array.firstObject];
        }
    }
    return [url componentsSeparatedByString:@"?"].firstObject;
}

@end
