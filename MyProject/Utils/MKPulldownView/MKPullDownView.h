//
//  MKPullDownView.h
//  ManKu_Merchant
//
//  Created by jason on 2019/3/16.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import "MKPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPullDownView : MKPopView

@property (nonatomic, strong) NSArray *dataArray;
///最多展示数量
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, copy) void (^ selectItemBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
