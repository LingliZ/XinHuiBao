//
//  CCSSMAParam .h
//  PriceChart
//
//  Created by 王淼 on 16/5/27.
//  Copyright © 2016年 王淼. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ta_libc.h"

/**
 *  MA基准值
 */
typedef NS_ENUM(NSInteger, SMADataType) {
    /**
     *  开
     */
    OPEN,
    /**
     *  高
     */
    HIGH,
    /**
     *  低
     */
    LOW,
    /**
     * 收
     */
    CLOSE
};



@interface CCSSMAParam : NSObject<NSCoding>


/**
 *  MA基准值
 */
@property(assign, nonatomic) SMADataType smaDataType;

/**
 *  线性选择：TA_MAType_SMA=0 算数平均,TA_MAType_EMA=1,线性加权 TA_MAType_WMA=2, 指数加权 TA_MAType_TRIMA=5 三角
 */
@property(assign, nonatomic) TA_MAType type;

/**
 *  周期
 */
@property(assign, nonatomic) int period;

/**
 *  tag
 */
@property(assign, nonatomic) int tag;
@end