//
//  PriceDetailHeaderView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceDetailHeaderView.h"
#import "XHBDealConst.h"
#import "PriceMarketModel.h"

#define tag_label_detail_ksgdzf_title 201611091335
#define tag_label_detail_ksgdzf_value 201611091400
#define tag_label_detail_ksgdzf_line 201611091500


@implementation PriceDetailHeaderView
{
    //做空背景
    UIView *sellBackg;
    //做多背景
    UIView *buyBackg;
    //点差
    UILabel *lb_spread;
    //做空报价
    UILabel *lb_sell;
    //做多报价
    UILabel *lb_buy;
    //做空文本
    UILabel *lb_sellTit;
    //做多文本
    UILabel *lb_buyTit;
    //做空箭头
    UIImageView *priceListArrow_sell_img;
    //做多箭头
    UIImageView *priceListArrow_buy_img;
    //最新价
    UILabel *lb_last;
    //时间
    UILabel *lb_time;
    
}
@synthesize delegate;
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)setPriceDetailView:(PriceMarketModel*)marketModel
{
    self.backgroundColor=[UIColor whiteColor];//marketModel.lastColor;
    
    //做空的背景
    if(!sellBackg)
    {
        sellBackg=[[UIView alloc]initWithFrame:CGRectMake(15, 15, WidthScale_IOS6(priceDetail_sellOrbuyBackground_width), priceDetail_sellOrbuyBackground_height)];
        sellBackg.layer.masksToBounds=YES;
        sellBackg.layer.cornerRadius=2;
        sellBackg.backgroundColor=GXGreen_priceBackgColor;
//        sellBackg.layer.borderColor=GXWhite_priceDetailBackg_boardColor.CGColor;
//        sellBackg.layer.borderWidth=1;
        [self addSubview:sellBackg];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSellClick)];
        [sellBackg addGestureRecognizer:tap];
        sellBackg.userInteractionEnabled=YES;
    }
    
    
    //做多的背景
    if(!buyBackg)
    {
        buyBackg=[[UIView alloc]initWithFrame:CGRectMake(sellBackg.frame.origin.x+sellBackg.frame.size.width+priceDetailSellOrBuyBg_space, sellBackg.frame.origin.y, WidthScale_IOS6(priceDetail_sellOrbuyBackground_width), priceDetail_sellOrbuyBackground_height)];
        buyBackg.layer.masksToBounds=YES;
        buyBackg.layer.cornerRadius=2;
        buyBackg.backgroundColor=GXRed_priceBackgColor;
//        buyBackg.layer.borderColor=GXWhite_priceDetailBackg_boardColor.CGColor;
//        buyBackg.layer.borderWidth=1;
        [self addSubview:buyBackg];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBuyClick)];
        [buyBackg addGestureRecognizer:tap];
        buyBackg.userInteractionEnabled=YES;
    }
    
    
    //点差
    if(!lb_spread)
    {
        lb_spread=[[UILabel alloc]initWithFrame:CGRectMake(sellBackg.frame.origin.x+sellBackg.frame.size.width-(priceDetail_spread_width-priceDetailSellOrBuyBg_space)/2.0, sellBackg.frame.origin.y+(priceDetail_sellOrbuyBackground_height-priceDetail_spread_height)/2.0, priceDetail_spread_width, priceDetail_spread_height)];
        lb_spread.backgroundColor=[UIColor whiteColor];
        lb_spread.layer.masksToBounds=YES;
        lb_spread.layer.cornerRadius=1;
        lb_spread.textAlignment=NSTextAlignmentCenter;
        lb_spread.font=GXFONT_PingFangSC_Regular(12);
        [self addSubview:lb_spread];
    }
    lb_spread.text=marketModel.spread;
    lb_spread.textColor = GXRGBColor(51, 51, 51);
    
    
    //做空文本报价
    if(!lb_sell)
    {
        lb_sell=[[UILabel alloc]init];
        lb_sell.textColor=[UIColor whiteColor];
        [self addSubview:lb_sell];
    }
    [lb_sell setAttributedText:marketModel.buy_headLarg];
    marketModel.buy_headLarg=nil;
    [lb_sell sizeToFit];
    lb_sell.frame=CGRectMake(sellBackg.frame.origin.x+(sellBackg.frame.size.width-0-(priceListArrow_width+lb_sell.frame.size.width))/2.0, sellBackg.frame.origin.y+sellBackg.frame.size.height/2.0-3, lb_sell.frame.size.width, sellBackg.frame.size.height/2.0);//这里的5是文本和箭头整体向左的偏移量,-3是向上的偏移量
    
    
    //做空箭头
    if(!priceListArrow_sell_img)
    {
        priceListArrow_sell_img=[[UIImageView alloc]init];
        [self addSubview:priceListArrow_sell_img];
    }
    if(CGColorEqualToColor(self.backgroundColor.CGColor, GXGreen_priceBackgColor.CGColor))
    {
        priceListArrow_sell_img.image=[UIImage imageNamed:@"priceListArrow2"];
    }else
    {
        priceListArrow_sell_img.image=[UIImage imageNamed:@"priceListArrow"];
    }
    priceListArrow_sell_img.frame=CGRectMake(lb_sell.frame.origin.x+lb_sell.frame.size.width, sellBackg.frame.origin.y+sellBackg.frame.size.height/2.0+(sellBackg.frame.size.height/2.0-priceListArrow_height)/2.0-3, priceListArrow_width, priceListArrow_height);
    
    
    
    //做多文本报价
    if(!lb_buy)
    {
        lb_buy=[[UILabel alloc]init];
        lb_buy.textColor=[UIColor whiteColor];
        [self addSubview:lb_buy];
    }
    [lb_buy setAttributedText:marketModel.sell_headLarg];
    marketModel.sell_headLarg=nil;
    [lb_buy sizeToFit];
    lb_buy.frame=CGRectMake(buyBackg.frame.origin.x+(buyBackg.frame.size.width+5-(priceListArrow_width+lb_buy.frame.size.width))/2.0, buyBackg.frame.origin.y+buyBackg.frame.size.height/2.0-3, lb_buy.frame.size.width, buyBackg.frame.size.height/2.0);//这里的5是文本和箭头整体向右的偏移量
    
    
    //做多箭头
    if(!priceListArrow_buy_img)
    {
        priceListArrow_buy_img=[[UIImageView alloc]init];
        [self addSubview:priceListArrow_buy_img];
    }
    if(CGColorEqualToColor(self.backgroundColor.CGColor, GXGreen_priceBackgColor.CGColor))
    {
        priceListArrow_buy_img.image=[UIImage imageNamed:@"priceListArrow2"];
    }else
    {
        priceListArrow_buy_img.image=[UIImage imageNamed:@"priceListArrow"];
    }
    priceListArrow_buy_img.frame=CGRectMake(lb_buy.frame.origin.x+lb_buy.frame.size.width, buyBackg.frame.origin.y+buyBackg.frame.size.height/2.0+(buyBackg.frame.size.height/2.0-priceListArrow_height)/2.0-3, priceListArrow_width, priceListArrow_height);
    
    
    
    //做空标题
    if(!lb_sellTit)
    {
        lb_sellTit=[[UILabel alloc]initWithFrame:CGRectMake(sellBackg.frame.origin.x, sellBackg.frame.origin.y+3, sellBackg.frame.size.width, sellBackg.frame.size.height/2.0)];//y+3是向下的偏移量
        
        lb_sellTit.textAlignment=NSTextAlignmentCenter;
        lb_sellTit.font=GXFONT_PingFangSC_Regular(12);
        lb_sellTit.text=@"做空";
        lb_sellTit.textColor=[UIColor whiteColor];
        [self addSubview:lb_sellTit];
    }
    
    
    //做多标题
    if(!lb_buyTit)
    {
        lb_buyTit=[[UILabel alloc]initWithFrame:CGRectMake(buyBackg.frame.origin.x, buyBackg.frame.origin.y+3, buyBackg.frame.size.width, buyBackg.frame.size.height/2.0)];
        
        lb_buyTit.textAlignment=NSTextAlignmentCenter;
        lb_buyTit.font=GXFONT_PingFangSC_Regular(12);
        lb_buyTit.text=@"做多";
        lb_buyTit.textColor=[UIColor whiteColor];
        [self addSubview:lb_buyTit];
    }
    
    
    //最新价
    if(!lb_last)
    {
        lb_last=[[UILabel alloc]initWithFrame:CGRectMake(buyBackg.frame.origin.x+buyBackg.frame.size.width, lb_buyTit.frame.origin.y, GXScreenWidth-buyBackg.frame.origin.x-buyBackg.frame.size.width,lb_buyTit.frame.size.height )];
        lb_last.textAlignment=NSTextAlignmentCenter;
        lb_last.font=GXFONT_PingFangSC_Regular(16);
        [self addSubview:lb_last];
    }
    lb_last.text=marketModel.last;
    lb_last.textColor=marketModel.lastColor;
    
    
    //时间
    if(!lb_time)
    {
        lb_time=[[UILabel alloc]initWithFrame:CGRectMake(lb_last.frame.origin.x, lb_buy.frame.origin.y+5, lb_last.frame.size.width, lb_buy.frame.size.height)];
        lb_time.textAlignment=NSTextAlignmentRight;
        lb_time.font=GXFONT_PingFangSC_Regular(12);
        lb_time.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lb_time];
    }
    lb_time.text=[NSString stringWithFormat:@"%@  %@",marketModel.increase,marketModel.increasePercentage];
    lb_time.textColor=marketModel.lastColor;
    
    
    //开收高低涨幅
    NSArray *ar=@[@"今开",@"昨收",@"最高",@"最低"];
    NSArray *ar2=@[marketModel.open,marketModel.lastclose,marketModel.high,marketModel.low];
    
    float w=GXScreenWidth/4.0;
    
    for (int i=0;i<[ar count] ; i++) {
        
        //标题
        UILabel *la=[self viewWithTag:i+tag_label_detail_ksgdzf_title];
        if(!la)
        {
            la=[[UILabel alloc]init];
            la.tag=tag_label_detail_ksgdzf_title+i;
            la.font=GXFONT_PingFangSC_Regular(12);
            la.textColor=GXRGBColor(165, 165, 165);
            la.text=ar[i];
            la.textAlignment=NSTextAlignmentCenter;
            [la sizeToFit];
            [self addSubview:la];
            
            la.frame=CGRectMake(i*w, sellBackg.frame.origin.y+sellBackg.frame.size.height+15, w, 20);
        }
        
        //报价
        UILabel *la2=[self viewWithTag:i+tag_label_detail_ksgdzf_value];
        if(!la2)
        {
            la2=[[UILabel alloc]initWithFrame:CGRectMake(la.frame.origin.x, la.frame.origin.y+20, w, 20)];
            la2.tag=tag_label_detail_ksgdzf_value+i;
            la2.font=GXFONT_PingFangSC_Regular(14);
            la2.textColor=GXRGBColor(51, 51, 51);
            la2.textAlignment=NSTextAlignmentCenter;
            [self addSubview:la2];
        }
        la2.text=ar2[i];
        
        
        //竖线
        if(i<3)
        {
            UIImageView *lineimg=[self viewWithTag:tag_label_detail_ksgdzf_line+i];
            if(!lineimg)
            {
                lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(la2.frame.origin.x+la2.frame.size.width, la.frame.origin.y, 1, 34)];
                lineimg.tag=tag_label_detail_ksgdzf_line+i;
                lineimg.backgroundColor=GXRGBColor(242, 243, 243);
                [self addSubview:lineimg];
            }
        }
        
    }
    
}


-(void)tapSellClick
{
    [delegate priceDetailHeaderDelegate_sellClick];
}


-(void)tapBuyClick
{
    [delegate priceDetailHeaderDelegate_buyClick];
}
















@end
