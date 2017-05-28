//
//  GXCommentModel.m
//  GXApp
//
//  Created by GXJF on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCommentModel.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXCommentModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
//计算title的宽度



@end
