//
//  MKActionSheetView.m
//  MANKUProject
//
//  Created by jason on 2018/7/11.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import "MKActionSheetView.h"
#import "MKActionSheetTitleTableViewCell.h"

static NSString *const ActionSheetCellIdentifier = @"ActionSheetCell";
@interface MKActionSheetView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *blackView;

@end

@implementation MKActionSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)configUI {
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPay)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = UIColor.whiteColor;
    self.tableview.layer.cornerRadius = 5;
    self.tableview.layer.masksToBounds = YES;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"MKActionSheetTitleTableViewCell" bundle:nil] forCellReuseIdentifier:ActionSheetCellIdentifier];
    [self addSubview:self.tableview];
    
    UIButton *cancelBtn = [UIButton initWithFrame:CGRectZero Title:@"取消" Image:nil SelectedImage:nil Font:FONT_SIZE(15) TitleColor:ColorFromHexString(@"808080") BackgroundColor:UIColor.whiteColor CornerRadius:5];
    [cancelBtn addTarget:self action:@selector(cancelPay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.top.mas_equalTo(0);
        make.bottom.equalTo(cancelBtn.mas_top).offset(-20);
    }];
}

- (void)cancelPay {
    [self dismiss];
}

- (void)show {
    [self configUI];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.blackView.alpha = 0.3;
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    }completion:^(BOOL finished) {
        self.blackView.hidden = NO;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        self.blackView.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.blackView.hidden = YES;
        [self removeFromSuperview];
        [self.blackView removeFromSuperview];
    }];
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKActionSheetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActionSheetCellIdentifier];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == 0 || indexPath.row == self.titleArray.count-1) {
        UIBezierPath *path;
        if (indexPath.row == 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenW-40, 50) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        }
        else {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenW-40, 50) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        }
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = CGRectMake(0, 0, kScreenW-40, 50);
        layer.path = path.CGPath;
        cell.layer.mask = layer;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(actionSheetViewSelectedIndex:WithActionSheetView:)]) {
        [self.delegate actionSheetViewSelectedIndex:indexPath.row WithActionSheetView:self];
    }
    [self dismiss];
}

@end
