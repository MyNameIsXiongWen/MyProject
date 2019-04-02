//
//  MKActionSheetView.h
//  MANKUProject
//
//  Created by jason on 2018/7/11.
//  Copyright © 2018年 MANKU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKActionSheetView;

@protocol MKActionSheetViewDelegate <NSObject>

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(MKActionSheetView *)actionsheetView;

@end

@interface MKActionSheetView : UIView

@property (nonatomic, weak) id <MKActionSheetViewDelegate>delegate;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imgArray;

- (void)show;
- (void)dismiss;

@end
