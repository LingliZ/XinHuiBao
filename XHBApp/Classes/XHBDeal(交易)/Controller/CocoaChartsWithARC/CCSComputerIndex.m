//
//  CCSComputerIndex.m
//  PriceChart
//
//  Created by 王淼 on 16/5/26.
//  Copyright © 2016年 王淼. All rights reserved.
//


#import "CCSComputerIndex.h"
#import "CCSCandleStickChartData.h"
#import "ta_libc.h"
#import "CCSTALibUtils.h"
#import "CCSMACDData.h"

#import "CCSLineData.h"

@implementation CCSComputerIndex


+ (NSMutableArray *)computeMACDData:(NSArray *)items {
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outMACD = malloc(sizeof(double) * items.count);
    double *outMACDSignal = malloc(sizeof(double) * items.count);
    double *outMACDHist = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_MACD(0,
                                    (int) (items.count - 1),
                                    inCls,
                                    12,
                                    26,
                                    9,
                                    &outBegIdx,
                                    &outNBElement,
                                    outMACD,
                                    outMACDSignal,
                                    outMACDHist);
    
    NSMutableArray *MACDData = [[NSMutableArray alloc] init];
    
    
    
    if (TA_SUCCESS == ta_retCode) {
        
        NSArray *arrMACDSignal = CArrayToNSArray(outMACDSignal, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrMACD = CArrayToNSArray(outMACD, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrMACDHist = CArrayToNSArray(outMACDHist, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            //两倍表示MACD
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [MACDData addObject:[[CCSMACDData alloc] initWithDea:[(NSString *) [arrMACDSignal objectAtIndex:index] doubleValue] * 1000000
                                                            diff:[(NSString *) [arrMACD objectAtIndex:index] doubleValue] * 1000000
                                                            macd:[(NSString *) [arrMACDHist objectAtIndex:index] doubleValue] * 2 * 1000000
                                                            date:item.date]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outMACD);
    freeAndSetNULL(outMACDSignal);
    freeAndSetNULL(outMACDHist);
    
    return MACDData;
}


+ (CCSTitledLine *)computeMAData:(NSArray *)items  param:(CCSSMAParam *) param {
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    switch (param.smaDataType) {
        case OPEN:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                CCSCandleStickChartData *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.open]];
            }
        }
            break;
        case HIGH:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                CCSCandleStickChartData *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.high]];
            }
        }
            break;
        case LOW:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                CCSCandleStickChartData *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.low]];
            }
        }
            break;
        case CLOSE:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                CCSCandleStickChartData *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.close]];
            }
        }
            break;
        default:
            break;
    }
    
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outReal = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_MA(0,
                                  (int) (items.count - 1),
                                  inCls,
                                  param.period,
                                  param.type,
                                  &outBegIdx,
                                  &outNBElement,
                                  outReal);
    
    NSMutableArray *maData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arr = CArrayToNSArray(outReal, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [maData addObject:[[CCSLineData alloc] initWithValue:[[arr objectAtIndex:index] doubleValue] date:item.date]];
        }

        //freeAndSetNULL((__bridge void *)(arr));
        
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outReal);
    
    CCSTitledLine *maline = [[CCSTitledLine alloc] init];
    
    
    maline.title = [NSString stringWithFormat:@"MA%d",param.period];
    
    
    if (param.tag == 0) {
        maline.color = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    } else if (1 == param.tag) {
        maline.color =  [UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    }else if (2== param.tag) {
        maline.color = [UIColor colorWithRed:216.0/255.0 green:128.0/255.0 blue:210.0/255.0 alpha:1.0];
    }else if (3== param.tag) {
        maline.color =[UIColor colorWithRed:0 green:.43 blue:.09 alpha:1];
    }
    
    
    maline.data = maData;
    
    return maline;
}


