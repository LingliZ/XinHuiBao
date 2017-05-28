//
//  CCSTimeLineChart.m
//  PriceChart
//
//  Created by 王淼 on 16/5/24.
//  Copyright © 2016年 王淼. All rights reserved.
//

#import "CCSTimeLineChart.h"
#import "CCSStringUtils.h"


#define CCSTimeLinelatitudeFont (IS_IPHONE_6 ? 8:(IS_IPHONE_6P ? 8:7))
#define CCSTimeLinelongitudeFont (IS_IPHONE_6 ? 8:(IS_IPHONE_6P ? 8:7))


#define CCSTimeLineWithIndexAxisMarginLeft WidthScale_IOS6(40)
#define CCSTimeLineWithIndexAxisMarginRight WidthScale_IOS6(20)

@implementation CCSTimeLineChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.displayCrossXOnTouch = NO;
        self.displayCrossYOnTouch = NO;
        [self addTarget:self action:@selector(lineChartUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(lineChartDown:) forControlEvents:UIControlEventTouchDown];
        
        self.zoomBaseLine = CCSLineZoomBaseLineLeft;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.tag = 1234567890;
        self.maxValue = 150000;
        self.minValue = 10000;
        self.latitudeNum = 4;
        self.longitudeNum = 4;
        self.latitudeFont = GXFONT_Helvetica(CCSTimeLinelatitudeFont);
        self.longitudeFont = GXFONT_Helvetica(CCSTimeLinelongitudeFont);
        self.longitudeFontColor = GXBlackColor;
        self.longitudeFontSize = CCSTimeLinelongitudeFont;
        
        
        self.axisMarginRight = WidthScale_IOS6(32);
        self.axisMarginLeft = CCSTimeLineWithIndexAxisMarginLeft;
        self.axisYPosition = CCSGridChartYAxisPositionLR;
        
        //Y轴左右文字边距
        self.axisTextMarginRight = WidthScale_IOS6(5);
        self.axisTextMarginLeft = WidthScale_IOS6(5);
        
        //X轴下部分边距
        self.axisTextMarginBottom = HeightScale_IOS6(5);
        
        //昨日收盘价的字体大小
        self.lastCloseFontSize = CCSTimeLinelatitudeFont;
        
        
        self.lineWidth = 0;
        self.axisCalc = 1;
        self.userInteractionEnabled = YES;
        self.lineAlignType = CCSLineAlignTypeJustify;
        
        // 十字线
        self.crossLinesColor = [UIColor colorWithWhite:0.000 alpha:0.902];
        self.crossLinesFontColor = [UIColor whiteColor];
        
        
        // 经线
        self.longitudeColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.000];
        
        
        
        // 设置悬浮窗口
        [self initDeatailTitle:frame];
        
        // ?
        self.chartDelegate = self;
    }
    return self;
}



- (void)initDeatailTitle:(CGRect)frame{
    
    self.deatailView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x + 30, frame.origin.y, 100, 45)];
    self.deatailView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.702];
    self.deatailView.hidden = YES;
    
    //价格标签
    @weakify(self);
    self.priceTitle = [[UILabel alloc] init];
    [self.deatailView addSubview:self.priceTitle];
    self.priceTitle.font = [UIFont systemFontOfSize:10];
    self.priceTitle.text = @"价格：";
    self.priceTitle.textColor = GXWhiteColor;
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.deatailView.mas_centerY).multipliedBy(0.5);
        make.left.equalTo(self.deatailView.mas_left).offset(5);
    }];

    //价格数值
    self.priceValue = [[UILabel alloc] init];
    [self.deatailView addSubview:self.priceValue];
    self.priceValue.font = [UIFont systemFontOfSize:10];
    self.priceValue.textAlignment = NSTextAlignmentRight;
    self.priceValue.textColor = GXWhiteColor;
    [self.deatailView addSubview:self.priceValue];
    
    [self.priceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.trailing.equalTo(self.deatailView.mas_trailing).with.offset(-5);
        make.centerY.equalTo(self.deatailView.mas_centerY).multipliedBy(0.5);
    }];
    
    //时间标签
    self.timeTitle = [[UILabel alloc] init];
    [self.deatailView addSubview:self.timeTitle];
    self.timeTitle.font = [UIFont systemFontOfSize:10];
    self.timeTitle.text = @"时间：";
    self.timeTitle.textColor = GXWhiteColor;
    [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.deatailView.mas_centerY).multipliedBy(1.5);
        make.left.equalTo(self.deatailView.mas_left).offset(5);
    }];
    
    //时间值
    self.timeValue = [[UILabel alloc] init];
    [self.deatailView addSubview:self.timeValue];
    self.timeValue.font=[UIFont systemFontOfSize:10];
    self.timeValue.textAlignment = NSTextAlignmentRight;
    self.timeValue.textColor = GXWhiteColor;
    [self.timeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.deatailView.mas_centerY).multipliedBy(1.5);
        make.trailing.equalTo(self.deatailView.mas_trailing).with.offset(-5);
    }];

    // 添加view
    [self addSubview:self.deatailView];
    
}


