//
//  CCSTimeLineData.m
//  PriceChart
//
//  Created by 王淼 on 16/5/25.
//  Copyright © 2016年 王淼. All rights reserved.
//


#import "CCSTimeLineData.h"
#import "CCSTimeLineItemData.h"



@implementation CCSTimeLineData

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"timeLineItemList" : [CCSTimeLineItemData class]};
}



@end

