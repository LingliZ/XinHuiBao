//
//  CCSKLineWithIndexChart.h
//  PriceChart
//
//  Created by 王淼 on 16/5/25.
//  Copyright © 2016年 王淼. All rights reserved.
//

#import "CCSMACDChart.h"
#import "CCSBOLLMASlipCandleStickChart.h"
#import "CCSSlipLineChart.h"
#import "CCSTimeLineData.h"
#import "CCSLineData.h"
#import "CCSTitledLine.h"
#import "CCSKLineItemData.h"
#import "CCSKLineData.h"
#import "CCSSMAParam.h"
#import "PriceMarketModel.h"


// 显示十字线的枚举
typedef NS_ENUM(NSInteger,CCSKLineMode){
    CCSKLineShowCross,
    CCSKLineChangeClick,
    CCSKLineHideCross
};

// 下部分指标枚举
typedef NS_ENUM(NSInteger, KLineChartIndexBottomType){
    MACD,
    KDJ,
    RSI,
    ADX,
    ATR,
    DMI,
};

// 上部分指标枚举
typedef NS_ENUM(NSInteger, KLineChartIndexTopType){
    MA,
    BOLL,
};


@protocol CCSKLineChartDelegate <NSObject>

@optional
- (void) CCSKLineChartChangeMode:(CCSKLineMode) kLineMode;
@end


@interface CCSKLineWithIndexChart : UIView<CCSChartDelegate> {
    NSTimer *pressTimer;
    BOOL isLongPress;
//    CGRect klineRect;
//    CGRect indexRect;
    NSArray *smaParams;
    KLineChartIndexTopType indexTopType;
    KLineChartIndexBottomType indexBottomType;
    
}



@property (strong, nonatomic) CCSBOLLMASlipCandleStickChart *candleStickChart;//蜡烛图
@property (strong, nonatomic) CCSMACDChart *macdChart;//柱状图
@property (strong, nonatomic) CCSSlipLineChart *lineIndexChart;// 线形图
@property (strong, nonatomic) NSArray *klineData;// 数据源

@property(strong, nonatomic) UIView  *deatailView; // 悬浮视图
@property(strong, nonatomic) UILabel *timeValue;   // 时间
@property(strong, nonatomic) UILabel *openTitle;   // 开盘
@property(strong, nonatomic) UILabel *highTitle;   // 最高
@property(strong, nonatomic) UILabel *lowTitle;    // 最低
@property(strong, nonatomic) UILabel *closeTitle;  // 收盘

@property(strong, nonatomic) UILabel *openValue;   // 开盘数值
@property(strong, nonatomic) UILabel *highValue;   // 最高数值
@property(strong, nonatomic) UILabel *lowValue;    // 最低数值
@property(strong, nonatomic) UILabel *closeValue;  // 收盘数值


@property (nonatomic, strong) UIView *macdLineView; // macd底部的线

@property (nonatomic, strong) PriceMarketModel *marketModel;

@property (nonatomic, assign)CGRect klineRect;
@property (nonatomic, assign)CGRect indexRect;


@property(strong, nonatomic) NSMutableArray *indexTiltes; // index
@property(strong, nonatomic) NSMutableArray *indexValues; // index数值

@property(assign, nonatomic) UIViewController<CCSKLineChartDelegate> *kLineChartDelegate;


// 设置frame
- (id)initWithFrame:(CGRect)frame;
// 设置数据源
- (void)setKLineData:(CCSKLineData*) kLineData interval:(NSString *)interval;
// 设置指标
-(void)setIndex:(KLineChartIndexTopType)kLineChartIndexTopType kLineChartIndexBottomType:(KLineChartIndexBottomType) kLineChartIndexBottomType smaParamArray:(NSArray*) smaParamArray;
// 刷新视图
- (void)reloadFrame;

- (void) hideCross;

@end
