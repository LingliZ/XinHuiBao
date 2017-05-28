//
//  PriceDetailTabbarView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceDetailTabbarView.h"
#import "XHBDealConst.h"


@implementation PriceDetailTabbarView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        float Btn_width=GXScreenWidth/3.0;
        
        //做空
        UIButton *btn_makeSell=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Btn_width, priceDetailTabbar_height)];
        btn_makeSell.backgroundColor=GXGreen_priceBackgColor;
        btn_makeSell.titleLabel.font=GXFONT_PingFangSC_Regular(16);
        [btn_makeSell setTitle:@"做空"  forState:UIControlStateNormal];
        [btn_makeSell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn_makeSell setImage:[UIImage imageNamed:@"PriceDetailbigArrow"] forState:UIControlStateNormal];
//        [btn_makeSell.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
//        [btn_makeSell setImagePosition:1 spacing:0];
        [btn_makeSell addTarget:self action:@selector(btn_sell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_makeSell];
        
        
        //做多
        UIButton *btn_makeBuy=[[UIButton alloc]initWithFrame:CGRectMake(Btn_width, 0, Btn_width, priceDetailTabbar_height)];
        btn_makeBuy.backgroundColor=GXRed_priceBackgColor;
        btn_makeBuy.titleLabel.font=GXFONT_PingFangSC_Regular(16);
        [btn_makeBuy setTitle:@"做多"  forState:UIControlStateNormal];
        [btn_makeBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn_makeBuy setImage:[UIImage imageNamed:@"PriceDetailbigArrow"] forState:UIControlStateNormal];
//        [btn_makeBuy setImagePosition:1 spacing:0];
        [btn_makeBuy addTarget:self action:@selector(btn_buy) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_makeBuy];
        
        
        //持仓按钮
        UIButton *btn_openorder=[[UIButton alloc]initWithFrame:CGRectMake(Btn_width*2, 0, Btn_width, priceDetailTabbar_height)];
        btn_openorder.backgroundColor=[UIColor whiteColor];
        btn_openorder.titleLabel.font=GXFONT_PingFangSC_Regular(16);
        [btn_openorder setTitle:@"持仓"  forState:UIControlStateNormal];
        [btn_openorder setTitleColor:GXBlack_priceDetailBarTextColor forState:UIControlStateNormal];
        [btn_openorder addTarget:self action:@selector(btnClick_openorder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_openorder];
        
    }
    return self;
}

-(void)btn_sell
{
    [delegate PriceDetailTabbarBtnClick:0];
}

-(void)btn_buy
{
    [delegate PriceDetailTabbarBtnClick:1];
}

-(void)btnClick_openorder
{
    [delegate PriceDetailTabbarBtnClick:2];
}

@end
