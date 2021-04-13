//
//  LiveViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/7/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveViewController.h"
#import <LFLiveKit.h>
#import <ReplayKit/ReplayKit.h>

@interface LiveViewController () <LFLiveSessionDelegate, RPBroadcastActivityViewControllerDelegate, RPBroadcastControllerDelegate>

@property (nonatomic, strong) UIButton *beautyBtn;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, strong) RPBroadcastController *broadcastController;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView;

@end

@implementation LiveViewController

- (void)dealloc {
    [self stopLive];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.beautyBtn = [UIButton initWithFrame:CGRectMake(0, 0, 40, 40) Title:NSLocalizedString(@"BeautyFace", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.orangeColor BackgroundColor:UIColor.whiteColor CornerRadius:5];
    [self.beautyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [self.beautyBtn addTarget:self action:@selector(clickBeautyBtn) forControlEvents:UIControlEventTouchUpInside];
    self.switchCameraBtn = [UIButton initWithFrame:CGRectMake(0, 0, 40, 40) Title:NSLocalizedString(@"Switch", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [self.switchCameraBtn addTarget:self action:@selector(clickCameraBtn) forControlEvents:UIControlEventTouchUpInside];

    self.shareBtn = [UIButton initWithFrame:CGRectMake(0, 0, 60, 40) Title:NSLocalizedString(@"ShareScreen", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [self.shareBtn setTitle:NSLocalizedString(@"ExitShare", nil) forState:UIControlStateSelected];
    [self.shareBtn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.beautyBtn], [[UIBarButtonItem alloc] initWithCustomView:self.switchCameraBtn], [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn]];
    
    UIView *testView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 100, 100)];
        [view setBackgroundColor:[UIColor purpleColor]];
        view;
    });
    [self.view addSubview:testView];
    
    {
        /*
         这个动画会让直播一直有视频帧
         动画类型不限，只要屏幕是变化的就会有视频帧
         */
        [testView.layer removeAllAnimations];
        CABasicAnimation *rA = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rA.duration = 3.0;
        rA.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rA.repeatCount = MAXFLOAT;
        rA.removedOnCompletion = NO;
        [testView.layer addAnimation:rA forKey:@""];
    }
    
//    [self requestAccessForAudio];
//    [self requestAccessForVideo];
    
//    [self startLive];
    
    UIButton *statrButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [statrButton setFrame:CGRectMake(100, 400, 100, 50)];
    statrButton.backgroundColor = UIColor.whiteColor;
    [statrButton setTitle:@"Start" forState:UIControlStateNormal];
    // 点击开始推流
    [statrButton addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
    _broadPickerView = [[RPSystemBroadcastPickerView alloc] initWithFrame:statrButton.frame];
    _broadPickerView.preferredExtension = @"com.manku.MyProject1.BroadExt";
    [self.view addSubview:_broadPickerView];
    [self.view addSubview:statrButton];
}

- (void)clickBeautyBtn {
    [self shareStartLive];
//    self.beautyBtn.selected = !self.beautyBtn.selected;
//    self.beautyBtn.backgroundColor = self.beautyBtn.selected ? UIColor.orangeColor : UIColor.whiteColor;
//    self.session.beautyFace = !self.session.beautyFace;
}

- (void)clickCameraBtn {
//    AVCaptureDevicePosition position = self.session.captureDevicePosition;
//    self.session.captureDevicePosition = position == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
}

- (void)clickStartBtn {
    self.shareBtn.selected = !self.shareBtn.selected;
    if (RPScreenRecorder.sharedRecorder.isRecording) {
        [self stopLive];
        if (@available(iOS 11.0, *)) {
            [RPScreenRecorder.sharedRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"stopCaptureWithHandler:%@", error.localizedDescription);
                } else {
                    NSLog(@"CaptureWithHandlerStoped");
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    } else {
        for (UIView *view in _broadPickerView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
                //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
                [(UIButton*)view sendActionsForControlEvents:UIControlEventAllTouchEvents];
            }
        }
        return;
    }
}

- (void)clickShareBtn {
    self.shareBtn.selected = !self.shareBtn.selected;
    if (RPScreenRecorder.sharedRecorder.isRecording) {
        [self stopLive];
        if (@available(iOS 11.0, *)) {
            [RPScreenRecorder.sharedRecorder stopCaptureWithHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"stopCaptureWithHandler:%@", error.localizedDescription);
                } else {
                    NSLog(@"CaptureWithHandlerStoped");
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    } else {
        if (@available(iOS 11.0, *)) {
            NSLog(@"start Recording");
            [RPScreenRecorder.sharedRecorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
//                NSLog(@"bufferTyped:%ld", (long)bufferType);
                switch (bufferType) {
                    case RPSampleBufferTypeVideo:
//                        [self pushVideoBuffer:sampleBuffer];
                        [self.session pushVideoBuffer:sampleBuffer];
                        break;
                    case RPSampleBufferTypeAudioMic:
                        [self.session pushAudioBuffer:sampleBuffer];
//                        [self pushAudioBuffer:sampleBuffer];
                        break;
                        
                    default:
                        break;
                }
                if (error) {
                    NSLog(@"startCaptureWithHandler:error:%@", error.localizedDescription);
                }
            } completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"completionHandler:error:%@", error.localizedDescription);
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)startLive {
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    stream.url = kLiveUrl;
    [self.session startLive:stream];
    [RPScreenRecorder.sharedRecorder setMicrophoneEnabled:YES];
}

- (void)stopLive {
    [self.session stopLive];
}

//- (void)pushAudioBuffer:(CMSampleBufferRef)sampleBuffer {
//    AudioBufferList audioBufferList;
//    CMBlockBufferRef blockBuffer;
//
//    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &audioBufferList, sizeof(audioBufferList), NULL, NULL, 0, &blockBuffer);
//
//    for( int y=0; y<audioBufferList.mNumberBuffers; y++ ) {
//        AudioBuffer audioBuffer = audioBufferList.mBuffers[y];
//        void* audio = audioBuffer.mData;
//        NSData *data = [NSData dataWithBytes:audio length:audioBuffer.mDataByteSize];
//        [self.session pushAudio:data];
//    }
//    CFRelease(blockBuffer);
//}
//
//- (void)pushVideoBuffer:(CMSampleBufferRef)sampleBuffer {
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    [self.session pushVideo:pixelBuffer];
//}

- (void)requestAccessForVideo {
    WEAKSELF
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
    case AVAuthorizationStatusNotDetermined:
        {
            //许可对话没有出现 则设置请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.session setRunning:YES];
                });
                }
            }];
            break;
        }
    case AVAuthorizationStatusAuthorized:
        {
           dispatch_async(dispatch_get_main_queue(), ^{
//               [weakSelf.session setRunning:YES];
           });
            break;
        }
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
            //用户获取失败
            break;
    default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
      switch (status) {
    case AVAuthorizationStatusNotDetermined:{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    }
              break;
              
          case AVAuthorizationStatusAuthorized:
              break;
          case AVAuthorizationStatusRestricted:
          case AVAuthorizationStatusDenied:
              break;
    default:
              break;
      }
}

