//
//  NSString+GXEmotion.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GXEmotion)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(long)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
@end
