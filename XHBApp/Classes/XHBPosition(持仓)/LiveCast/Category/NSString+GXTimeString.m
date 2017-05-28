//
//  NSString+GXTimeString.m
//  GXApp
//
//  Created by zhudong on 16/8/16.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSString+GXTimeString.h"
#import "NSDateFormatter+GXDateFormatter.h"

@implementation NSString (GXTimeString)
+ (NSString *)getTimeString:(NSString *)dateFormatterStr sourceTimeStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:timeStr];
    formatter.dateFormat = dateFormatterStr;
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
@end
