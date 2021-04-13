//
//  BroadcastSetupViewController.m
//  BroadExtSetupUI
//
//  Created by xiaobu on 2020/7/15.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BroadcastSetupViewController.h"

@implementation BroadcastSetupViewController


- (void)viewDidLoad {
    
    
    /*
        在这个界面用来是配置直播参数
     */
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _broadPickerView = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _broadPickerView.backgroundColor = UIColor.brownColor;
    _broadPickerView.preferredExtension = @"com.manku.MyProject1.BroadExt";
    [self.view addSubview:_broadPickerView];

    UIButton *startBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(100, 100, 100, 100)];
        [button setBackgroundColor:[UIColor purpleColor]];
        [button setTitle:@"Start" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(userDidFinishSetup) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    UIButton *closeBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(230, 100, 100, 100)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(userDidCancelSetup) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    [self.view addSubview:startBtn];
    [self.view addSubview:closeBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self userDidFinishSetup];
}

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {
    
    for (UIView *view in _broadPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
            //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
            [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // URL of the resource where broadcast can be viewed that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString:@"http://apple.com/broadcast/streamID"];
    
    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    NSDictionary *setupInfo = @{ @"broadcastName" : @"example" };
    
    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"YourAppDomain" code:-1 userInfo:nil]];
}

@end
