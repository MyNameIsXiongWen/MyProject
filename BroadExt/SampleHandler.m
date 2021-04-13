//
//  SampleHandler.m
//  BroadExt
//
//  Created by xiaobu on 2020/7/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//


#import "SampleHandler.h"
#import "ZFUploadTool.h"

@interface SampleHandler ()

@property (nonatomic, strong) ZFUploadTool *tool;
@end

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [self requireNetwork];
    self.tool = [ZFUploadTool shareTool];
    [self.tool prepareToStart:setupInfo];
    NSLog(@"------prepareToStart-------");
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [self.tool stop];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            [self.tool sendVideoBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            //            [self.tool sendAudioBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioMic:
            [self.tool sendAudioBuffer:sampleBuffer];
            break;
            
        default:
            break;
    }
}

- (void)requireNetwork {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }] resume];
}

@end