+ (NSMutableArray *)computeBOLLData:(NSArray *)items {
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init] ;

    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outRealUpperBand = malloc(sizeof(double) * items.count);
    double *outRealBollBand = malloc(sizeof(double) * items.count);
    double *outRealLowerBand = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_BBANDS(0,
                                      (int) (items.count - 1),
                                      inCls,
                                      20,
                                      2,
                                      2,
                                      TA_MAType_SMA,
                                      &outBegIdx,
                                      &outNBElement,
                                      outRealUpperBand,
                                      outRealBollBand,
                                      outRealLowerBand);
    
    NSMutableArray *bollLinedataUPPER = [[NSMutableArray alloc] init];
    NSMutableArray *bollLinedataLOWER = [[NSMutableArray alloc] init];
    NSMutableArray *bollLinedataBOLL = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrUPPER = CArrayToNSArray(outRealUpperBand, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrBOLL = CArrayToNSArray(outRealBollBand, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrLOWER = CArrayToNSArray(outRealLowerBand, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [bollLinedataUPPER addObject:[[CCSLineData alloc] initWithValue:[[arrUPPER objectAtIndex:index] doubleValue] date:item.date]];
            [bollLinedataLOWER addObject:[[CCSLineData alloc] initWithValue:[[arrLOWER objectAtIndex:index] doubleValue] date:item.date]];
            [bollLinedataBOLL addObject:[[CCSLineData alloc] initWithValue:[[arrBOLL objectAtIndex:index] doubleValue] date:item.date]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outRealUpperBand);
    freeAndSetNULL(outRealBollBand);
    freeAndSetNULL(outRealLowerBand);
    
    
    
    CCSTitledLine *bollLineUPPER = [[CCSTitledLine alloc] init];
    bollLineUPPER.data = bollLinedataUPPER;
    bollLineUPPER.color =  [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    bollLineUPPER.title = @"UPPER";
    
    CCSTitledLine *bollLineLOWER = [[CCSTitledLine alloc] init];
    bollLineLOWER.data = bollLinedataLOWER;
    bollLineLOWER.color =[UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    bollLineLOWER.title = @"DN";
    
    CCSTitledLine *bollLineBOLL = [[CCSTitledLine alloc] init];
    bollLineBOLL.data = bollLinedataBOLL;
    bollLineBOLL.color = [UIColor colorWithRed:216.0/255.0 green:128.0/255.0 blue:210.0/255.0 alpha:1.0];
    bollLineBOLL.title = @"MA";
    
    NSMutableArray *bollBanddata = [[NSMutableArray alloc] init];
    
    [bollBanddata addObject:bollLineUPPER];
    [bollBanddata addObject:bollLineLOWER];
    [bollBanddata addObject:bollLineBOLL];
    
    return bollBanddata;
}


+ (NSMutableArray *)computeKDJData:(NSArray *)items {
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble: item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outSlowK = malloc(sizeof(double) * items.count);
    double *outSlowD = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_STOCH(0,
                                     (int) (items.count - 1),
                                     inHigval,
                                     inLowval,
                                     inCls,
                                     9,
                                     3,
                                     TA_MAType_EMA,
                                     3,
                                     TA_MAType_EMA,
                                     &outBegIdx,
                                     &outNBElement,
                                     outSlowK,
                                     outSlowD);
    
    NSMutableArray *slowKLineData = [[NSMutableArray alloc] init];
    NSMutableArray *slowDLineData = [[NSMutableArray alloc] init];
    NSMutableArray *slow3K2DLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrSlowK = CArrayToNSArray(outSlowK, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrSlowD = CArrayToNSArray(outSlowD, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [slowKLineData addObject:[[CCSLineData alloc] initWithValue:[[arrSlowK objectAtIndex:index] doubleValue] date:item.date]];
            [slowDLineData addObject:[[CCSLineData alloc] initWithValue:[[arrSlowD objectAtIndex:index] doubleValue] date:item.date]];
            
            double slowKLine3k2d = 3 * [[arrSlowK objectAtIndex:index] doubleValue] - 2 * [[arrSlowD objectAtIndex:index] doubleValue];
            [slow3K2DLineData addObject:[[CCSLineData alloc] initWithValue:slowKLine3k2d date:item.date]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outSlowK);
    freeAndSetNULL(outSlowD);
    
    
    
    
    CCSTitledLine *slowKLine = [[CCSTitledLine alloc] init];
    slowKLine.data = slowKLineData;
    slowKLine.color = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    slowKLine.title = @"K";
    
    CCSTitledLine *slowDLine = [[CCSTitledLine alloc] init];
    slowDLine.data = slowDLineData;
    slowDLine.color = [UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    slowDLine.title = @"D";
    
    CCSTitledLine *slow3K2DLine = [[CCSTitledLine alloc] init];
    slow3K2DLine.data = slow3K2DLineData;
    slow3K2DLine.color =  [UIColor colorWithRed:216.0/255.0 green:128.0/255.0 blue:210.0/255.0 alpha:1.0];
    slow3K2DLine.title = @"J";
    
    NSMutableArray *kdjData = [[NSMutableArray alloc] init];
    [kdjData addObject:slowKLine];
    [kdjData addObject:slowDLine];
    [kdjData addObject:slow3K2DLine];
    
    return kdjData;
}





+ (CCSTitledLine *)computeRSIData:(NSArray *)items period:(int)period {
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outReal = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_RSI(0,
                                   (int) (items.count - 1),
                                   inCls,
                                   period,
                                   &outBegIdx,
                                   &outNBElement,
                                   outReal);
    
    NSMutableArray *rsiLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arr = CArrayToNSArray(outReal, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [rsiLineData addObject:[[CCSLineData alloc] initWithValue:[[arr objectAtIndex:index] doubleValue] date:item.date]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outReal);
    
    CCSTitledLine *rsiLine = [[CCSTitledLine alloc] init];
    rsiLine.title = [NSString stringWithFormat:@"RSI%d", period];
    
    rsiLine.data = rsiLineData;
    
    
    
    if (6 == period) {
        rsiLine.color = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];    }
    else if (12 == period) {
        rsiLine.color = [UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    } else if (24 == period) {
        rsiLine.color = [UIColor colorWithRed:216.0/255.0 green:128.0/255.0 blue:210.0/255.0 alpha:1.0];
    }
    
    return rsiLine;
}




+ (NSMutableArray *)computeADXData:(NSArray *)items {
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble: item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outADX = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_ADX(0,
                                   (int) (items.count - 1),
                                   inHigval,
                                   inLowval,
                                   inCls,
                                   9,
                                   &outBegIdx,
                                   &outNBElement,
                                   outADX);
    
    NSMutableArray *ADXLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outADX, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [ADXLineData addObject:[[CCSLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.date]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outADX);
    
    CCSTitledLine *adxLine = [[CCSTitledLine alloc] init];
    adxLine.data = ADXLineData;
    adxLine.color =  [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    
    adxLine.title = @"ADX(9)";
    
    
    NSMutableArray *adxData = [[NSMutableArray alloc] init];
    [adxData addObject:adxLine];
    
    return adxData;
    
}

+ (NSMutableArray *)computeATRData:(NSArray *)items {
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble:item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outATR = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_ATR(0,
                                   (int) (items.count - 1),
                                   inHigval,
                                   inLowval,
                                   inCls,
                                   15,
                                   &outBegIdx,
                                   &outNBElement,
                                   outATR);
    
    NSMutableArray *ATRLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outATR, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [ATRLineData addObject:[[CCSLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.date]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outATR);
    
    CCSTitledLine *atrLine = [[CCSTitledLine alloc] init];
    atrLine.data = ATRLineData;
    atrLine.color = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    
    atrLine.title = @"ATR(15)";
    
    
    NSMutableArray *atrData = [[NSMutableArray alloc] init];
    [atrData addObject:atrLine];
    
    return atrData;
    
}



+ (NSMutableArray *)computeDMIData:(NSArray *)items {
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble:item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        CCSCandleStickChartData *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:item.close]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outDX = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_DX(0,
                                  (int) (items.count - 1),
                                  inHigval,
                                  inLowval,
                                  inCls,
                                  20,
                                  &outBegIdx,
                                  &outNBElement,
                                  outDX);
    
    NSMutableArray *DXLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outDX, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            CCSCandleStickChartData *item = [items objectAtIndex:index];
            [DXLineData addObject:[[CCSLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.date]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outDX);
    
    CCSTitledLine *dxLine = [[CCSTitledLine alloc] init];
    dxLine.data = DXLineData;
    dxLine.color =  [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    
    dxLine.title = @"DMI(20)";
    
    
    NSMutableArray *dxData = [[NSMutableArray alloc] init];
    [dxData addObject:dxLine];
    
    return dxData;
    
}



@end