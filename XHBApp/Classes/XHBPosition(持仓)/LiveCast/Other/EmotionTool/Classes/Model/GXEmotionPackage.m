//
//  GXEmotionPackage.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXEmotionPackage.h"
#import "GXEmotion.h"

@implementation GXEmotionPackage
+ (NSArray *)loadPackages{
    NSString *emoticonsPath = [[NSBundle mainBundle] pathForResource:@"GXKeybordEmot.bundle/emot.plist" ofType:nil];
    NSArray *emoticonsArray = [NSArray arrayWithContentsOfFile:emoticonsPath];
    
    return [GXEmotionPackage packagesWithDict:emoticonsArray];
}
+ (NSArray *)packagesWithDict:(NSArray *)emoticonsArray{
    NSMutableArray *emotionsArrM = [NSMutableArray array];
    int index = 0;
    for (int i = 0; i < emoticonsArray.count; i++) {
        index += 1;
        NSDictionary *emotionDict = emoticonsArray[i];
        NSString *imageName = emotionDict[@"png"];
        NSString *gifName = emotionDict[@"gif"];
        NSString *chs = emotionDict[@"chs"];
        //Expression_1@2x.png
        GXEmotion *emotion = [[GXEmotion alloc] initWithChs:chs withImageName:imageName withGifName:gifName];
        [emotionsArrM addObject:emotion];
        if (index == 20) {
            GXEmotion *emotion = [[GXEmotion alloc] initWithIsDelete:YES];
            [emotionsArrM addObject:emotion];
            index = 0;
        }
    }
    NSInteger delta = emotionsArrM.count % 21;
    if (delta != 0) {
        for (int i = (int)delta; i < 20; i++) {
            GXEmotion *emotion = [[GXEmotion alloc] initWithIsBlank:YES];
            [emotionsArrM addObject:emotion];
        }
        GXEmotion *emotion = [[GXEmotion alloc] initWithIsDelete:YES];
        [emotionsArrM addObject:emotion];
    }
    
    NSInteger pageCount = emotionsArrM.count / 21;
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:pageCount];
    for (int i = 0; i < pageCount; i++) {
        NSInteger location = i * 21;
        NSArray *section = [emotionsArrM subarrayWithRange:NSMakeRange(location, 21)];
        [sections addObject:section];
    }
    return sections.copy;
}
@end