- (void)lineChartDown:(UIView *)lineChartDown {
    pressTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(pressTimerAdvanced:) userInfo:nil repeats:NO];
}

- (void)pressTimerAdvanced:(NSTimer *)timer {
    
    if (self.isMoveFinger == NO) {
        isLongPress = YES;
        self.displayCrossYOnTouch = YES;
        self.displayCrossXOnTouch = YES;
        self.deatailView.hidden = NO;
        [self setNeedsDisplay];
    }
}

- (void)lineChartUp:(UIView *)sender {
    [pressTimer invalidate];
    if (isLongPress) {
        isLongPress=NO;
    }
    else
    {
        if (self.isMoveFinger==NO)
        {
            self.displayCrossYOnTouch = NO;
            self.displayCrossXOnTouch = NO;
            self.deatailView.hidden=YES;
            [self setNeedsDisplay];
        }
    }
    
}

- (void) hideCross{

    self.displayCrossYOnTouch = NO;
    self.displayCrossXOnTouch = NO;
    self.deatailView.hidden=YES;
    [self setNeedsDisplay];

}


// 设置数据
- (void)setTimeLineData:(CCSTimeLineData*)timeLineData{
   
    if (self.isMoveFinger) {
      return;
    }

    //获取数据
    GXLog(@"%@",timeLineData.duration);
    
    
    int hours = [[[[timeLineData.duration substringFromIndex:2] componentsSeparatedByString:@"H"] objectAtIndex:0] intValue];
    int minutes = 0;
    if ([[[timeLineData.duration substringFromIndex:2] componentsSeparatedByString:@"H"] count] == 2) {
        minutes=[[[[[timeLineData.duration substringFromIndex:2] componentsSeparatedByString:@"H"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"M" withString:@""] intValue];
    }

    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:((CCSTimeLineItemData *)[timeLineData.timeLineItemList objectAtIndex:[timeLineData.timeLineItemList count]-1]).time/1000];
    NSDate *firstDate= [NSDate dateWithTimeIntervalSince1970:[timeLineData.openTime doubleValue]/1000];
    
    //补全历史数据
    NSMutableArray *realTimeArray = [[NSMutableArray alloc] init];
    NSDate *time = firstDate;
    while ([lastDate timeIntervalSinceDate:time] >= 0) {
        CCSTimeLineItemData  *timeLineItemData = [[CCSTimeLineItemData alloc] init];
        timeLineItemData.time = [time timeIntervalSince1970]*1000;
        for (long i = 0; i < [timeLineData.timeLineItemList count] - 1;i++){
            CCSTimeLineItemData *timeLineItemData1 = ((CCSTimeLineItemData *)[timeLineData.timeLineItemList objectAtIndex:i]);
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeLineItemData1.time/1000];
            if ([confromTimesp timeIntervalSinceDate:time] >= 0) {
                timeLineItemData.current = timeLineItemData1.current;
                break;
            }
        }
        [realTimeArray addObject:timeLineItemData];
        time = [time dateByAddingTimeInterval:1*60];
        
    }


    
    //转换标准格式
    self.singlelinedatas = [[NSMutableArray alloc] init];
    NSMutableArray *singlelineCloseDatas = [[NSMutableArray alloc] init];
    NSMutableArray *averagelineData = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<[realTimeArray count];i++) {
        
        CCSLineData *data = [[CCSLineData alloc] init];
        CCSTimeLineItemData *timeLineItemData = (CCSTimeLineItemData*)[realTimeArray objectAtIndex:i];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeLineItemData.time/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"HH:mm"];
        data.date = [formatter stringFromDate:confromTimesp];
        
     
        
        data.value = timeLineItemData.current;
      
        [self.singlelinedatas addObject:data];
        CCSLineData *closeData = [[CCSLineData alloc] init];
        
        closeData.value = timeLineData.lastclose;
        
        [singlelineCloseDatas addObject:closeData];
        CCSLineData *averageData = [[CCSLineData alloc] init];
        
        averageData.value = timeLineItemData.avgPrice;
        [averagelineData addObject:averageData];
        
    }
    
    
    
    

    //补全后置
    NSDate *endDate = [firstDate dateByAddingTimeInterval:hours*60*60+minutes*60];
    
    
    int i = 0;
    time = lastDate;
    while ([endDate timeIntervalSinceDate:time]>=60) {
        CCSLineData *data = [[CCSLineData alloc] init];
        NSDate *confromTimesp = [lastDate dateByAddingTimeInterval:(i+1)*1*60];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"HH:mm"];
        data.date = [formatter stringFromDate:confromTimesp];
        data.value = 0;
    
        [self.singlelinedatas addObject:data];
        [averagelineData addObject:data];
        CCSLineData *closeData = [[CCSLineData alloc] init];
        closeData.value = timeLineData.lastclose;
        [singlelineCloseDatas addObject:closeData];
        time = [time dateByAddingTimeInterval:1*60];
        i += 1;
    }
    
    
    
    
    
    CCSTitledLine *singleline = [[CCSTitledLine alloc] init];
    singleline.data = self.singlelinedatas;
    singleline.color = [UIColor  colorWithRed:52.0/255.0 green:120.0/255.0 blue:206.0/255.0 alpha:1.0];
    singleline.title = @"chartLine";
    
    CCSTitledLine *singleCloseline = [[CCSTitledLine alloc] init];
    singleCloseline.data = singlelineCloseDatas;
    singleCloseline.color = GXLineColor;
    singleCloseline.title = @"closeLine";
    
    
    CCSTitledLine *singleAverageline = [[CCSTitledLine alloc] init];
    singleAverageline.data = averagelineData;
    singleAverageline.color = [UIColor colorWithRed:.95 green:.57 blue:0 alpha:1];
    singleAverageline.title = @"averageLine";
    
    NSMutableArray *lineData=[[NSMutableArray alloc] init];
    [lineData addObject:singleline];
    [lineData addObject:singleCloseline];
    [lineData addObject:singleAverageline];
    
    self.linesData = lineData;
    self.closeValue=timeLineData.lastclose;
    self.crossLinesColor = [UIColor colorWithWhite:0.000 alpha:0.902];
    self.displayNumber = [self.singlelinedatas count];
    self.displayFrom = 0;
    self.borderColor = GXLineColor;
    [self setNeedsDisplay];

    
}



