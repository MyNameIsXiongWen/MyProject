//
//  FacePreviewView.m
//  MyProject
//
//  Created by jason on 2019/4/3.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "FacePreviewView.h"

@implementation FacePreviewView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
//    self.frame.size.height = UIScreen.mainScreen.bounds.size.height-64-50;
    self.backgroundColor = UIColor.blackColor;
    self.overLayer = CALayer.new;
    self.overLayer.frame = self.frame;
    self.overLayer.sublayerTransform = [self CATransform3DMakePerspective:1000];
    [self.layer addSublayer:self.overLayer];
    self.faceLayers = @{}.mutableCopy;
}

//眼睛到物体的距离
- (CATransform3D)CATransform3DMakePerspective:(CGFloat)eyePosition {
    CATransform3D transform = CATransform3DIdentity;
    //m34: 透视效果; 近大远小
    transform.m34 = -1/eyePosition;
    return transform;
}

- (void)handleOutputFaceObjects:(NSArray *)faceObjs PreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer {
    self.previewLayer = previewLayer;
    NSMutableArray *faceIdArray = @[].mutableCopy;
    for (id faceId in self.faceLayers.allKeys) {
        [faceIdArray addObject:faceId];
    }
    
    NSArray *transformFaces = [self transformFaces:faceObjs];
    for (int i=0; i<transformFaces.count; i++) {
        AVMetadataFaceObject *face = transformFaces[i];
        if ([faceIdArray containsObject:[NSString stringWithFormat:@"(%ld)",(long)face.faceID]]) {
            [faceIdArray removeObjectAtIndex:i];
        }
        CALayer *faceLayer = self.faceLayers[[NSString stringWithFormat:@"(%ld)",(long)face.faceID]];
        if (faceLayer == nil) {
            faceLayer = [self createFaceLayer];
            [self.overLayer addSublayer:faceLayer];
            self.faceLayers[[NSString stringWithFormat:@"(%ld)",(long)face.faceID]] = faceLayer;
        }
        faceLayer.transform = CATransform3DIdentity;
        faceLayer.frame = face.bounds;
        if (face.hasYawAngle) {
            CATransform3D transform3D = [self transformDegressYaw:face.rollAngle];
            faceLayer.transform = CATransform3DConcat(faceLayer.transform, transform3D);
        }
        if (face.hasRollAngle) {
            CATransform3D transform3D = [self transformDegressRoll:face.rollAngle];
            faceLayer.transform = CATransform3DConcat(faceLayer.transform, transform3D);
        }
        for (id faceID in faceIdArray) {
            CALayer *faceIdLayer = self.faceLayers[faceID];
            [faceIdLayer removeFromSuperlayer];
            [self.faceLayers removeObjectForKey:faceID];
        }
    }
}

- (NSArray <AVMetadataObject *>*)transformFaces:(NSArray *)faceObj {
    NSMutableArray *faceArray = @[].mutableCopy;
    for (AVMetadataObject *face in faceObj) {
        //将扫描的人脸对象转成在预览图层的人脸对象(主要是坐标的转换)
        AVMetadataObject *object = [self.previewLayer transformedMetadataObjectForMetadataObject:face];
        if (object) {
            [faceArray addObject:object];
        }
    }
    return faceArray;
}

- (CALayer *)createFaceLayer {
    CALayer *layer = CALayer.new;
    layer.borderColor = UIColor.redColor.CGColor;
    layer.borderWidth = 3;
//    layer.contents = (id)UIImageMake(@"tab_workspace_selected").CGImage;
    return layer;
}

//处理倾斜角问题
- (CATransform3D)transformDegressYaw:(CGFloat)yawAngle {
    CGFloat yaw = [self degreesToRadius:yawAngle];
    //围绕Y轴旋转
    return CATransform3DConcat(CATransform3DMakeRotation(yaw, 0, -1, 0), CATransform3DIdentity);
}

//处理偏转角问题
- (CATransform3D)transformDegressRoll:(CGFloat)rollAngle {
    CGFloat roll = [self degreesToRadius:rollAngle];
    //围绕Z轴旋转
    return CATransform3DMakeRotation(roll, 0, 0, 1);
}

//角度转换
- (CGFloat)degreesToRadius:(CGFloat)degress {
    return degress * M_PI / 180;
}

@end
