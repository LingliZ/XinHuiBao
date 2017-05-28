//
//  NSString+GXEmotAttributedString.m
//  GXApp
//
//  Created by zhudong on 16/8/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSString+GXEmotAttributedString.h"
#import "YYImage.h"
#import "YYText.h"
#define emotionFont [UIFont systemFontOfSize:17]
#define SpecialTextColor [UIColor getColor:@"4A90E2"]

@implementation NSString (GXEmotAttributedString)
+ (NSAttributedString *)dealContentText:(NSString *)questionContent{
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithData:[questionContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:questionContent];
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\\[EMOT][0-9]{1,3}\\[/EMOT]" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *results = [regular matchesInString:attrM.string options:0 range:NSMakeRange(0, attrM.string.length)];
    while (results.count > 0) {
        NSRange range = results[0].range;
        NSString *subStr = [attrM.string substringWithRange:range];
        NSRange headRange = [subStr rangeOfString:@"[EMOT]"];
        NSRange endRange = [subStr rangeOfString:@"[/EMOT]"];
        NSString *imageTrueName = [subStr substringWithRange:NSMakeRange(headRange.location + headRange.length, endRange.location - headRange.location - headRange.length)];
        
        NSString *imageName = [NSString stringWithFormat:@"GXKeybordEmot.bundle/gif/face%@.gif",imageTrueName];
        YYImage *image = [YYImage imageNamed:imageName];
        image.preloadAllAnimatedImageFrames = YES;
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        NSAttributedString *attrStr = [NSAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(emotionFont.lineHeight, emotionFont.lineHeight) alignToFont:emotionFont alignment:YYTextVerticalAlignmentCenter];
        if (!image) {
            attrStr = [[NSAttributedString alloc] initWithString:@"~"];
        }
        [attrM replaceCharactersInRange:range withAttributedString:attrStr];
        results = [regular matchesInString:attrM.string options:0 range:NSMakeRange(0, attrM.string.length)];
    }
    NSRegularExpression *nameRegular = [NSRegularExpression regularExpressionWithPattern:@"@\\w* " options:0 error:nil];
    NSTextCheckingResult *result = [[nameRegular matchesInString:attrM.string options:0 range:NSMakeRange(0, attrM.length)] firstObject];
    if (result) {
        [attrM addAttribute:NSForegroundColorAttributeName value:SpecialTextColor range:result.range];
    }
    NSRegularExpression *httpRegular = [NSRegularExpression regularExpressionWithPattern:@"(http[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *httpResultArray = [httpRegular matchesInString:attrM.string options:0 range:NSMakeRange(0, attrM.string.length)];
    [httpResultArray enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange highlightRange = obj.range;
        YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
        YYTextBorder *textBorder = [YYTextBorder borderWithFillColor:[UIColor colorWithWhite:0.000 alpha:0.220] cornerRadius:0];
        [highlight setColor:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]];
        [highlight setBackgroundBorder:textBorder];
        [attrM addAttributes:@{NSForegroundColorAttributeName :[UIColor blueColor]} range:highlightRange];
        [attrM yy_setTextHighlight:highlight range:highlightRange];
    }];
//    GXLog(@"*******\n%@",attrM);
   return attrM;
    
}
@end