#pragma mark ------------LFLiveSessionDelegate-------------
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    switch (state) {
    case LFLiveReady:
            self.navigationItem.title = @"准备";
            break;
    case LFLivePending:
            self.navigationItem.title = @"连接中";
            break;
    case LFLiveStart:
            self.navigationItem.title = @"已连接";
            break;
    case LFLiveStop:
            self.navigationItem.title = @"已断开";
            break;
    case LFLiveError:
            self.navigationItem.title = @"连接错误";
    default:
            break;
    }
}

- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo {
    NSLog(@"-----bugInfo:%@",debugInfo);
}

- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    NSLog(@"-----errorCode: %ld", errorCode);
}


#pragma mark ------------方法二：调用Extension来实现共享屏幕-------------
- (void)shareStartLive {
// 如果需要mic，需要打开x此项
    [[RPScreenRecorder sharedRecorder] setMicrophoneEnabled:YES];
    
    if (![RPScreenRecorder sharedRecorder].isRecording) {
//        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithPreferredExtension:@"com.manku.MyProject1.BroadExtSetupUI" handler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
//
//        }];
        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"RPBroadcast err %@", [error localizedDescription]);
            }
            broadcastActivityViewController.delegate = self;
            broadcastActivityViewController.modalPresentationStyle = UIModalPresentationPopover;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                broadcastActivityViewController.popoverPresentationController.sourceRect = self.testView.frame;
                broadcastActivityViewController.popoverPresentationController.sourceView = self.testView;
            }
            [self presentViewController:broadcastActivityViewController animated:YES completion:nil];
        }];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Stop Live?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self shareStopLive];
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)shareStopLive {
    [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"finishBroadcastWithHandler:%@", error.localizedDescription);
        }
        
    }];
}
#pragma mark ------------RPBroadcastActivityViewControllerDelegate-------------
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *) broadcastActivityViewController
       didFinishWithBroadcastController:(RPBroadcastController *)broadcastController
                                  error:(NSError *)error {
    
    [broadcastActivityViewController dismissViewControllerAnimated:YES
                                                        completion:nil];
    NSLog(@"BundleID---%@", broadcastController.broadcastExtensionBundleID);
    self.broadcastController = broadcastController;
    self.broadcastController.delegate = self;
    if (error) {
        NSLog(@"BAC: %@ didFinishWBC: %@, err: %@",
              broadcastActivityViewController,
              broadcastController,
              error);
        return;
    }

    [broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"-----start success----");
            // 这里可以添加camerPreview
        } else {
            NSLog(@"startBroadcast:%@",error.localizedDescription);
        }
    }];
    
}

#pragma mark ------------RPBroadcastControllerDelegate-------------
// Watch for service info from broadcast service
- (void)broadcastController:(RPBroadcastController *)broadcastController
       didUpdateServiceInfo:(NSDictionary <NSString *, NSObject <NSCoding> *> *)serviceInfo {
    NSLog(@"didUpdateServiceInfo: %@", serviceInfo);
}

// Broadcast service encountered an error
- (void)broadcastController:(RPBroadcastController *)broadcastController
         didFinishWithError:(NSError *)error {
    NSLog(@"didFinishWithError: %@", error);
}

- (void)broadcastController:(RPBroadcastController *)broadcastController didUpdateBroadcastURL:(NSURL *)broadcastURL {
    NSLog(@"---didUpdateBroadcastURL: %@",broadcastURL);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (LFLiveSession *)session {
    if (!_session) {
        LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration defaultConfigurationForQuality:LFLiveAudioQuality_High];
        audioConfiguration.numberOfChannels = 1;
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High2 outputImageOrientation:UIInterfaceOrientationLandscapeRight];
        videoConfiguration.autorotate = YES;
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration captureType:LFLiveInputMaskAll];
//        _session = [[LFLiveSession alloc] initWithAudioConfiguration:LFLiveAudioConfiguration.defaultConfiguration videoConfiguration:LFLiveVideoConfiguration.defaultConfiguration];
//        _session.preView = self.view;//将摄像头采集数据源渲染到view上
        _session.delegate = self;
        _session.showDebugInfo = YES;
    }
    return _session;
}

@end
