//
//  LiveTabViewController.m
//  MyProject
//
//  Created by xiaobu on 2020/7/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "LiveTabViewController.h"
#import <CoreText/CoreText.h>

@interface LiveTabViewController () <UITextViewDelegate>

@end

@implementation LiveTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNavBtn setImage:UIImageMake(@"") forState:0];
    
    UIButton *liveBtn = [UIButton initWithFrame:CGRectMake(50, kTopBarHeight+50, kScreenW-100, 40) Title:NSLocalizedString(@"GoLive", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [liveBtn addTarget:self action:@selector(clickLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playBtn = [UIButton initWithFrame:CGRectMake(50, liveBtn.bottom+30, kScreenW-100, 40) Title:NSLocalizedString(@"LookLive", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [playBtn addTarget:self action:@selector(clickPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *videoBtn = [UIButton initWithFrame:CGRectMake(50, playBtn.bottom+30, kScreenW-100, 40) Title:NSLocalizedString(@"TakeVideo", nil) Image:nil SelectedImage:nil Font:FONT_SIZE(16) TitleColor:UIColor.whiteColor BackgroundColor:UIColor.orangeColor CornerRadius:5];
    [videoBtn addTarget:self action:@selector(clickVideoBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:liveBtn];
    [self.view addSubview:playBtn];
    [self.view addSubview:videoBtn];
    
    NSString *contentStr = @"[猪头][]这里在测试[调皮]图文混排m.qhiwi.com，啊我[流泪]是[调皮一个富[大笑]www.baidu.com文本[猪头][]这里在测试[调皮]图文15651113206混排，我[流泪]是[调皮，我[流泪]是[调皮一个富[调皮][大笑][调皮][猪头]文本一个富[大笑]文本[猪头][]这里10086在测试[调皮]图文混排，我[流泪]是[调皮一个富[调皮][大笑][调皮][猪头]文本[调皮][大笑][调皮][猪头]文本一个富[大笑]文本[猪头][]这里10086在测试[调皮]图文混排，我[流泪]是[调皮一个富[调皮][大笑][调皮][猪头]文本";
    
    CTLabel *ctLabel = [[CTLabel alloc] initWithFrame:CGRectMake(50, videoBtn.bottom+30, kScreenW-100, 17)];
    NSString *previewStr = [ctLabel executeMatchWithContent:contentStr];
    ctLabel.contentStr = previewStr;
    ctLabel.height = [previewStr getHeightWithFont:16 constrainedToSize:CGSizeMake(ctLabel.width, CGFLOAT_MAX)];
    __weak typeof(ctLabel) weakctLabel = ctLabel;
    ctLabel.updateHeightBlock = ^(CGFloat height) {
        [weakctLabel removeFromSuperview];
        CTLabel *resultLabel = [[CTLabel alloc] init];
        NSString *previewStr = [resultLabel executeMatchWithContent:contentStr];
        resultLabel.contentStr = previewStr;
        resultLabel.frame = CGRectMake(50, videoBtn.bottom+30, kScreenW-100, height);
//        [self.view addSubview:resultLabel];
    };
//    [self.view addSubview:ctLabel];
    
    
//    CGFloat strHeight = [previewStr getHeightWithFont:15 constrainedToSize:CGSizeMake(kScreenW-100, CGFLOAT_MAX)];
    NSLayoutManager *layoutM = NSLayoutManager.new;
    NSTextStorage *textS = NSTextStorage.new;
    [textS addLayoutManager:layoutM];
    
//    修改NSTextStorage属性
    [textS beginEditing];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:previewStr];
    NSMutableParagraphStyle *style = NSMutableParagraphStyle.new;
    style.lineSpacing = 0;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, previewStr.length)];
    [attr addAttribute:NSFontAttributeName value:FONT_SIZE(15) range:NSMakeRange(0, previewStr.length)];
    [attr addAttribute:NSLinkAttributeName value:@"http://www.baidu.com" range:[previewStr rangeOfString:@"www.baidu.com"]];
    [attr addAttribute:NSLinkAttributeName value:@"http://m.qhiwi.com" range:[previewStr rangeOfString:@"m.qhiwi.com"]];
    [attr addAttribute:NSLinkAttributeName value:@"tel://15651113206" range:[previewStr rangeOfString:@"15651113206"]];
    [textS setAttributedString:attr];
    [textS endEditing];
    
    CGFloat strHeight = [attr boundingRectWithSize:CGSizeMake(kScreenW-100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    NSTextContainer *textC = [[NSTextContainer alloc] initWithSize:CGSizeMake(kScreenW-100, strHeight)];
//    textC.lineFragmentPadding = 0;
    [layoutM addTextContainer:textC];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, videoBtn.bottom+30, kScreenW-100, strHeight) textContainer:textC];
//    [textView.textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:previewStr];
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.backgroundColor = UIColor.orangeColor;
    textView.editable = NO;
    textView.delegate = self;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    __block NSInteger currentIndex = 0;
    for (int i=0; i<ctLabel.contentArray.count; i++) {
        NSString *item = ctLabel.contentArray[i];
        if ([ctLabel.emojiArray containsObject:item]) {
            [ctLabel.emojiDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:item]) {
                    UIImage *image = [UIImage imageNamed:obj];
                    NSRange glyphRange;
                    [layoutM characterRangeForGlyphRange:NSMakeRange(currentIndex, 1) actualGlyphRange:&glyphRange];
                    CGRect rect = [layoutM boundingRectForGlyphRange:glyphRange inTextContainer:textC];
                    NSTextAttachment *attchment = NSTextAttachment.new;
                    attchment.bounds = CGRectMake(0, rect.size.width-rect.size.height, rect.size.width, rect.size.width);
                    attchment.image = image;
                    NSAttributedString *attchmentAttr = [NSAttributedString attributedStringWithAttachment:attchment];
                    [attr replaceCharactersInRange:NSMakeRange(currentIndex, 1) withAttributedString:attchmentAttr];
                    currentIndex += 1;
                    *stop = YES;
                }
            }];
        } else {
            currentIndex += item.length;
        }
    }
    textView.attributedText = attr;
//    textView.textContainer.exclusionPaths = @[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(70, 50, kScreenW-240, kScreenW-240) cornerRadius:(kScreenW-240)/2]];
    [self.view addSubview:textView];
    [textView sizeToFit];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"URL====%@", URL.relativeString);
    return YES;
}

#pragma mark ------------Live-------------
- (void)clickLiveBtn {
    [self.navigationController pushViewController:NSClassFromString(@"LiveViewController").new animated:YES];
}

- (void)clickPlayBtn {
    [self.navigationController pushViewController:NSClassFromString(@"LivePlayViewController").new animated:YES];
}

- (void)clickVideoBtn {
    [self.navigationController pushViewController:NSClassFromString(@"TakeVideoViewController").new animated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self.view];
//    NSLayoutManager *layoutM = NSLayoutManager.new;
//    NSTextContainer *textC = NSTextContainer.new;
////    当前点击在显示内容中的位置
//    NSInteger index = [layoutM glyphIndexForPoint:point inTextContainer:textC];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
static NSString *const checkStrEmoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
static NSString *const checkStrUrl = @"[a-zA-Z]*://[a-zA-Z0-9/\\.]*";

@implementation CTLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.orangeColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.contentStr) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.contentStr];
    [attributeStr addAttribute:NSFontAttributeName value:FONT_SIZE(16) range:NSMakeRange(0, self.contentStr.length)];
