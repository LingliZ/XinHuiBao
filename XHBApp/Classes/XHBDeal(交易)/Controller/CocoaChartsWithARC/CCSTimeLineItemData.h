//
//  CCSTimeLineItemData.h
//  PriceChart
//
//  Created by 王淼 on 16/5/25.
//  Copyright © 2016年 王淼. All rights reserved.
//



/**
 *   "avgPrice":0,
 "current":4338,
 "time":1467669600000,
 "volume":0
 */

#import <Foundation/Foundation.h>

@interface CCSTimeLineItemData : NSObject


@property(assign, nonatomic) float avgPrice;
@property(assign, nonatomic) float current;
@property(assign, nonatomic) long long time;
@property(assign, nonatomic) float volume;


@end