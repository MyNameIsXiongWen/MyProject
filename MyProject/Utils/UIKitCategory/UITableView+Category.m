//
//  UITableView+Category.m
//  MyProject
//
//  Created by jason on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)

+ (UITableView *)initWithFrame:(CGRect)rect Style:(UITableViewStyle)style Object:(id)object {
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:style];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = object;
    tableView.dataSource = object;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

@end
