//
//  NSString+GXTimeString.h
//  GXApp
//
//  Created by zhudong on 16/8/16.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GXTimeString)
+ (NSString *)getTimeString:(NSString *)dateFormatterStr sourceTimeStr:(NSString *)timeStr;
@end
