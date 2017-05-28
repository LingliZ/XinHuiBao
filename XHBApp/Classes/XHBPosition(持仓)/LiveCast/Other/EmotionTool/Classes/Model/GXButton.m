//
//  GXButton.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXButton.h"

@implementation GXButton
- (void)setEmotion:(GXEmotion *)emotion{
    _emotion = emotion;
    UIImage *image;
    if (emotion.imageName.length > 0) {
        image = [UIImage imageNamed:emotion.imageName];
    }
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
    }
    if (emotion.isBlank) {
        [self setImage:nil forState:UIControlStateNormal];
    }
    if (emotion.isDelete) {
        [self setImage:[UIImage imageNamed:@"del_emoji_normal.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"del_emoji_select.png"] forState:UIControlStateHighlighted];
    }
}

@end
