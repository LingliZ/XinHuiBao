//
//  CCSKLineItemData.h
//  PriceChart
//
//  Created by 王淼 on 16/5/26.
//  Copyright © 2016年 王淼. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CCSKLineItemData : NSObject


@property (strong, nonatomic) NSString *time;


@property (assign, nonatomic) float open;

@property (assign, nonatomic) float high;

@property (assign, nonatomic) float low;

@property (assign, nonatomic) float close;

// 昨收
@property (nonatomic, copy) NSString *lastclose;



@end