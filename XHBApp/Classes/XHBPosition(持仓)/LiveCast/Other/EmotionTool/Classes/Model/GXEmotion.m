//
//  GXEmotion.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXEmotion.h"
#import "NSString+GXEmotion.h"

@implementation GXEmotion
- (instancetype)initWithChs:(NSString *)chs withImageName:(NSString *)imageName withGifName:(NSString *)gifName{
    self = [super init];
    self.chs = chs;
    //GXKeybordEmot.bundle/png/
    
    self.imageName = [NSString stringWithFormat:@"GXKeybordEmot.bundle/png/%@",imageName];
    self.gifName = [NSString stringWithFormat:@"GXKeybordEmot.bundle/gif/%@",gifName];
    return self;
}
- (instancetype)initWithIsDelete:(BOOL) isDelete{
    self = [super init];
    self.isDelete = isDelete;
    return self;
}
- (instancetype)initWithIsBlank:(BOOL) isBlank{
    self = [super init];
    self.isBlank = isBlank;
    return self;
}
@end
