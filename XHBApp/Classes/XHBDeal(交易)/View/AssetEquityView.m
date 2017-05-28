//
//  AssetEquityView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AssetEquityView.h"
#import <QuartzCore/QuartzCore.h>

#define arcRadius 80
#define arcWidth 25
#define arcNearTop 15
#define arcX self.frame.size.width/2.0
#define arcY (arcNearTop+arcWidth/2.0+arcRadius)

#define DEG2RAD(angle) angle*M_PI/180.0

#define arcSpeace 0.5//空隙

@implementation AssetEquityView
{
    UILabel *lb_date;
    UILabel *lb_equity_tit;
    UILabel *lb_equity;
    
    UILabel *lb_creditPercent;//信用额占百分比
    UILabel *lb_userMarginPercent;//已用预付款占百分比
    UILabel *lb_freeMarginPercent;//可用预付款占百分比
    
    NSTimer *timer;
    
    float pcc;//已用预付款占净值的比例

    float useMarginF;

}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    float cc=[self.usrModel.margin floatValue]+[self.usrModel.marginFree floatValue]+[self.usrModel.credit floatValue];
    
    if(cc==0)
    {
        //无净值
        CGContextSetStrokeColorWithColor(context,GXGrayColor.CGColor);
        CGContextSetLineWidth(context, arcWidth);
        CGContextAddArc(context, arcX, arcY, arcRadius, 1.0/2.0*M_PI,1.0/2.0*M_PI+  2*M_PI , 0);
        CGContextDrawPath(context, kCGPathStroke);
        
    }else
    {
        
        float creditPercentageOfEquity=[self.usrModel.credit floatValue]/cc;
        float marginPercentageOfEquity=[self.usrModel.margin floatValue]/cc;
        float freeMarginPercentageOfEquity=[self.usrModel.marginFree floatValue]/cc;
        
        if(marginPercentageOfEquity>=1)
        {
            marginPercentageOfEquity=1;
            freeMarginPercentageOfEquity=0;
            creditPercentageOfEquity=0;
        }
        
        
        int creditInt=creditPercentageOfEquity*100;
        int marginInt=marginPercentageOfEquity*100;
        int freeMarginInt=100-creditInt-marginInt;
        
        

        CGPoint center = CGPointMake( arcX,arcY);
        CGFloat radius =arcRadius;
        
        
        //初始位置弧度
        float arc_position=1.0/2.0*M_PI;
        
        
        //信用
        if(creditPercentageOfEquity>0)
        {
            CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:87.0f/255.0f green:160.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor);
            CGContextSetLineWidth(context, arcWidth);
            CGContextAddArc(context, arcX, arcY, arcRadius,arc_position + DEG2RAD(arcSpeace) , arc_position +  2*M_PI* creditPercentageOfEquity - 2*DEG2RAD(arcSpeace), 0);
            CGContextDrawPath(context, kCGPathStroke);
            
            //计算百分比位置与赋值
            float arcPositionf=arc_position+  M_PI * creditPercentageOfEquity;
            CGPoint lbCenterPoint = CGPointMake( center.x + radius * cosf(arcPositionf), center.y + radius * sinf(arcPositionf) );
            lb_creditPercent.text=[NSString stringWithFormat:@"%d%%",creditInt];
            [lb_creditPercent sizeToFit];
            lb_creditPercent.center=lbCenterPoint;
            
            if(creditPercentageOfEquity<0.05)
            {
                lb_creditPercent.hidden=YES;
            }else
                lb_creditPercent.hidden=NO;
            
            
            arc_position=arc_position +  2*M_PI* creditPercentageOfEquity;
        }
        
        
        if(marginPercentageOfEquity>0)
        {
            //预付款
            CGContextSetStrokeColorWithColor(context,GXRed_priceBackgColor.CGColor);
            CGContextSetLineWidth(context, arcWidth);
            CGContextAddArc(context, arcX, arcY, arcRadius,arc_position + DEG2RAD(arcSpeace) , arc_position +  2*M_PI * marginPercentageOfEquity- 2*DEG2RAD(arcSpeace), 0);
            CGContextDrawPath(context, kCGPathStroke);
            
            //计算百分比位置与赋值
            float arcPositionf=arc_position+  M_PI * marginPercentageOfEquity;
            CGPoint lbCenterPoint = CGPointMake( center.x + radius * cosf(arcPositionf), center.y + radius * sinf(arcPositionf) );
            lb_userMarginPercent.text=[NSString stringWithFormat:@"%d%%",marginInt];
            [lb_userMarginPercent sizeToFit];
            lb_userMarginPercent.center=lbCenterPoint;
            
            if(marginPercentageOfEquity<0.05)
            {
                lb_userMarginPercent.hidden=YES;
            }else
                lb_userMarginPercent.hidden=NO;
            
            arc_position=arc_position+ 2*M_PI * marginPercentageOfEquity;
        }
        
        
        
        if(freeMarginPercentageOfEquity>0)
        {
            //可用预付款
            CGContextSetStrokeColorWithColor(context,GXGreen_priceBackgColor.CGColor);
            CGContextSetLineWidth(context, arcWidth);
            CGContextAddArc(context, arcX, arcY, arcRadius, arc_position + DEG2RAD(arcSpeace) , arc_position +  2*M_PI * freeMarginPercentageOfEquity - 2*DEG2RAD(arcSpeace) , 0);
            CGContextDrawPath(context, kCGPathStroke);
            
            //计算百分比位置与赋值
            float arcPositionf=arc_position+  M_PI * freeMarginPercentageOfEquity;
            CGPoint lbCenterPoint = CGPointMake( center.x + radius * cosf(arcPositionf), center.y + radius * sinf(arcPositionf) );
            lb_freeMarginPercent.text=[NSString stringWithFormat:@"%d%%",freeMarginInt];
            [lb_freeMarginPercent sizeToFit];
            lb_freeMarginPercent.center=lbCenterPoint;
            
            if(freeMarginPercentageOfEquity<0.05)
            {
                lb_freeMarginPercent.hidden=YES;
            }else
                lb_freeMarginPercent.hidden=NO;
        }
        
       
        
    }
    
    
    lb_date.text=[GXInstance getnNetworkDate:0];
    lb_equity_tit.text=@"净值";
    if(cc==0)
    {
        self.usrModel=[[XHBTraderUserMaginModel alloc]init];
        lb_equity.attributedText=self.usrModel.userEquity_att_smallFont;
    }else
    {
        lb_equity.attributedText=self.usrModel.userEquity_att_smallFont;
    }
    
    
    
    
    float y=arcY+arcWidth/2.0+arcRadius+10;
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, GXGrayLineColor.CGColor);
    CGContextSetLineWidth(context,1);
    CGContextMoveToPoint(context, 0, y );
    CGContextAddLineToPoint(context, self.frame.size.width,y);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, GXRed_priceBackgColor.CGColor);
    CGContextSetLineWidth(context,3);
    CGContextMoveToPoint(context, 16, y+15 );
    CGContextAddLineToPoint(context, 16, y+15+35);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, GXGreen_priceBackgColor.CGColor);
    CGContextSetLineWidth(context,3);
    CGContextMoveToPoint(context, self.frame.size.width/3.0+16, y+15 );
    CGContextAddLineToPoint(context, self.frame.size.width/3.0+16, y+15+35);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:87.0f/255.0f green:160.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetLineWidth(context,3);
    CGContextMoveToPoint(context, self.frame.size.width*2/3.0+16, y+15 );
    CGContextAddLineToPoint(context, self.frame.size.width*2/3.0+16, y+15+35);
    CGContextStrokePath(context);

    
    [@"已用预付款（$）" drawAtPoint:CGPointMake( 16+10, y+12) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(12),NSForegroundColorAttributeName:GXGray_priceDetailTrade_TextColor}];
    [self.usrModel.margin drawAtPoint:CGPointMake( 16+10, y+12+20) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(16),NSForegroundColorAttributeName:GXBlack_priceNameColor}];
    
    
    [@"可用预付款（$）" drawAtPoint:CGPointMake( self.frame.size.width/3.0+16+10, y+12) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(12),NSForegroundColorAttributeName:GXGray_priceDetailTrade_TextColor}];
    [self.usrModel.marginFree drawAtPoint:CGPointMake( self.frame.size.width/3.0+16+10, y+12+20) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(16),NSForegroundColorAttributeName:GXBlack_priceNameColor}];
    
    [@"信用额（$）" drawAtPoint:CGPointMake( self.frame.size.width*2/3.0+16+10, y+12) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(12),NSForegroundColorAttributeName:GXGray_priceDetailTrade_TextColor}];
    [self.usrModel.credit drawAtPoint:CGPointMake( self.frame.size.width*2/3.0+16+10, y+12+20) withAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(16),NSForegroundColorAttributeName:GXBlack_priceNameColor}];
}


- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, GXScreenWidth, 270)]) {
        self.backgroundColor=[UIColor whiteColor];
        
        lb_date=[[UILabel alloc]initWithFrame:CGRectMake(0,arcNearTop+arcWidth,100,20)];
        lb_date.textAlignment=NSTextAlignmentCenter;
        lb_date.textColor=GXGray_priceDetailTrade_TextColor;
        lb_date.font=GXFONT_PingFangSC_Regular(11);
        [self addSubview:lb_date];
        lb_date.center=CGPointMake(arcX, lb_date.frame.origin.y+lb_date.frame.size.height);
        
        lb_equity_tit=[[UILabel alloc]initWithFrame:CGRectMake(0,arcY-20,100,20)];
        lb_equity_tit.textAlignment=NSTextAlignmentCenter;
        lb_equity_tit.textColor=GXGray_PositionTrade_TextColor;
        lb_equity_tit.font=GXFONT_PingFangSC_Regular(14);
        [self addSubview:lb_equity_tit];
        lb_equity_tit.center=CGPointMake(arcX, lb_equity_tit.frame.origin.y+lb_equity_tit.frame.size.height/2.0);

        lb_equity=[[UILabel alloc]initWithFrame:CGRectMake(0,arcY,120,20)];
        lb_equity.textAlignment=NSTextAlignmentCenter;
        lb_equity.textColor=GXBlack_priceNameColor;
        lb_equity.font=GXFONT_PingFangSC_Medium(14);
        [self addSubview:lb_equity];
        lb_equity.center=CGPointMake(arcX, lb_equity.frame.origin.y+lb_equity.frame.size.height/2.0);
        
        
        lb_userMarginPercent=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 16)];
        lb_userMarginPercent.textAlignment=NSTextAlignmentCenter;
        lb_userMarginPercent.textColor=[UIColor whiteColor];
        lb_userMarginPercent.font=GXFONT_PingFangSC_Regular(11);
        [self addSubview:lb_userMarginPercent];
        
        
        lb_freeMarginPercent=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 16)];
        lb_freeMarginPercent.textAlignment=NSTextAlignmentCenter;
        lb_freeMarginPercent.textColor=[UIColor whiteColor];
        lb_freeMarginPercent.font=GXFONT_PingFangSC_Regular(11);
        [self addSubview:lb_freeMarginPercent];
        
        
        lb_creditPercent=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 16)];
        lb_creditPercent.textAlignment=NSTextAlignmentCenter;
        lb_creditPercent.textColor=[UIColor whiteColor];
        lb_creditPercent.font=GXFONT_PingFangSC_Regular(11);
        [self addSubview:lb_creditPercent];
        
    }
    return self;
}

