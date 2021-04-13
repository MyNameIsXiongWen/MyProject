//
//  UploadMainViewController.h
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFileSource.h"
#import "DownloadFileSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadMainViewController : UIViewController

@end

@interface UploadMainCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *totalProgressView;
@property (nonatomic, strong) UIView *currentProgressView;
@property (nonatomic, strong) UILabel *fileLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UploadFileSource *uploadFileSource;
@property (nonatomic, strong) DownloadFileSource *downloadFileSource;

@end

NS_ASSUME_NONNULL_END
