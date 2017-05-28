//
//  NSDecimalNumber+GXDecimalNumber.h
//  GXApp
//
//  Created by zhudong on 16/8/18.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (GXDecimalNumber)
+ (NSDecimalNumber *)dealDecimalNumber:(NSDecimalNumber *)sourceNumber;
+ (NSDecimalNumber *)dealDecimalNumber:(NSDecimalNumber *)sourceNumber withScale:(NSInteger )scale;

@end
