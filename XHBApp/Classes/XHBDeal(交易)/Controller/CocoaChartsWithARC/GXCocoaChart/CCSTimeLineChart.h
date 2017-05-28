//
//  CCSTimeLineChart.h
//  PriceChart
//
//  Created by 王淼 on 16/5/24.
//  Copyright © 2016年 王淼. All rights reserved.
//

#import "CCSSlipLineChart.h"
#import "CCSTimeLineData.h"
#import "CCSLineData.h"
#import "CCSTitledLine.h"
#import "CCSTimeLineItemData.h"

#import "CCSBandAreaChart.h"
#import "CCSAreaChart.h"



typedef enum {
    CCSTimeLineShowCross,
    CCSTimeLineChangeLandscape,
    CCSTimeLineHideCross
} CCSTimeLineMode;

@protocol CCSTimeLineChartDelegate <NSObject>
@optional
- (void) CCSTimeLineChartChangeMode:(CCSTimeLineMode) timeLineMode;
@end


@interface CCSTimeLineChart : CCSSlipLineChart {
   
      NSTimer* pressTimer;
      BOOL isLongPress;
    
}


@property(strong, nonatomic) NSMutableArray *singlelinedatas;

@property(strong, nonatomic) UIView* deatailView;

@property(strong, nonatomic) UILabel* priceTitle;

@property(strong, nonatomic) UILabel* timeTitle;


@property(strong, nonatomic) UILabel* priceValue;

@property(strong, nonatomic) UILabel* timeValue;


// 是否全屏
@property (nonatomic, assign) BOOL isFullScreen;



- (id)initWithFrame:(CGRect)frame;


- (void) setTimeLineData:(CCSTimeLineData*) timeLineData;


- (void) hideCross;


@property(assign, nonatomic) UIViewController<CCSTimeLineChartDelegate> *timeLineChartDelegate;


@end