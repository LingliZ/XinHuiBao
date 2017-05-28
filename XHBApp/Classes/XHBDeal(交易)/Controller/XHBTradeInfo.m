//
//  XHBTradeInfo.m
//  XHBApp
//
//  Created by shenqilong on 17/3/6.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTradeInfo.h"

@implementation XHBTradeInfo
//计算占用保证金
+(CGFloat)compleUseMarginAmount:(CGFloat)amount code:(NSString *)code type:(NSString *)type
{
    return amount*1000;
}

@end
