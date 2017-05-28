//
//  CCSKLineWithIndexChart.m
//  PriceChart
//
//  Created by 王淼 on 16/5/25.
//  Copyright © 2016年 王淼. All rights reserved.
//

#import "CCSKLineWithIndexChart.h"
#import "CCSStringUtils.h"

#import "CCSCandleStickChartData.h"
#import "CCSComputerIndex.h"
#import "CCSMACDData.h"


#define CCSKLineWithIndexChartFontSize (IS_IPHONE_6 ? 8:(IS_IPHONE_6P ? 8:7))
#define DetailWhiteColor  [UIColor whiteColor]

#define CCSKLineWithIndexAxisMarginLeft WidthScale_IOS6(40)
#define CCSKLineWithIndexAxisMarginRight     WidthScale_IOS6(20)



@interface CCSKLineWithIndexChart ()
@property(nonatomic, copy) NSString *lastclose;
@end


@implementation CCSKLineWithIndexChart

#pragma mark - getter
- (UIView *)macdLineView {
    if (!_macdLineView) {
        _macdLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.macdChart.height - self.macdChart.axisMarginBottom)];
        _macdLineView.backgroundColor = [UIColor blackColor];
        _macdLineView.hidden = YES;
        [self.macdChart addSubview:_macdLineView];
    }
    return _macdLineView;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*
        if (IS_IPHONE_6) {
            _klineRect = CGRectMake(0, 0, frame.size.width, frame.size.height *0.4);
            _indexRect = CGRectMake(0, frame.size.height *0.75, frame.size.width, frame.size.height *0.2);
        } else if (IS_IPHONE_6P){
            _klineRect = CGRectMake(0, 0, frame.size.width, frame.size.height *0.45);
            _indexRect = CGRectMake(0, frame.size.height *0.85, frame.size.width, frame.size.height *0.2);
        } else {
            _klineRect = CGRectMake(0, 0, frame.size.width, frame.size.height *0.6);
            _indexRect = CGRectMake(0, frame.size.height *0.8, frame.size.width, frame.size.height *0.2);
        }
        */
        
        _klineRect = CGRectMake(0, 0, frame.size.width, frame.size.height -88);
        _indexRect = CGRectMake(0, frame.size.height -88, frame.size.width, 88);
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;//K线
        
        //初始化蜡烛图
        [self initCandleStickChart];
        //MACD
        [self initMACDChart];
        // K线图
        [self initLineIndexChart];
        // 悬浮视图
        [self initDeatailTitle:frame];
        [self.candleStickChart addTarget:self action:@selector(kChartUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.candleStickChart addTarget:self action:@selector(kChartDown:) forControlEvents:UIControlEventTouchDown];
        
    
    }
    return self;
}




-(void)setIndex:(KLineChartIndexTopType)kLineChartIndexTopType kLineChartIndexBottomType:(KLineChartIndexBottomType) kLineChartIndexBottomType smaParamArray:(NSArray*) smaParamArray {
    
    indexTopType = kLineChartIndexTopType;
    
    if (kLineChartIndexTopType == MA) {
        smaParams = smaParamArray;
        [self initMAChartData:smaParamArray];
    }
    else if(kLineChartIndexTopType == BOLL) {
        [self initBOLLChartData];
    }
    indexBottomType = kLineChartIndexBottomType;
    if (kLineChartIndexBottomType == MACD) {
        [self.macdChart setHidden:NO];
        [self.lineIndexChart  setHidden:YES];
        [self initMACDChartData];
    }

    else if (kLineChartIndexBottomType == KDJ) {
        [self.macdChart setHidden:YES];
        [self.lineIndexChart  setHidden:NO];
        [self initKDJChartData];
    }
    else if (kLineChartIndexBottomType == RSI) {
        [self.macdChart setHidden:YES];
        [self.lineIndexChart  setHidden:NO];
        [self initRSIChartData];
    }
    else if(indexBottomType == ADX)
    {
        [self.macdChart setHidden:YES];
        [self.lineIndexChart  setHidden:NO];
        [self initADXChartData];
    }
    else if(indexBottomType == ATR)
    {
        [self.macdChart setHidden:YES];
        [self.lineIndexChart  setHidden:NO];
        [self initATRChartData];
    }
    else if(indexBottomType == DMI)
    {
        [self.macdChart setHidden:YES];
        [self.lineIndexChart  setHidden:NO];
        [self initDMIChartData];
    }

}