// 设置悬浮视图 时间-价格图
- (void)CCSChartBeTouchedOn:(CGPoint)point indexAt:(NSUInteger)index {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ccsChartTouch" object:@"分时线"];
    
    
    NSInteger i = self.selectedIndex;
    
    CCSLineData *ohlc = [self.singlelinedatas objectAtIndex:i];
    
    if (i < [self.singlelinedatas count]/2) {
        
        @weakify(self);
        [self.deatailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.mas_top);
            make.trailing.equalTo(self.mas_trailing).offset(- self.axisMarginRight);
            make.width.equalTo(@(100));
            make.height.equalTo(@45);
        }];
        
        [self.deatailView setNeedsDisplay];
        
    }else{
        
        @weakify(self);
        [self.deatailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.mas_top);
            make.leading.equalTo(self.mas_leading).offset(self.axisMarginLeft);
            make.width.equalTo(@100);
            make.height.equalTo(@45);
        }];
         [self.deatailView setNeedsDisplay];
        
    }
    
    self.priceValue.text = [NSString stringWithFormat:@"%.2f",ohlc.value];
    self.timeValue.text = [ohlc.date dateWithFormat:@"HH:mm" target:@"HH:mm"];
    
#warning x轴时间数值
    self.meterX = ohlc.date;
}




@end
