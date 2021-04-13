//
//  UploadMainViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/9/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "UploadMainViewController.h"
#import "AddUploadFileViewController.h"
#import "UploadManager.h"

@interface UploadMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UploadMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNavBtn setImage:UIImageMake(@"") forState:0];
    [self.rightNavBtn setTitle:@"+" forState:0];
    self.navigationItem.title = @"上传列表";
    [self.view addSubview:self.tableView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSource:) name:UploadFileSourceChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSourceProgressNotification:) name:FileUploadProgressDidChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSourceStatusNotification:) name:FileUploadStatusDidChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UploadManager.sharedManager archiveUploadFileSource:nil];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    AddUploadFileViewController *fileVC = AddUploadFileViewController.new;
    [self.navigationController pushViewController:fileVC animated:YES];
}

#pragma mark ------------NSNotification-------------
- (void)updateFileSource:(NSNotification *)notification {
    for (UploadFileSource *source in UploadManager.sharedManager.fileSourceArray.reverseObjectEnumerator) {
        if (source.uploadStatus == FileUploadStatusFinished) {
            [UploadManager.sharedManager.fileSourceArray removeObject:source];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)updateFileSourceStatusNotification:(NSNotification *)notification {
    NSDictionary *info = (NSDictionary *)notification.object;
    NSString *fileSourceId = info[FileUploadSourceIdKey];
    FileUploadStatus status = [info[FileUploadStatusDidChangedKey] integerValue];
    for (int i=0; i<UploadManager.sharedManager.fileSourceArray.count; i++) {
        UploadFileSource *source = UploadManager.sharedManager.fileSourceArray[i];
        if ([source.sourceId isEqualToString:fileSourceId]) {
            source.uploadStatus = status;
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadMainCell *cell = (UploadMainCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (cell) {
                    cell.statusLabel.text = source.uploadStatusName;
                }
            });
            break;
        }
    }
}

- (void)updateFileSourceProgressNotification:(NSNotification *)notification {
    NSDictionary *info = (NSDictionary *)notification.object;
    NSString *fileSourceId = info[FileUploadSourceIdKey];
    CGFloat progress = [info[FileUploadProgressDidChangedKey] floatValue];
    for (int i=0; i<UploadManager.sharedManager.fileSourceArray.count; i++) {
        UploadFileSource *source = UploadManager.sharedManager.fileSourceArray[i];
        if ([source.sourceId isEqualToString:fileSourceId]) {
            source.uploadProgress = progress;
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadMainCell *cell = (UploadMainCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (cell) {
                    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress*100];
                    cell.currentProgressView.width = (kScreenW-15-80-10-15-60)*progress;
                }
            });
            break;
        }
    }
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UploadManager.sharedManager.fileSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < UploadManager.sharedManager.fileSourceArray.count) {
        UploadMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UploadMainCell.class)];
        UploadFileSource *model = UploadManager.sharedManager.fileSourceArray[indexPath.row];
        cell.uploadFileSource = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < UploadManager.sharedManager.fileSourceArray.count) {
        UploadFileSource *model = UploadManager.sharedManager.fileSourceArray[indexPath.row];
        if (model.uploadStatus == FileUploadStatusUploading || model.uploadStatus == FileUploadStatusWaiting) {
            [UploadManager.sharedManager suspendUploadOperationQueueWithFileSourceId:model.sourceId];
        } else if (model.uploadStatus == FileUploadStatusSuspend) {
            [UploadManager.sharedManager resumeUploadOperationQueueWithFileSourceId:model.sourceId];
        } else if (model.uploadStatus == FileUploadStatusDraft) {
            AddUploadFileViewController *fileVC = AddUploadFileViewController.new;
            fileVC.fileSource = model;
            [self.navigationController pushViewController:fileVC animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView initWithFrame:self.view.bounds Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 100;
        [_tableView registerClass:UploadMainCell.class forCellReuseIdentifier:NSStringFromClass(UploadMainCell.class)];
    }
    return _tableView;
}

//- (NSMutableArray<UploadFileSource *> *)uploadArray {
//    if (!_uploadArray) {
//        _uploadArray = NSMutableArray.array;
//    }
//    return _uploadArray;
//}

@end

@implementation UploadMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
//        [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.coverImgView);
//        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImgView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
        }];
        [self.fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            make.right.mas_equalTo(-15);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fileLabel.mas_bottom).offset(3);
            make.right.mas_equalTo(-15);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(self.coverImgView.mas_bottom);
            make.width.mas_equalTo(60);