// 初始化K线图
- (void)initLineIndexChart {
    
    // 创建K线图
    self.lineIndexChart = [[CCSSlipLineChart alloc] initWithFrame:_indexRect];
    self.lineIndexChart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //设置stickData
    self.lineIndexChart.latitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    self.lineIndexChart.longitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    self.lineIndexChart.latitudeFontColor = [UIColor blackColor];
    self.lineIndexChart.longitudeFontColor = [UIColor blackColor];
    self.lineIndexChart.axisMarginLeft = CCSKLineWithIndexAxisMarginLeft;
    self.lineIndexChart.axisMarginRight = 5;
    self.lineIndexChart.axisMarginTop = 1;
    self.lineIndexChart.axisYPosition = CCSGridChartYAxisPositionLeft;
    self.lineIndexChart.displayCrossXOnTouch = NO;
    self.lineIndexChart.displayCrossYOnTouch = NO;
    self.lineIndexChart.latitudeNum = 2;
    self.lineIndexChart.longitudeNum = 3;
    self.lineIndexChart.axisMarginBottom = 0;
    self.lineIndexChart.displayLongitude = NO;
    self.lineIndexChart.userInteractionEnabled = NO;
    self.lineIndexChart.backgroundColor = GXRGBColor(248, 248, 248);
    self.lineIndexChart.crossLinesColor = [UIColor blackColor];
    self.lineIndexChart.borderColor  = GXLineColor;

    [self addSubview:self.lineIndexChart];
}




// 初始化MACD视图
- (void)initMACDChart{

    self.macdChart = [[CCSMACDChart alloc] initWithFrame:_indexRect];
    self.macdChart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    //设置stickData
    self.macdChart.minDisplayNumber = 10;
    self.macdChart.maxValue = 800000;
    self.macdChart.minValue = 0;
   
    self.macdChart.displayCrossXOnTouch = YES;
    self.macdChart.stickFillColor = [UIColor colorWithRed:0.7 green:0.7 blue:0 alpha:0.8];
    
    
    self.macdChart.latitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    self.macdChart.longitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    
    self.macdChart.latitudeFontColor = GXBlackColor;
    self.macdChart.latitudeFont = GXFONT_PingFangSC_Regular(CCSKLineWithIndexChartFontSize);
    self.macdChart.latitudeFontColor = GXBlackColor;
  
    
    self.macdChart.longitudeFont = GXFONT_PingFangSC_Regular(CCSKLineWithIndexChartFontSize);
    self.macdChart.longitudeFontColor = GXBlackColor;
    self.macdChart.longitudeFont = GXFONT_PingFangSC_Regular(CCSKLineWithIndexChartFontSize);
    
    self.macdChart.axisMarginLeft = CCSKLineWithIndexAxisMarginLeft;
    self.macdChart.axisTextMarginLeft = WidthScale_IOS6(5);
    self.macdChart.axisMarginTop = 0;
    self.macdChart.axisMarginBottom = 10;
    self.macdChart.axisYPosition = CCSGridChartYAxisPositionLeft;
    

    
    self.macdChart.maxValue = 300000;
    self.macdChart.minValue = -300000;
    self.macdChart.maxSticksNum = 100;
    self.macdChart.latitudeNum = 1;
    self.macdChart.longitudeNum = 1;
    self.macdChart.macdDisplayType = CCSMACDChartDisplayTypeStick;
    self.macdChart.positiveStickColor = [UIColor redColor];
    self.macdChart.negativeStickColor = [UIColor colorWithRed:5.0/255.0 green:168.0/255.0 blue:62.0/255.0 alpha:1];
    self.macdChart.macdLineColor = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    self.macdChart.deaLineColor = [UIColor colorWithRed:0 green:.43 blue:.09 alpha:1];
    self.macdChart.diffLineColor =  [UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    self.macdChart.crossLinesColor = [UIColor clearColor];
    self.macdChart.userInteractionEnabled = NO;
    self.macdChart.axisCalc = 1000000;
    self.macdChart.displayLongitude = NO;
   
    self.macdChart.borderColor = GXLineColor;
    self.macdChart.backgroundColor = GXRGBColor(248, 248, 248);

    
    [self  addSubview:self.macdChart];
}








- (void) initCandleStickChart{
    self.candleStickChart = [[CCSBOLLMASlipCandleStickChart alloc] initWithFrame:_klineRect];
    
    //self.candleStickChart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.candleStickChart.maxValue = 320;
    self.candleStickChart.minValue = 220;
    self.candleStickChart.displayLongitudeTitle = YES;
    self.candleStickChart.displayLatitudeTitle = YES;
    self.candleStickChart.axisMarginBottom = 12;
    self.candleStickChart.maxSticksNum = 50;
    self.candleStickChart.latitudeNum = 5;
    self.candleStickChart.longitudeNum = 3;
    self.candleStickChart.userInteractionEnabled = YES;
    self.candleStickChart.axisCalc = 1;
    self.candleStickChart.axisMarginBottom = 15;
    self.candleStickChart.minDisplayNumber = 5;
    self.candleStickChart.displayCrossYOnTouch = NO;
    self.candleStickChart.displayCrossXOnTouch = NO;
    self.candleStickChart.bollingerBandStyle = CCSBollingerBandStyleNone;
    self.candleStickChart.chartDelegate = self;
    
    
    self.candleStickChart.axisXColor = [UIColor colorWithRed:212.0/255.0 green:214.0/255.0 blue:217.0/255.0 alpha:1.0];
    self.candleStickChart.axisYColor = [UIColor colorWithRed:212.0/255.0 green:214.0/255.0 blue:217.0/255.0 alpha:1.0];
    
    // 十字线字的颜色
    self.candleStickChart.crossLinesColor = [UIColor colorWithWhite:0.000 alpha:0.902];
    self.candleStickChart.crossLinesFontColor = [UIColor whiteColor];
    

    // y轴文字距离
    self.candleStickChart.axisTextMarginLeft = WidthScale_IOS6(5);
    self.candleStickChart.axisMarginLeft = CCSKLineWithIndexAxisMarginLeft;
    self.candleStickChart.axisMarginRight = CCSKLineWithIndexAxisMarginRight;
    // X轴底部
    self.candleStickChart.axisTextMarginBottom = HeightScale_IOS6(4);
    
    
    
    // 纬线
    self.candleStickChart.latitudeFont = GXFONT_Helvetica(CCSKLineWithIndexChartFontSize);
    self.candleStickChart.latitudeFontColor = GXBlackColor;
    self.candleStickChart.longitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    // 经线
    self.candleStickChart.longitudeFont = GXFONT_Helvetica(CCSKLineWithIndexChartFontSize);
    self.candleStickChart.longitudeFontColor = GXBlackColor;
    self.candleStickChart.latitudeColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:.3f];
    //?
    self.candleStickChart.crossStarColor = [UIColor blackColor];
    self.candleStickChart.colorStickStyle = 0;
    
    
    self.candleStickChart.borderColor = GXLineColor;
    self.candleStickChart.backgroundColor = GXRGBColor(248, 248, 248);
    
    [self addSubview:self.candleStickChart];
}





