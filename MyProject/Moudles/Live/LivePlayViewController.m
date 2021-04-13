//
//  LivePlayViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/7/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LivePlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LivePlayViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation LivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *videoURL = [NSURL URLWithString:kLiveUrl];
    IJKFFOptions *options = IJKFFOptions.optionsByDefault;
//    options.showHudView = YES;
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:videoURL withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = CGRectMake(0, 64, kScreenW, kScreenH-64);
    self.player.scalingMode = IJKMPMovieScalingModeFill;
    self.player.shouldAutoplay = YES;
    [self.player prepareToPlay];
    [self.view addSubview:self.player.view];
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
