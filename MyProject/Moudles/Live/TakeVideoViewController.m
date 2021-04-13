//
//  TakeVideoViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/8/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "TakeVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

static CGFloat videoDuration = 15.0;

@interface TakeVideoViewController () <AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCapturePhotoOutput *capturePhotoOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutPut;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

///后台任务标识
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) CircleView *circleView;
//聚焦光标
@property (nonatomic, strong) UIView *focusCursor;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TakeVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCamera];
    [self.captureSession startRunning];
    [self setUpUI];
}

- (void)setUpUI {
    UIButton *cameraDeviceBtn = [UIButton initWithFrame:CGRectMake(kScreenW-70, 50, 50, 50) Title:NSLocalizedString(@"切换", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [cameraDeviceBtn addTarget:self action:@selector(clickCameraDeviceBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton initWithFrame:CGRectMake(20, 50, 50, 50) Title:NSLocalizedString(@"返回", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        
    _circleView = [[CircleView alloc] initWithFrame:CGRectMake((kScreenW-80)/2, kScreenH-130, 80, 80)];
    [_circleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoBtn)]];
    [_circleView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideoBtn:)]];
    
    _focusCursor = [UIView initWithFrame:CGRectMake(0, 0, 60, 60) BackgroundColor:UIColor.clearColor CornerRadius:0];
    _focusCursor.layer.borderColor = UIColor.orangeColor.CGColor;
    _focusCursor.layer.borderWidth = 1;
    _focusCursor.alpha = 0;
    
    _returnBtn = [UIButton initWithFrame:CGRectMake(20, 50, 50, 50) Title:NSLocalizedString(@"返回", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.redColor CornerRadius:5];
    [_returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    _returnBtn.hidden = YES;
    
    [self.view addSubview:cameraDeviceBtn];
    [self.view addSubview:backBtn];
    [self.view addSubview:_circleView];
    [self.view addSubview:_focusCursor];
    [self.view addSubview:_returnBtn];
}

- (void)initCamera {
    _captureSession = AVCaptureSession.new;
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    NSError *error = nil;
    //获得摄像头输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题。");
        return;
    }
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //获得音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified].devices firstObject];
    if (!audioCaptureDevice) {
        NSLog(@"取得麦克风时出现问题。");
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"获得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象，用于获得输出数据
    _capturePhotoOutput = AVCapturePhotoOutput.new;
    _captureMovieFileOutPut = AVCaptureMovieFileOutput.new;

    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设输出添加到会话中
    if ([_captureSession canAddOutput:_capturePhotoOutput]) {
        [_captureSession addOutput:_capturePhotoOutput];
    }
    
    if ([_captureSession canAddOutput:_captureMovieFileOutPut]) {
        [_captureSession addOutput:_captureMovieFileOutPut];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    //填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGestureRecognizer];
}

//添加点击手势，点按时聚焦
- (void)addGestureRecognizer {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 点击方法
- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.view];
    [self setFocusCursorWithPoint:point];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

//设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
    }];
}

//设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}
    
#pragma mark ------------视频输出代理-------------
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    [self setupTimer];
    NSLog(@"开始录制...");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"视频录制完成.");
    [self invalidateTimer];
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    
//    __block NSString *localIdentifier = nil;
//    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
//        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
//        localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
//        request.creationDate = [NSDate date];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success) {
//                NSLog(@"视频保存成功");
//                [self fetchAssetByIocalIdentifier:localIdentifier retryCount:10];
//            } else if (error) {
//                NSLog(@"保存视频出错:%@",error.localizedDescription);
//            }
//            if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
//                [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
//            }
//        });
//    }];
    
//    UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}

- (void)fetchAssetByIocalIdentifier:(NSString *)localIdentifier retryCount:(NSInteger)retryCount {
    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
    if (asset || retryCount <= 0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fetchAssetByIocalIdentifier:localIdentifier retryCount:retryCount - 1];
    });
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(nonnull AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    [self.captureSession stopRunning];
    self.returnBtn.hidden = NO;
    NSLog(@"拍照完成.");
//    NSData *imgData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
//    UIImage *img = [UIImage imageWithData:imgData];
//    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"图片保存失败，请稍后重试");
    } else {
        NSLog(@"图片保存成功");
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"视频保存失败，请稍后重试");
    } else {
        NSLog(@"视频保存成功");
    }
}

- (void)deviceConnected:(NSNotification *)notification {
    NSLog(@"设备已连接...");
}

- (void)deviceDisconnected:(NSNotification *)notification {
    NSLog(@"设备已断开.");
}

- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    //捕获区域发生改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)areaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变...");
}

//属性改变操作
- (void)changeDeviceProperty:(void (^)(AVCaptureDevice *captureDevice))propertyChange {
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

- (void)clickCameraDeviceBtn {
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentDevice];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    
    //获得要调整到设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    //改变会话到配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交新的输入对象
    [self.captureSession commitConfiguration];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPhotoBtn {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo];
    NSLog(@"设备连接状态====%d", captureConnection.active);
    AVCapturePhotoSettings *settings = AVCapturePhotoSettings.new;
    settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecJPEG}];
    [self.capturePhotoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)clickVideoBtn:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startRecording];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self endRecording];
        [self.captureSession stopRunning];
        self.returnBtn.hidden = NO;
    }
}

- (void)clickReturnBtn {
    [self.captureSession startRunning];
    self.returnBtn.hidden = YES;
    self.circleView.progress = 0;
}

- (void)startRecording {
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
    NSLog(@"save path is :%@",outputFielPath);
    NSURL *fileUrl = [NSURL fileURLWithPath:outputFielPath];
    [self.captureMovieFileOutPut startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

- (void)endRecording {
    [self.captureMovieFileOutPut stopRecording];//停止录制
}

- (void)setupTimer {
    [self invalidateTimer];
   __block CGFloat currentVideoDuration = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (currentVideoDuration < videoDuration) {
            currentVideoDuration += 0.01;
            self.circleView.progress = currentVideoDuration/videoDuration;
        } else {
            [self endRecording];
        }
    }];
    [self.timer fire];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

//获取指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)positon {
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:positon];
    return session.devices.firstObject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.width/2;
        
        self.bgLayer = [self addLayerWithProgress:1 StrokeColor:UIColor.lightGrayColor];
        [self.layer addSublayer:self.bgLayer];
        
        self.strokeLayer = [self addLayerWithProgress:0 StrokeColor:UIColor.orangeColor];
        [self.layer addSublayer:self.strokeLayer];
    }
    return self;
}

- (void)setProgress:(float)progress {
    NSLog(@"progress=====%f", progress);
    _progress = progress;
    self.strokeLayer.strokeEnd = progress;
}

- (CAShapeLayer *)addLayerWithProgress:(float)progress StrokeColor:(UIColor *)strokeColor {
    //初始化一个路径
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.width/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*progress-M_PI_2 clockwise:YES];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 5, self.width-10, self.height-10) cornerRadius:self.width/2];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = UIColor.clearColor.CGColor;//圆环路径填充颜色
    layer.lineWidth = 10;//圆环宽度
    layer.strokeColor = strokeColor.CGColor;//路径颜色
    layer.strokeStart = 0;//路径开始位置
    layer.strokeEnd = progress;//路径结束位置
    layer.path = path.CGPath;
    return layer;
}

@end
