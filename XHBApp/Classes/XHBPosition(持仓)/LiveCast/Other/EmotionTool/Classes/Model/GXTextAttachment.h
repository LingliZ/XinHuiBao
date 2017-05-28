//
//  GXTextAttachment.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXEmotion.h"

@interface GXTextAttachment : NSTextAttachment
@property (nonatomic,copy) NSString *imageChs;
+ (NSAttributedString *)attribtuteStrWithEmotion:(GXEmotion *)emotion withFont: (UIFont *)font;
@end