//            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.totalProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.progressLabel.mas_left);
            make.bottom.equalTo(self.coverImgView.mas_bottom);
            make.left.equalTo(self.nameLabel.mas_left);
            make.height.mas_equalTo(15);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

- (void)setUploadFileSource:(UploadFileSource *)uploadFileSource {
    _uploadFileSource = uploadFileSource;
    self.nameLabel.text = uploadFileSource.sourceName;
    self.coverImgView.image = uploadFileSource.sourceImg;
    self.fileLabel.text = [NSString stringWithFormat:@"%ld个文件块，%ld个文件片  %.2fM", uploadFileSource.fileBlocks.count, uploadFileSource.fileFragments.count, uploadFileSource.totalFileSize/1024/1024.0];
    self.statusLabel.text = uploadFileSource.uploadStatusName;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", uploadFileSource.uploadProgress*100];
    self.currentProgressView.width = (kScreenW-15-80-10-15-60)*uploadFileSource.uploadProgress;
}

- (void)setDownloadFileSource:(DownloadFileSource *)downloadFileSource {
    _downloadFileSource = downloadFileSource;
    self.nameLabel.text = downloadFileSource.sourceName;
    self.coverImgView.image = downloadFileSource.sourceImg;
    self.fileLabel.text = [NSString stringWithFormat:@"%.2fM", downloadFileSource.totalSize/1024/1024.0];
    self.statusLabel.text = downloadFileSource.downloadStatusName;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", downloadFileSource.downloadProgress*100];
    self.currentProgressView.width = (kScreenW-15-80-10-15-60)*downloadFileSource.downloadProgress;
}

- (void)clickDeleteBtn {
    
}

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = UIImageView.ivInit();
        [self.contentView addSubview:_coverImgView];
    }
    return _coverImgView;
}

- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = UIButton.btnInit().btnImage(UIImageMake(@"")).btnSelectedImage(UIImageMake(@"")).btnAction(self, @selector(clickUploadBtn:));
        [self.contentView addSubview:_uploadBtn];
    }
    return _uploadBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)fileLabel {
    if (!_fileLabel) {
        _fileLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme444).labelNumberOfLines(0);
        [self.contentView addSubview:_fileLabel];
    }
    return _fileLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(UIColor.orangeColor).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (UIView *)totalProgressView {
    if (!_totalProgressView) {
        _totalProgressView = UIView.viewInit();
        _totalProgressView.layer.borderColor = UIColor.grayColor.CGColor;
        _totalProgressView.layer.borderWidth = 1;
        _totalProgressView.layer.cornerRadius = 5;
        _totalProgressView.layer.masksToBounds = YES;
        [self.contentView addSubview:_totalProgressView];
    }
    return _totalProgressView;
}

- (UIView *)currentProgressView {
    if (!_currentProgressView) {
        _currentProgressView = UIView.viewFrame(CGRectMake(0, 0, 0, 15)).bkgColor(UIColor.orangeColor);
        _currentProgressView.layer.cornerRadius = 5;
        _currentProgressView.layer.masksToBounds = YES;
        [self.totalProgressView addSubview:_currentProgressView];
    }
    return _currentProgressView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme666);
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = UIButton.btnInit().btnTitle(@"删除").btnImage(UIImageMake(@"")).btnAction(self, @selector(clickDeleteBtn));
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

@end
