//
//  QHWPermissionManager.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/7.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWPermissionManager : NSObject

//检测是否开启网络
+ (void)openInternetService:(void (^)(BOOL isOpen))returnBlock;
//检测是否开启通知
+ (void)openNotificationService:(void (^)(BOOL isOpen))returnBlock;
//检测是否开启摄像头
+ (void)openCaptureDeviceService:(void (^)(BOOL isOpen))returnBlock;
//检测是否开启相册
+ (void)openAlbumService:(void (^)(BOOL isOpen))returnBlock;
//检测是否开启麦克风
+ (void)openRecordService:(void (^)(BOOL isOpen))returnBlock;
//检测是否开启定位
+ (void)openLocationService:(void (^)(BOOL isOpen))returnBlock;
+ (void)popAlertViewWithMsg:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
