//
//  GXTextView.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXEmotion.h"
#import "YYText.h"

@interface GXTextView : YYTextView
@property (nonatomic, assign) BOOL isFullEmot;

- (NSString *)fullText;
- (void)insertEmotion:(GXEmotion *)emotion;
@end
