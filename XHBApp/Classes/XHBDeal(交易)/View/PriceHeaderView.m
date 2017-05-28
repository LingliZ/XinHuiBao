//
//  PriceHeaderView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceHeaderView.h"
#import "XHBDealConst.h"

@implementation PriceHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, GXScreenWidth, priceList_headview_height)]) {
        
        //背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *Name_lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WidthScale_IOS6(priceList_name_width), priceList_headview_height)];
        Name_lb.text = @"交易品种名称";
        Name_lb.textColor = GXGray_priceTitleColor;
        Name_lb.font = GXFONT_PingFangSC_Regular(14);
        [self addSubview:Name_lb];
       
        
        
        UILabel *Sell_lb = [[UILabel alloc] initWithFrame:CGRectMake(Name_lb.frame.origin.x+Name_lb.frame.size.width, 0, WidthScale_IOS6(priceList_sellOrbuyBackground_width), priceList_headview_height)];
        Sell_lb.text = @"做空";
        Sell_lb.textAlignment = NSTextAlignmentCenter;
        Sell_lb.textColor = GXGray_priceTitleColor;
        Sell_lb.font = GXFONT_PingFangSC_Regular(14);
        [self addSubview:Sell_lb];
       
        
        UILabel *Buy_lb = [[UILabel alloc] initWithFrame:CGRectMake(Sell_lb.frame.origin.x+Sell_lb.frame.size.width+priceListSellOrBuyBg_space, 0, WidthScale_IOS6(priceList_sellOrbuyBackground_width), priceList_headview_height)];
        Buy_lb.text = @"做多";
        Buy_lb.textAlignment = NSTextAlignmentCenter;
        Buy_lb.textColor = GXGray_priceTitleColor;
        Buy_lb.font = GXFONT_PingFangSC_Regular(14);
        [self addSubview:Buy_lb];
        
        
        UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, priceList_headview_height-1, GXScreenWidth, 1)];
        lineimg.backgroundColor=GXGrayLineColor;
        [self addSubview:lineimg];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
