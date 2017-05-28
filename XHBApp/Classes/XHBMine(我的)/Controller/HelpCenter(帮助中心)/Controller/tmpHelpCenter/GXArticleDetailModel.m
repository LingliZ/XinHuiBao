//
//  GXArticleDetailModel.m
//  GXApp
//
//  Created by GXJF on 16/7/5.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXArticleDetailModel.h"

@implementation GXArticleDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        [self.ID setValuesForKeysWithDictionary:value];
    }
}

@end