-(void) initDeatailTitle:(CGRect)frame{
    
    self.deatailView = [[UIView alloc] initWithFrame:CGRectMake(self.candleStickChart.axisMarginLeft, 0, 100, 135)];
    self.deatailView.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.702];
    self.deatailView.hidden = YES;
    
    self.timeValue = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.deatailView.width, 15)];
    self.timeValue.font = [UIFont systemFontOfSize:9];
    self.timeValue.textAlignment = NSTextAlignmentCenter;
    self.timeValue.textColor = DetailWhiteColor;
    [self.deatailView addSubview:self.timeValue];
    
    self.openTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 90, 15)];
    self.openTitle.font = [UIFont systemFontOfSize:9];
    self.openTitle.text = @"开盘价：";
    self.openTitle.textColor = DetailWhiteColor;
    [self.deatailView addSubview:self.openTitle];
    
    
    self.highTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 90, 15)];
    self.highTitle.font = [UIFont systemFontOfSize:9];
    self.highTitle.text = @"最高价：";
    self.highTitle.textColor = DetailWhiteColor;
    [self.deatailView addSubview:self.highTitle];
    
    
    self.lowTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 90, 15)];
    self.lowTitle.font = [UIFont systemFontOfSize:9];
    self.lowTitle.text = @"最低价：";
    self.lowTitle.textColor = DetailWhiteColor;
    [self.deatailView addSubview:self.lowTitle];
    

    self.closeTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 90, 15)];
    self.closeTitle.font = [UIFont systemFontOfSize:9];
    self.closeTitle.text = @"收盘价：";
    self.closeTitle.textColor = DetailWhiteColor;
    [self.deatailView addSubview:self.closeTitle];

    
    self.openValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 90, 15)];
    self.openValue.font = [UIFont systemFontOfSize:9];
    self.openValue.textAlignment = NSTextAlignmentRight;
    [self.deatailView addSubview:self.openValue];
    
    
    self.highValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 90, 15)];
    self.highValue.font = [UIFont systemFontOfSize:9];
    self.highValue.textAlignment = NSTextAlignmentRight;
    [self.deatailView addSubview:self.highValue];
    
    
    self.lowValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 90, 15)];
    self.lowValue.font = [UIFont systemFontOfSize:9];
    self.lowValue.textAlignment = NSTextAlignmentRight;
    [self.deatailView addSubview:self.lowValue];
    

    self.closeValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 90, 15)];
    self.closeValue.font = [UIFont systemFontOfSize:9];
    self.closeValue.textAlignment = NSTextAlignmentRight;
    [self.deatailView addSubview:self.closeValue];
    

    _indexTiltes = [NSMutableArray arrayWithCapacity:7];
    _indexValues = [NSMutableArray arrayWithCapacity:7];
    
    for (int i = 0; i < 7; i++) {
        
        UILabel *indexTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 80 + i*15, 90, 15)];
        UILabel *indexValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 80 + i*15, 90, 15)];
        
        indexTitle.font = [UIFont systemFontOfSize:9];
        indexValue.font = [UIFont systemFontOfSize:9];
        indexValue.textAlignment = NSTextAlignmentRight;
        indexTitle.text = [NSString stringWithFormat:@"指标%d:",i];
        
        [self.deatailView addSubview:indexTitle];
        [self.deatailView addSubview:indexValue];
        
        [_indexValues addObject:indexValue];
        [_indexTiltes addObject:indexTitle];
    
    }
    [self.candleStickChart addSubview:self.deatailView];
}


