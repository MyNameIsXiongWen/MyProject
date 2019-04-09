//
//  FacePreviewView.h
//  MyProject
//
//  Created by jason on 2019/4/3.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacePreviewView : UIView

@property (nonatomic, strong) CALayer *overLayer;
@property (nonatomic, strong) NSMutableDictionary *faceLayers;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
- (void)handleOutputFaceObjects:(NSArray *)faceObjs PreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

@end

NS_ASSUME_NONNULL_END
