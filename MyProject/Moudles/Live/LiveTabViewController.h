//
//  LiveTabViewController.h
//  MyProject
//
//  Created by xiaobu on 2020/7/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveTabViewController : UIViewController

@end

@interface CTLabel : UIView {
    NSInteger currentCTLineIndex;
    NSInteger currentCTRunIndex;
    NSArray *matches;
}

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *emojiArray;
@property (nonatomic, strong) NSDictionary *emojiDic;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) void (^ updateHeightBlock)(CGFloat height);

- (void)parseEmojiWithContent:(NSString *)content;

- (NSString *)executeMatchWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