- (void)kChartDown:(UIView *)lineChartDown {
    pressTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(pressTimerAdvanced:) userInfo:nil repeats:NO];
}

//- (void)pressTimerAdvanced:(NSTimer *)timer {
//    
//    if (self.candleStickChart.isMoveFinger == NO) {
//        isLongPress = YES;
//        self.candleStickChart.displayCrossYOnTouch = YES;
//        self.candleStickChart.displayCrossXOnTouch = YES;
//        self.macdChart.displayCrossXOnTouch = YES;
//        self.lineIndexChart.displayCrossXOnTouch = YES;
//        self.deatailView.hidden = NO;
//        [_candleStickChart setNeedsDisplay];
//        
////        if (self.kLineChartDelegate!=nil) {
////            [self.kLineChartDelegate CCSKLineChartChangeMode:CCSKLineHideCross];
////        }
//        
//    }
//    
//}


- (void)pressTimerAdvanced:(NSTimer *)timer {
    
    if (self.candleStickChart.isMoveFinger == NO) {
        isLongPress = YES;
        self.candleStickChart.displayCrossYOnTouch = YES;
        self.candleStickChart.displayCrossXOnTouch = YES;
        self.macdChart.displayCrossXOnTouch = NO;
        self.macdChart.displayCrossYOnTouch = NO;
        self.lineIndexChart.displayCrossXOnTouch = YES;
        self.macdLineView.hidden = NO;
        self.deatailView.hidden = NO;
        
        [_candleStickChart setNeedsDisplay];
        [_macdChart setNeedsDisplay];
        [_lineIndexChart setNeedsDisplay];
    }
}


- (void)kChartUp:(UIView *)sender {
    [pressTimer invalidate];
    
    if (isLongPress) {
         [_candleStickChart setNeedsDisplay];
         isLongPress=NO;
        
    } else {
        
        if (self.candleStickChart.isMoveFinger==NO) {
            self.candleStickChart.displayCrossYOnTouch = NO;
            self.candleStickChart.displayCrossXOnTouch = NO;
            self.macdChart.displayCrossXOnTouch = NO;
            self.lineIndexChart.displayCrossXOnTouch = NO;
            self.macdLineView.hidden = YES;
            self.deatailView.hidden = YES;
            [self.candleStickChart setNeedsDisplay];
            [self.lineIndexChart setNeedsDisplay];
        }
    }
    
}



