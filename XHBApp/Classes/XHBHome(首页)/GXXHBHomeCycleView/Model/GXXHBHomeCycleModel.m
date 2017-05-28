//
//  GXXHBHomeCycleModel.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeCycleModel.h"

@implementation GXXHBHomeCycleModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
