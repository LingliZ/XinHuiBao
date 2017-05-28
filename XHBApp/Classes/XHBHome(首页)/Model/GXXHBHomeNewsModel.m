//
//  GXXHBHomeNewsModel.m
//  XHBApp
//
//  Created by 王振 on 2016/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeNewsModel.h"

@implementation GXXHBHomeNewsModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}




@end