// 设置数据源
- (void)setKLineData:(CCSKLineData*)kLineData interval:(NSString *)interval{

    self.klineData = kLineData.data;
    NSMutableArray *stickDatas = [[NSMutableArray alloc] initWithCapacity:[self.klineData count]];
    
    for (long i = [self.klineData count]-1; i >= 0; i--) {
        
        CCSKLineItemData *kLineItemData = [self.klineData objectAtIndex:i];
        CCSCandleStickChartData *stickData = [[CCSCandleStickChartData alloc] init];
        stickData.open = kLineItemData.open;
        stickData.high = kLineItemData.high;
        stickData.low = kLineItemData.low;
        stickData.close = kLineItemData.close;
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[kLineItemData.time doubleValue]/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat : @"MM/dd HH:mm"];
        if ([interval isEqualToString:@"week"]||[interval isEqualToString:@"month"]||[interval isEqualToString:@"1440"]) {
             [formatter setDateFormat : @"MM/dd"];
        }
       
        stickData.date = [formatter stringFromDate:confromTimesp];
        [stickDatas addObject:stickData];
    }
    
    
    CCSCandleStickChartData *data1 = [stickDatas objectAtIndex:[self.klineData count]-1];
    
    for (int i = 0; i < 2; i++) {
        CCSCandleStickChartData *data = [[CCSCandleStickChartData alloc] init];
        
        data.open = data1.open;
        data.high = data1.high;
        data.close = data1.close;
        data.low = data1.low;
        data.date = @"xxxx-xxxx-xxxx";
        [stickDatas addObject:data];
    }
    
    
    
    
    self.candleStickChart.stickData = stickDatas;
    self.candleStickChart.minValue = NSIntegerMax;
    self.candleStickChart.maxValue = 0;
    if ([stickDatas count] > 40) {
        self.candleStickChart.displayNumber = 40;
        self.candleStickChart.displayFrom = [stickDatas count]- 40;
    } else {
        self.candleStickChart.displayNumber = [stickDatas count];
        self.candleStickChart.displayFrom = 0;
    }
    
    
    self.candleStickChart.selectedStickIndex = [stickDatas count]-1;
    [self.candleStickChart setNeedsDisplay];
    
    
    
    if (indexTopType == MA) {
        [self initMAChartData:smaParams];
    } else if (indexTopType == BOLL) {
        [self initBOLLChartData];
    }
    
    self.macdChart.displayFrom=self.candleStickChart.displayFrom;
    self.macdChart.displayNumber=self.candleStickChart.displayNumber;
    self.lineIndexChart.displayFrom=self.candleStickChart.displayFrom;
    self.lineIndexChart.displayNumber=self.candleStickChart.displayNumber;
    
    if (indexBottomType == MACD) {
        [self initMACDChartData];
    } else if(indexBottomType == KDJ) {
        [self initKDJChartData];
    } else if(indexBottomType == RSI) {
        [self initRSIChartData];
    } else if(indexBottomType == ADX) {
        [self initADXChartData];
    } else if(indexBottomType == ATR) {
        [self initATRChartData];
    } else if(indexBottomType == DMI) {
        [self initDMIChartData];
    }

}



-(void)initMACDChartData {

    self.macdChart.stickData = [CCSComputerIndex computeMACDData:self.candleStickChart.stickData];
    
    [self.macdChart setNeedsDisplay];
}


-(void)initMAChartData:(NSArray*) smaParamArray {
    
    NSMutableArray *maLines = [[NSMutableArray alloc] init];
    for (CCSSMAParam * smaParam in smaParamArray) {
         [maLines addObject:[CCSComputerIndex computeMAData:self.candleStickChart.stickData param:smaParam]];
    }
     self.candleStickChart.linesData = maLines;
    [self.candleStickChart setNeedsDisplay];
    
}




- (void)initBOLLChartData {
   
    self.candleStickChart.linesData = [CCSComputerIndex computeBOLLData:self.candleStickChart.stickData];
    [self.candleStickChart setNeedsDisplay];

}



- (void)initKDJChartData {
    
    self.lineIndexChart.linesData = [CCSComputerIndex computeKDJData:self.candleStickChart.stickData];
    [self.lineIndexChart setNeedsDisplay];
    
}

- (void)initATRChartData {
    
    self.lineIndexChart.linesData = [CCSComputerIndex computeATRData:self.candleStickChart.stickData];
    [self.lineIndexChart setNeedsDisplay];
}


- (void)initDMIChartData {
    
    self.lineIndexChart.linesData = [CCSComputerIndex computeDMIData:self.candleStickChart.stickData];
    
    [self.lineIndexChart setNeedsDisplay];
   
}

- (void)initRSIChartData {
        NSMutableArray *linesData = [[NSMutableArray alloc] init];
        [linesData addObject:[CCSComputerIndex computeRSIData:self.candleStickChart.stickData period:6]];
        [linesData addObject:[CCSComputerIndex computeRSIData:self.candleStickChart.stickData period:12]];
    
        self.lineIndexChart.linesData = linesData;
    
        [self.lineIndexChart setNeedsDisplay];

}


- (void)initADXChartData {
    
      self.lineIndexChart.linesData = [CCSComputerIndex computeADXData:self.candleStickChart.stickData];
      [self.lineIndexChart setNeedsDisplay];
}


- (void)CCSChartDisplayChangedFrom:(NSUInteger)from number:(NSUInteger)number type:(NSString *)type {
    
    self.macdChart.displayFrom = from;
    self.macdChart.displayNumber = number;
    [self.macdChart performSelector:@selector(setNeedsDisplay) withObject:nil];
    
    self.lineIndexChart.displayFrom = from;
    self.lineIndexChart.displayNumber = number;
}



/**
 *  根据昨收的比较
 *
 *  @param value 参数
 *
 *  @return 不同的颜色
 */
