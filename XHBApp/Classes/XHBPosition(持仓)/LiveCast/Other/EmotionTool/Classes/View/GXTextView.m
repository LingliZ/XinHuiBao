//
//  GXTextView.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXTextView.h"
#import "GXTextAttachment.h"
#import "UITextField+GXTextFieldSelectedRange.h"
#define emotionFont [UIFont systemFontOfSize:14]

@implementation GXTextView
- (void)insertEmotion:(GXEmotion *)emotion{
    if (emotion.isBlank) {
        return;
    }
    if (emotion.isDelete) {
        [self deleteBackward];
        return;
    }
    NSAttributedString *emotionAttr = [GXTextAttachment attribtuteStrWithEmotion:emotion withFont:emotionFont];
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange selectedRange = self.selectedRange;
    [textAttr replaceCharactersInRange:selectedRange withAttributedString:emotionAttr];
    self.attributedText = textAttr;
    self.selectedRange = NSMakeRange(selectedRange.location + 1, 0);
}
- (NSString *)fullText{
    NSMutableString *strM = [NSMutableString string];
    NSAttributedString *attr = self.attributedText;
    
    [attr enumerateAttributesInRange:NSMakeRange(0, attr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        GXTextAttachment *textAttach = attrs[@"NSAttachment"];
        if (textAttach) {
            [strM appendString:textAttach.imageChs];
        }else{
            _isFullEmot = false;
            NSString *subStr = [self.text substringWithRange:range];
            [strM appendString:subStr];
        }
    }];

    return strM;
}

- (BOOL)isFullEmot{
    _isFullEmot = YES;
    
    NSAttributedString *attr = self.attributedText;
    [attr enumerateAttributesInRange:NSMakeRange(0, attr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        GXTextAttachment *textAttach = attrs[@"NSAttachment"];
        if (!textAttach) {
            _isFullEmot = false;
        }
    }];
    return _isFullEmot;
}
@end
