//
//  FaceRecognitionViewController.m
//  MyProject
//
//  Created by jason on 2019/4/3.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "FaceRecognitionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FacePreviewView.h"

@interface FaceRecognitionViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) FacePreviewView *previewView;

@end

@implementation FaceRecognitionViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.previewView = [[FacePreviewView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.previewView];
    [self addScaningVideo];
}

- (void)addScaningVideo {
    //获取输入设备（摄像头）
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    NSError *error = nil;
    //根据输入设备创建输入对象
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //创建原数据的输出对象
    AVCaptureMetadataOutput *metadataOutput = AVCaptureMetadataOutput.new;
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置输出质量(高像素输出)
    self.session = AVCaptureSession.new;
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    //添加输入和输出到会话
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    //识别人脸
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    //创建预览图层
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.view.bounds;
    [self.previewView.layer insertSublayer:self.previewLayer atIndex:0];
    //设置有效扫描区域
    metadataOutput.rectOfInterest = self.previewView.bounds;
    //开始扫描
    if (!self.session.isRunning) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session startRunning];
        });
    }
}

- (void)switchCameraAction {
    CATransition *animation = CATransition.new;
    animation.type = @"oglFlip";
    animation.subtype = @"fromLeft";
    animation.duration = 0.5;
    [self.view.layer addAnimation:animation forKey:nil];
    
    if (!self.deviceInput) {
        return;
    }
    AVCaptureDevicePosition position = self.deviceInput.device.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
//    AVCaptureDevice *newDevice = [deviceSession.devices filteredArrayUsingPredicate:<#(nonnull NSPredicate *)#>];
//    AVCaptureDeviceInput *newVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:<#(nonnull AVCaptureDevice *)#> error:<#(NSError *__autoreleasing  _Nullable * _Nullable)#>]
    
    [self.session beginConfiguration];
    [self.session removeInput:self.deviceInput];
//    [self.session addInput:<#(nonnull AVCaptureInput *)#>]
    [self.session commitConfiguration];
//    self.deviceInput =
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"=====%@",metadataObjects);
    [self.previewView handleOutputFaceObjects:metadataObjects PreviewLayer:self.previewLayer];
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
