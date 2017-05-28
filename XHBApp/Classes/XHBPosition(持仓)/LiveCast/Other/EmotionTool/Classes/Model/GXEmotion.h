//
//  GXEmotion.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXEmotion : NSObject
@property (nonatomic,copy) NSString *chs;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *gifName;
@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,assign) BOOL isBlank;
- (instancetype)initWithChs:(NSString *)chs withImageName:(NSString *)imageName withGifName:(NSString *)gifName;
- (instancetype)initWithIsDelete:(BOOL) isDelete;
- (instancetype)initWithIsBlank:(BOOL) isBlank;
@end
