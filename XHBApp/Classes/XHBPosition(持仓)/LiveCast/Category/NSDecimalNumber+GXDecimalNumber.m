//
//  NSDecimalNumber+GXDecimalNumber.m
//  GXApp
//
//  Created by zhudong on 16/8/18.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSDecimalNumber+GXDecimalNumber.h"

@implementation NSDecimalNumber (GXDecimalNumber)
+ (NSDecimalNumber *)dealDecimalNumber:(NSDecimalNumber *)sourceNumber{
    NSDecimalNumberHandler *roundup = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:3 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *tempNumber = [[NSDecimalNumber alloc] initWithDecimal:sourceNumber.decimalValue];
    NSDecimalNumber *result = [tempNumber decimalNumberByRoundingAccordingToBehavior:roundup];
    return result;
}

+ (NSDecimalNumber *)dealDecimalNumber:(NSDecimalNumber *)sourceNumber withScale:(NSInteger )scale {
    NSDecimalNumberHandler *roundup = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *tempNumber = [[NSDecimalNumber alloc] initWithDecimal:sourceNumber.decimalValue];
    NSDecimalNumber *result = [tempNumber decimalNumberByRoundingAccordingToBehavior:roundup];
    return result;
}

@end
