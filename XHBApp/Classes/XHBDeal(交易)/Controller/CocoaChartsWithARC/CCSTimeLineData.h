//
//  CCSTimeLineData.h
//  PriceChart
//
//  Created by 王淼 on 16/5/25.
//  Copyright © 2016年 王淼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSTimeLineData : NSObject


@property(strong, nonatomic) NSString *duration;
@property(assign, nonatomic) float lastclose;
@property(strong, nonatomic) NSString *openTime;
@property(strong, nonatomic) NSArray *timeLineItemList;



@end