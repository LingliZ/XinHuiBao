//
//  GXMechanismPointModel.m
//  GXApp
//
//  Created by GXJF on 16/7/6.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXMechanismPointModel.h"

@implementation GXMechanismPointModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