- (UIColor *)compareWithLastClose:(NSString *)value {
    if ([value floatValue] > [_lastclose floatValue]) {
        return GXRedColor;
    } else if ([value floatValue] < [_lastclose floatValue]) {
        return GXGreenColor;
    } else {
        return GXGrayColor;
    }
}


- (void)CCSChartBeTouchedOn:(CGPoint)point indexAt:(NSUInteger)index {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ccsChartTouch" object:@"k线"];

    
    self.macdChart.singleTouchPoint = point;
    self.macdChart.selectedStickIndex = index;
    [self.macdChart performSelector:@selector(setNeedsDisplay) withObject:nil];
    self.lineIndexChart.singleTouchPoint = point;
    [self.lineIndexChart performSelector:@selector(setNeedsDisplay) withObject:nil];
    
    
    //设置底部的macd竖线
    CGRect originFrame = self.macdLineView.frame;
    originFrame.origin.x = point.x;
    originFrame.size.height = self.macdChart.height - self.macdChart.axisMarginBottom;
    self.macdLineView.frame = originFrame;
    
    
    CCSCandleStickChartData *ohlc = [self.candleStickChart.stickData objectAtIndex:index];
    CCSCandleStickChartData *lastohlc;
    //第一根k线时，处理前日比
    if (index == 0) {
        lastohlc = [[CCSCandleStickChartData alloc] initWithOpen:0 high:0 low:0 close:ohlc.close - ohlc.change date:@""];
    } else {
        lastohlc = [self.candleStickChart.stickData objectAtIndex:index - 1];
    }
    
    
    
#warning x轴的日期
    self.candleStickChart.meterX = ohlc.date;
    //昨收
    _lastclose = [NSString stringWithFormat:@"%g",lastohlc.close];
    
    self.timeValue.text = ohlc.date;
    
    self.openValue.text = [NSString stringWithFormat:@"%g",ohlc.open];
    self.openValue.textColor = [self compareWithLastClose:self.openValue.text];
    
    self.highValue.text = [NSString stringWithFormat:@"%g",ohlc.high];
    self.highValue.textColor = [self compareWithLastClose:self.highValue.text];
    
    self.lowValue.text = [NSString stringWithFormat:@"%g",ohlc.low];
    self.lowValue.textColor = [self compareWithLastClose:self.lowValue.text];
    
    self.closeValue.text = [NSString stringWithFormat:@"%g",ohlc.close];
    self.closeValue.textColor = [self compareWithLastClose:self.closeValue.text];
    
    
    int indexCount = 0;
    
    if (indexTopType == MA) {
        
        if (self.candleStickChart.linesData && [self.candleStickChart.linesData count] > 0) {
        
            CCSTitledLine *ma5  = [self.candleStickChart.linesData objectAtIndex:0];
            CCSTitledLine *ma10 = [self.candleStickChart.linesData objectAtIndex:1];
            CCSTitledLine *ma20 = [self.candleStickChart.linesData objectAtIndex:2];

            
            NSArray *dataArray = @[ma5, ma10, ma20];            
            for (NSInteger i = 0; i < dataArray.count; i++) {
                
                UILabel *MAtilesLabel = [_indexTiltes objectAtIndex:i];
                MAtilesLabel.textColor = DetailWhiteColor;
                
                UILabel *MAValuesLabel = [_indexValues objectAtIndex:i];
    
                CCSTitledLine *item = dataArray[i];
                MAtilesLabel.text = item.title;
         
                
                if (((CCSLineData *) [item.data objectAtIndex:index]).value != 0) {
                    MAValuesLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [item.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                    MAValuesLabel.textColor = item.color;
                    
                    GXLog(@"%@", item.color);
                    
                } else {
                    MAValuesLabel.text = @"0";
                    MAValuesLabel.textColor = DetailWhiteColor;
                }
            }
            
            indexCount = (int)dataArray.count;
        }
        
    } else {
        
        CCSTitledLine *upper = [self.candleStickChart.linesData objectAtIndex:0];
        CCSTitledLine *lower = [self.candleStickChart.linesData objectAtIndex:1];
        CCSTitledLine *boll = [self.candleStickChart.linesData objectAtIndex:2];
        
        NSArray *dataArray = @[upper,lower,boll];
        
        for (NSInteger i = 0; i< dataArray.count; i++) {
            
            UILabel *BolltilesLabel = [_indexTiltes objectAtIndex:i];
            BolltilesLabel.textColor = DetailWhiteColor;
            UILabel *BollValuesLabel = [_indexValues objectAtIndex:i];
            CCSTitledLine *item = dataArray[i];
            BolltilesLabel.text = item.title;
            
            if (((CCSLineData *) [item.data objectAtIndex:index]).value != 0) {
                BollValuesLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [item.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                BollValuesLabel.textColor = item.color;
                
            } else {
                BollValuesLabel.text = @"0";
                BollValuesLabel.textColor = DetailWhiteColor;
            }
            
        }
        
        indexCount = (int)dataArray.count;
    }
    
    
    
    if (indexBottomType == MACD) {
        
        if (self.macdChart.stickData && [self.macdChart.stickData count] > 0 && index <= [self.macdChart.stickData count] - 1) {
            
            CCSMACDData *macdData = [self.macdChart.stickData objectAtIndex:index];
            NSArray *colorArray = @[self.macdChart.macdLineColor,self.macdChart.diffLineColor, self.macdChart.deaLineColor];
            NSArray *MacdTextArray = @[@"MACD(12,26,9)",@"DIFF(12,26,9)",@"DEA(12,26,9)"];
            
            
            NSMutableArray *MacdValueArray = [NSMutableArray array];
            [MacdValueArray addObject:[NSNumber numberWithFloat:macdData.macd]];
            [MacdValueArray addObject:[NSNumber numberWithFloat:macdData.diff]];
            [MacdValueArray addObject:[NSNumber numberWithFloat:macdData.dea]];
            
            UILabel *MacdTitleLable = nil;
            UILabel *MacdValueLable = nil;
            
            for (NSInteger i = 0; i < MacdValueArray.count; i++) {
                MacdTitleLable = [_indexTiltes objectAtIndex:indexCount + i];
                MacdTitleLable.textColor = DetailWhiteColor;
                MacdTitleLable.text = MacdTextArray[i];
                MacdValueLable = [_indexValues objectAtIndex:indexCount + i];
                
                CGFloat floatNumber = [[MacdValueArray objectAtIndex:i] floatValue];
                if (floatNumber != 0) {
                    
                    NSString *valueString = [NSString stringWithFormat:@"%.2f", (floatNumber / self.macdChart.axisCalc)];
                    MacdValueLable.text = valueString;
                    MacdValueLable.textColor = colorArray[i];
                } else {
                    MacdValueLable.textColor = DetailWhiteColor;
                    MacdValueLable.text = @"0";
                }
            }
            
           
        }

        indexCount += 3;
        
    } else if(indexBottomType == KDJ){

        //均线数据
        CCSTitledLine *lineK = [self.lineIndexChart.linesData objectAtIndex:0];
        CCSTitledLine *lineD = [self.lineIndexChart.linesData objectAtIndex:1];
        CCSTitledLine *lineJ = [self.lineIndexChart.linesData objectAtIndex:2];
        
        NSArray *dataArray = @[lineK, lineD, lineJ];
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
            
            UILabel *KdjTitleLabel = [_indexTiltes objectAtIndex:indexCount + i];
            KdjTitleLabel.textColor = DetailWhiteColor;
            
            UILabel *KdjValueLabel = [_indexValues objectAtIndex:indexCount + i];
            
            CCSTitledLine *item = dataArray[i];
            KdjTitleLabel.text = item.title;
           
            
            if (item && item.data && [item.data count] > 0 && index < [item.data count] - 1) {
                if (((CCSLineData *) [item.data objectAtIndex:index]).value != 0) {
                    KdjValueLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [item.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                    KdjValueLabel.textColor = item.color;
                    
                } else {
                    
                    KdjValueLabel.text = @"0";
                    KdjValueLabel.textColor = DetailWhiteColor;
                }
            }
        }
        
        indexCount += 3;

    } else if (indexBottomType == RSI) {
        
        CCSTitledLine *line6 = [self.lineIndexChart.linesData objectAtIndex:0];
        CCSTitledLine *line12 = [self.lineIndexChart.linesData objectAtIndex:1];
        
        NSArray *dataArray = @[line6, line12];
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
            UILabel *rsiTiteleLabel = [_indexTiltes objectAtIndex:indexCount + i];
            UILabel *rsiValueLabel = [_indexValues objectAtIndex:indexCount + i];
            CCSTitledLine *item = dataArray[i];
            rsiTiteleLabel.text = item.title;
            rsiTiteleLabel.textColor = DetailWhiteColor;
            
            if (item && item.data && [item.data count] > 0 && index <= [item.data count] - 1) {
                
                if (((CCSLineData *)[line12.data objectAtIndex:index]).value != 0) {
                    rsiValueLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [item.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                    rsiValueLabel.textColor = [UIColor orangeColor];
                } else {
                    
                    rsiValueLabel.text = @"0";
                    rsiValueLabel.textColor = DetailWhiteColor;
                }
                
            }
        }
        
        indexCount  += 2;

    } else if (indexBottomType == ADX) {
        
        CCSTitledLine *adxLine = [self.lineIndexChart.linesData objectAtIndex:0];
        UILabel *AdxTiteleLabel = [_indexTiltes objectAtIndex:indexCount];
        UILabel *AdxValueLabel = [_indexValues objectAtIndex:indexCount];
        
        if (adxLine && adxLine.data && [adxLine.data count] > 0 && index <= [adxLine.data count] - 1) {
            AdxTiteleLabel.text = adxLine.title;
            AdxTiteleLabel.textColor = DetailWhiteColor;
            
            if (((CCSLineData *) [adxLine.data objectAtIndex:index]).value != 0) {
                AdxValueLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [adxLine.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                AdxValueLabel.textColor = adxLine.color;
            } else {
                AdxValueLabel.text = @"0";
                AdxValueLabel.textColor = DetailWhiteColor;
            }
            
        }
        
        indexCount += 1;
        
    } else if (indexBottomType == ATR) {
        
        CCSTitledLine *atrLine = [self.lineIndexChart.linesData objectAtIndex:0];
        UILabel *ATRTiteleLabel = [_indexTiltes objectAtIndex:indexCount];
        UILabel *ATRValueLabel = [_indexValues objectAtIndex:indexCount];
        
        if (atrLine && atrLine.data && [atrLine.data count] > 0 && index <= [atrLine.data count] - 1) {
            ATRTiteleLabel.text = atrLine.title;
            ATRTiteleLabel.textColor = DetailWhiteColor;
            
            if (((CCSLineData *) [atrLine.data objectAtIndex:index]).value != 0) {
                ATRValueLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [atrLine.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                ATRValueLabel.textColor = atrLine.color;
            } else {
                ATRValueLabel.text = @"0";
                ATRValueLabel.textColor = DetailWhiteColor;
            }
        }
        
        indexCount += 1;

        
    } else if (indexBottomType == DMI) {
        
        CCSTitledLine *dmiLine = [self.lineIndexChart.linesData objectAtIndex:0];
        UILabel *DMITiteleLabel = [_indexTiltes objectAtIndex:indexCount];
        UILabel *DMIValueLabel = [_indexValues objectAtIndex:indexCount];
        
        if (dmiLine && dmiLine.data && [dmiLine.data count] > 0 && index <= [dmiLine.data count] - 1) {
            DMITiteleLabel.text = dmiLine.title;
            DMITiteleLabel.textColor = DetailWhiteColor;
            
            if (((CCSLineData *) [dmiLine.data objectAtIndex:index]).value != 0) {
                DMIValueLabel.text = [[[NSString stringWithFormat:@"%f", ((CCSLineData *) [dmiLine.data objectAtIndex:index]).value / self.candleStickChart.axisCalc] decimal:2] zeroIsBlank];
                DMIValueLabel.textColor = dmiLine.color;
            } else {
                DMIValueLabel.text = @"0";
                DMIValueLabel.textColor = nil;
                DMIValueLabel.textColor = DetailWhiteColor;
            }
            
        }
        
        indexCount += 1;
    }
    
    
    
    for (int i = 0; i < [_indexValues count]; i++) {
        if (i < indexCount) {
            ((UILabel*)_indexTiltes[i]).hidden = NO;
            ((UILabel*)_indexValues[i]).hidden = NO;
        } else {
            ((UILabel*)_indexValues[i]).hidden = YES;
            ((UILabel*)_indexTiltes[i]).hidden = YES;
        }
    }
    
    
    if ((index - self.candleStickChart.displayFrom) > (self.candleStickChart.displayNumber/2)) {
        self.deatailView.frame = CGRectMake(self.candleStickChart.axisMarginLeft, 0, 110, 15*(5+indexCount)+5);
    } else {
        self.deatailView.frame = CGRectMake(self.frame.size.width - 110, 0, 110, 15*(5+indexCount)+5);
    }
    
    
}

- (void)reloadFrame {
    
    [self.candleStickChart setNeedsDisplay];
    [self.macdChart setNeedsDisplay];
    [self.lineIndexChart setNeedsDisplay];
}



- (void) hideCross{

    self.candleStickChart.displayCrossYOnTouch = NO;
    self.candleStickChart.displayCrossXOnTouch = NO;
    self.macdChart.displayCrossXOnTouch = NO;
    self.lineIndexChart.displayCrossXOnTouch = NO;
    self.macdLineView.hidden = YES;
    self.deatailView.hidden = YES;
    [_candleStickChart setNeedsDisplay];
    [_macdChart setNeedsDisplay];

}



@end

