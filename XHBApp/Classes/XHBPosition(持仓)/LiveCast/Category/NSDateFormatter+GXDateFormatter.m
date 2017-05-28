//
//  NSDateFormatter+GXDateFormatter.m
//  GXApp
//
//  Created by zhudong on 16/7/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSDateFormatter+GXDateFormatter.h"

@implementation NSDateFormatter (GXDateFormatter)
+ (instancetype)shareFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[self alloc] init];
    });
    return dateFormatter;
}
@end
