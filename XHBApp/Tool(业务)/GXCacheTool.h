//
//  GXCacheTool.h
//  基础
//
//  Created by yangfutang on 16/6/24.
//  Copyright © 2016年 yangFutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

@interface GXCacheTool : YYCache

+ (instancetype)CacheWithName:(NSString *)name;

@end