-(void)setUserMargin:(XHBTraderUserMaginModel *)model
{
    self.usrModel=model;
  
//    pcc=0;
//    
    [self setNeedsDisplay];
//
//    [self timerInv];
//    
//    float cc=[self.usrModel.Margin floatValue]+[self.usrModel.FreeMargin floatValue]+[self.usrModel.Credit floatValue];
//    
//    if(cc!=0)
//    {
//        useMarginF=[self.usrModel.Margin floatValue]/cc;
//        
//        [self setpccValue];
//        
//        float count=0.2f/(useMarginF/0.01);
//        timer = [NSTimer scheduledTimerWithTimeInterval:count target:self selector:@selector(pcc_increase) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    }
}

-(void)cancelTimer
{
    [self timerInv];
}

-(void)timerInv
{
    if(timer)
    {
        [timer invalidate];
        timer =nil;
    }
}

-(void)pcc_increase
{
    if(pcc>=useMarginF)
    {
        [self timerInv];
     
        pcc=useMarginF;
        
    }else
    {
        pcc+=0.01;
    }
    
    [self setNeedsDisplay];
}

-(void)setpccValue
{
    if(useMarginF<0.01 && useMarginF>0)
    {
        useMarginF=0.01;
    }else if (useMarginF>0.99 && useMarginF<1)
    {
        useMarginF=0.99;
    }
    else if (useMarginF>=1)
    {
        useMarginF=1;
    }else
    {
        useMarginF=0;
    }
}

@end
