//
//  AddDownloadURLViewController.h
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddDownloadURLViewController : UIViewController

@property (nonatomic, strong) DownloadFileSource *fileSource;

@end

NS_ASSUME_NONNULL_END
