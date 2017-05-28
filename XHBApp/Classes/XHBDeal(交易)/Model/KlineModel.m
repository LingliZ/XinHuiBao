//
//  KlineModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "KlineModel.h"

@implementation KlineModel
- (NSString *)time {
    return [NSString StringFromquoteTime_notHMM:_time];
}

@end
