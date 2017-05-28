//
//  GXTextAttachment.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXTextAttachment.h"
#import "YYImage.h"
#import "YYText.h"

@implementation GXTextAttachment
+ (NSAttributedString *)attribtuteStrWithEmotion:(GXEmotion *)emotion withFont: (UIFont *)font{
    GXTextAttachment *textAtt = [[GXTextAttachment alloc] init];
    textAtt.imageChs = emotion.chs;
    NSString *path = [[NSBundle mainBundle] pathForResource:emotion.gifName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:1.2];
    image.preloadAllAnimatedImageFrames = YES;
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    NSMutableAttributedString *mutableAtt = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.bounds.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [mutableAtt yy_setAttachment:textAtt range:NSMakeRange(0, 1)];
    return mutableAtt;
}
@end