//    [attributeStr addAttribute:NSLinkAttributeName value:@"http://www.baidu.com" range:[self.contentStr rangeOfString:@"www.baidu.com"]];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColor.blueColor range:[self.contentStr rangeOfString:@"www.baidu.com"]];
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks,0,sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBacks;
    callBacks.getDescent = descentCallBacks;
    callBacks.getWidth = widthCallBacks;
    
    //根据字体计算表情的高度
    CGFloat emojiHeight = [@"/" getHeightWithFont:16 constrainedToSize:CGSizeMake(100, CGFLOAT_MAX)];
    NSDictionary *dicPic = @{@"height":@(emojiHeight), @"width":@(emojiHeight)};
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dicPic);
    
    NSInteger currentIndex = 0;
    for (int i=0; i<self.contentArray.count; i++) {
        NSString *item = self.contentArray[i];
        if ([self.emojiArray containsObject:item]) {
            NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:@" "];
            //这个目的是给每个@” “加个不同的属性，不然的话 系统会认为连续的几个@“ ”是同一个CTRun（可以去掉这句话看看效果）
            [placeHolderAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0] range:NSMakeRange(0, 1)];
            CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
//            把原本是‘啊’的字改为空位，方便后续插入表情
            [attributeStr replaceCharactersInRange:NSMakeRange(currentIndex, 1) withAttributedString:placeHolderAttrStr];
            currentIndex += 1;
        } else {
            currentIndex += item.length;
        }
    }
    CFRelease(delegate);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
