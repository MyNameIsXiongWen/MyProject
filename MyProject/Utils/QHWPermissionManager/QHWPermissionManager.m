//
//  QHWPermissionManager.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/7.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWPermissionManager.h"
#import <CoreTelephony/CTCellularData.h>
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@implementation QHWPermissionManager

#pragma mark ------------public methods-------------

//检测是否开启网络
+ (void)openInternetService:(void (^)(BOOL))returnBlock {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataNotRestricted || state == kCTCellularDataRestrictedStateUnknown) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (returnBlock) {
                returnBlock(YES);
            }
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnBlock) {
            returnBlock(NO);
        }
    });
}

//检测是否开启通知
+ (void)openNotificationService:(void (^)(BOOL))returnBlock {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (returnBlock) {
                    returnBlock(granted);
                }
            });
        });
    }];
}

//检测是否开启摄像头
+ (void)openCaptureDeviceService:(void (^)(BOOL))returnBlock {
    BOOL isOpen;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                [QHWPermissionManager popAlertViewWithMsg:@"相机权限暂未开启，是否前往开启？"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (returnBlock) {
                    returnBlock(granted);
                }
            });
        }];
        isOpen = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isOpen = NO;
        [QHWPermissionManager popAlertViewWithMsg:@"相机权限暂未开启，是否前往开启？"];
    } else {
        isOpen = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnBlock) {
            returnBlock(isOpen);
        }
    });
}

//检测是否开启相册
+ (void)openAlbumService:(void (^)(BOOL))returnBlock {
    BOOL isOpen;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
                [QHWPermissionManager popAlertViewWithMsg:@"相册权限暂未开启，是否前往开启？"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (returnBlock) {
                        returnBlock(NO);
                    }
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (returnBlock) {
                        returnBlock(YES);
                    }
                });
            }
        }];
        isOpen = NO;
    }
    else if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        isOpen = NO;
        [QHWPermissionManager popAlertViewWithMsg:@"相册权限暂未开启，是否前往开启？"];
    } else {
        isOpen = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnBlock) {
            returnBlock(isOpen);
        }
    });
}

//检测是否开启麦克风
+ (void)openRecordService:(void (^)(BOOL))returnBlock {
    BOOL isOpen;
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                [QHWPermissionManager popAlertViewWithMsg:@"麦克风权限暂未开启，是否前往开启？"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (returnBlock) {
                    returnBlock(granted);
                }
            });
        }];
        isOpen = NO;
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        isOpen = NO;
        [QHWPermissionManager popAlertViewWithMsg:@"麦克风权限暂未开启，是否前往开启？"];
    } else {
        isOpen = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnBlock) {
            returnBlock(isOpen);
        }
    });
}

//检测是否开启定位:
+ (void)openLocationService:(void (^)(BOOL))returnBlock {
    BOOL isOpen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOpen = YES;
    }
    if (!isOpen) {
        [QHWPermissionManager popAlertViewWithMsg:@"定位权限暂未开启，是否前往开启？"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnBlock) {
            returnBlock(isOpen);
        }
    });
}

+ (void)popAlertViewWithMsg:(NSString *)message {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
//    prefs:root=LOCATION_SERVICES
//    prefs:root=Photos
}

@end
