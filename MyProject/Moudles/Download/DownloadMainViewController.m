//
//  DownloadMainViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/9/18.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DownloadMainViewController.h"
#import "AddDownloadURLViewController.h"
#import "DownloadManager.h"
#import "UploadMainViewController.h"

@interface DownloadMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DownloadMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNavBtn setImage:UIImageMake(@"") forState:0];
    [self.rightNavBtn setTitle:@"+" forState:0];
    self.navigationItem.title = @"下载列表";
    [self.view addSubview:self.tableView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSource:) name:DownloadFileSourceChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSourceProgressNotification:) name:FileDownloadProgressDidChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateFileSourceStatusNotification:) name:FileDownloadStatusDidChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [DownloadManager.sharedManager archiveDownloadFileSource:nil];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    AddDownloadURLViewController *fileVC = AddDownloadURLViewController.new;
    [self.navigationController pushViewController:fileVC animated:YES];
}

#pragma mark ------------NSNotification-------------
- (void)updateFileSource:(NSNotification *)notification {
    for (DownloadFileSource *source in DownloadManager.sharedManager.fileSourceArray.reverseObjectEnumerator) {
        if (source.downloadStatus == FileDownloadStatusFinished) {
            [DownloadManager.sharedManager.fileSourceArray removeObject:source];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)updateFileSourceStatusNotification:(NSNotification *)notification {
    NSDictionary *info = (NSDictionary *)notification.object;
    NSString *fileSourceId = info[FileDownloadSourceIdKey];
    FileDownloadStatus status = [info[FileDownloadStatusDidChangedKey] integerValue];
    for (int i=0; i<DownloadManager.sharedManager.fileSourceArray.count; i++) {
        DownloadFileSource *source = DownloadManager.sharedManager.fileSourceArray[i];
        if ([source.sourceId isEqualToString:fileSourceId]) {
            source.downloadStatus = status;
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadMainCell *cell = (UploadMainCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (cell) {
                    cell.statusLabel.text = source.downloadStatusName;
                }
            });
            break;
        }
    }
}

- (void)updateFileSourceProgressNotification:(NSNotification *)notification {
    NSDictionary *info = (NSDictionary *)notification.object;
    NSString *fileSourceId = info[FileDownloadSourceIdKey];
    CGFloat progress = [info[FileDownloadProgressDidChangedKey] floatValue];
    for (int i=0; i<DownloadManager.sharedManager.fileSourceArray.count; i++) {
        DownloadFileSource *source = DownloadManager.sharedManager.fileSourceArray[i];
        if ([source.sourceId isEqualToString:fileSourceId]) {
            source.downloadProgress = progress;
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadMainCell *cell = (UploadMainCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (cell) {
                    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress*100];
                    cell.currentProgressView.width = (kScreenW-15-80-10-15-60)*progress;
                    cell.fileLabel.text = [NSString stringWithFormat:@"%.2fM", source.totalSize/1024/1024.0];
                }
            });
            break;
        }
    }
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DownloadManager.sharedManager.fileSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < DownloadManager.sharedManager.fileSourceArray.count) {
        UploadMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UploadMainCell.class)];
        DownloadFileSource *model = DownloadManager.sharedManager.fileSourceArray[indexPath.row];
        cell.downloadFileSource = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < DownloadManager.sharedManager.fileSourceArray.count) {
        DownloadFileSource *model = DownloadManager.sharedManager.fileSourceArray[indexPath.row];
        if (model.downloadStatus == FileDownloadStatusDownloading || model.downloadStatus == FileDownloadStatusWaiting) {
            [DownloadManager.sharedManager suspendDownloadOperationQueueWithFileSourceId:model.sourceId];
        } else if (model.downloadStatus == FileDownloadStatusSuspend) {
            [DownloadManager.sharedManager resumeDownloadOperationQueueWithFileSourceId:model.sourceId];
        } else if (model.downloadStatus == FileDownloadStatusDraft) {
            AddDownloadURLViewController *fileVC = AddDownloadURLViewController.new;
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

@end