//    CGPathMoveToPoint(path, NULL, 0, 0);
//    CGPathAddQuadCurveToPoint(path, NULL, self.width/2, 50, self.width, 0);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributeStr.length), path, NULL);
    CTFrameDraw(frame, context);
    
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, attributeStr.length), NULL, CGSizeMake(self.width, CGFLOAT_MAX), nil);
    if (suggestSize.height != self.height) {
        if (self.updateHeightBlock) {
            self.updateHeightBlock(suggestSize.height);
        }
    }
    
    for (int i=0; i<self.emojiArray.count; i++) {
        NSString *emojiImg = self.emojiArray[i];
        [self.emojiDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:emojiImg]) {
                UIImage *image = [UIImage imageNamed:obj];
                CGRect imgFrm = [self calculateImageRectWithFrame:frame];
                CGContextDrawImage(context,imgFrm, image.CGImage);
                *stop = YES;
            }
        }];
    }
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

static CGFloat ascentCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}
static CGFloat descentCallBacks(void * ref)
{
    return 0;
}
static CGFloat widthCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

- (CGRect)calculateImageRectWithFrame:(CTFrameRef)frame {
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = [arrLines count];
    CGPoint points[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (NSInteger i = currentCTLineIndex; i < count; i++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        
//        这个目的是得到最后一个表情的位置，下面遍历做为要换行的依据判断
        NSInteger lastEmojiIndex = arrGlyphRun.count-1;
        for (NSInteger j = arrGlyphRun.count-1; j >0; j--) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary *dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            lastEmojiIndex = j;
            break;
        }
        for (NSInteger j = currentCTRunIndex; j < arrGlyphRun.count; j++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary *dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGPoint point = points[i];
            CGFloat ascent;
            CGFloat descent;
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            boundsRun.origin.x = point.x + xOffset;
            boundsRun.origin.y = point.y - descent - 3;
            CGPathRef path = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            currentCTRunIndex = j+1;
            if (j == lastEmojiIndex) {
                currentCTLineIndex++;
                currentCTRunIndex = 0;
            }
            return imageBounds;
        }
    }
    return CGRectZero;
}

- (void)parseEmojiWithContent:(NSString *)content {
    [self getEmojiRange:content];
}

- (void)getEmojiRange:(NSString *)message {
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length && range1.length) {
        if (range.location > 0) {
            [self.contentArray addObject:[message substringToIndex:range.location]];
        }
        NSString *specialStr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
        [self parseSpecialStr:specialStr];
        NSString *str = [message substringFromIndex:range1.location+1];
        [self getEmojiRange:str];
    } else {
        if (message) {
            [self.contentArray addObject:message];
        }
    }
}

- (void)parseSpecialStr:(NSString *)content {
    NSString *targetStr = [content substringWithRange:NSMakeRange(1, content.length-1)];
    NSRange specialRange = [targetStr rangeOfString:BEGIN_FLAG];
    if (specialRange.length > 0) {
        [self.contentArray addObject:[content substringToIndex:specialRange.location+1]];
        NSString *specialStr = [content substringFromIndex:specialRange.location+1];
        [self parseSpecialStr:specialStr];
    } else {
        if ([self.emojiDic.allKeys containsObject:content]) {
            [self.emojiArray addObject:content];
        }
        [self.contentArray addObject:content];
    }
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = NSMutableArray.array;
    }
    return _contentArray;
}

- (NSMutableArray *)emojiArray {
    if (!_emojiArray) {
        _emojiArray = NSMutableArray.array;
    }
    return _emojiArray;
}

- (NSDictionary *)emojiDic {
    if (!_emojiDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
        _emojiDic = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _emojiDic;
}

- (NSString *)executeMatchWithContent:(NSString *)content {
    //比对结果
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:checkStrEmoji options:NSRegularExpressionCaseInsensitive error:nil];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSRange lastRange = NSMakeRange(0, 0);
    for (NSTextCheckingResult *result in matches) {
        if (result.range.location-(lastRange.location+lastRange.length) > 0) {
            [self.contentArray addObject:[content substringWithRange:NSMakeRange(lastRange.location+lastRange.length, result.range.location-(lastRange.location+lastRange.length))]];
        }
        NSString *emoji = [content substringWithRange:result.range];
        [self.emojiArray addObject:emoji];
        [self.contentArray addObject:emoji];
        lastRange = result.range;
        if (result == matches.lastObject) {
            [self.contentArray addObject:[content substringFromIndex:lastRange.location+lastRange.length]];
        }
    }
    NSString *previewStr = @"";
    for (NSString *item in self.contentArray) {
        if ([self.emojiArray containsObject:item]) {
            previewStr = [NSString stringWithFormat:@"%@%@", previewStr, @"啊"];
        } else {
            previewStr = [NSString stringWithFormat:@"%@%@", previewStr, item];
        }
    }
    return previewStr;
}

@end
