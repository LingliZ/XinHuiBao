//
//  CCSComputerIndex.h
//  PriceChart
//
//  Created by 王淼 on 16/5/26.
//  Copyright © 2016年 王淼. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CCSSMAParam.h"

#import "CCSTitledLine.h"


@interface CCSComputerIndex : NSObject
{
}

+ (NSMutableArray *)computeMACDData:(NSArray *)items;

+ (CCSTitledLine *) computeMAData:(NSArray *)items  param:(CCSSMAParam *) param;

+ (NSMutableArray *) computeBOLLData:(NSArray *)items;

+ (NSMutableArray *)computeKDJData:(NSArray *)items;

+ (CCSTitledLine *)computeRSIData:(NSArray *)items period:(int)period;

+ (NSMutableArray *)computeADXData:(NSArray *)items;

+ (NSMutableArray *)computeATRData:(NSArray *)items;

+ (NSMutableArray *)computeDMIData:(NSArray *)items;

@end