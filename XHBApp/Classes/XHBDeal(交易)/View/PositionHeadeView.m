//
//  PositionHeadeView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PositionHeadeView.h"
//#import "PriceUserTradeMarginModel.h"
#import "XHBTraderUserMaginModel.h"
#import "XHBDealConst.h"


@implementation PositionHeadeView
{
    UILabel *lb_tit_worth;//净值标题
    UILabel *lb_worth;//净值
    UILabel *lb_tit_floatProfit;//浮动盈亏标题
    UILabel *lb_floatProfit;//浮动盈亏
    UIImageView *lineImg;//分割线
    UILabel *lb_tit_freeMargin;//可用预付款标题
    UILabel *lb_freeMargin;//可用预付款
    
    UIView *positionTableviewTitView;//包含预付款比例提示语的叹号，预付款比例提示语，入金按钮,总成本
    UILabel *lb_Risk;//预付款比例
    
    UIButton *btn_spreadQuestion;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate;
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, GXScreenWidth, positionHeadView_height)]) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        //cell箭头图片
        UIImageView *cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, 55, 16, 16)];
        cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
        [self addSubview:cellindimg];
    }
    return self;
}

-(void)setUserTradeDetailModel:(XHBTraderUserMaginModel*)Model
{
    self.marginModel=Model;
    
    //可用预付款标题
    if(!lb_tit_freeMargin)
    {
        lb_tit_freeMargin=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, GXScreenWidth, 15)];
        lb_tit_freeMargin.textAlignment=NSTextAlignmentCenter;
        lb_tit_freeMargin.font=GXFONT_PingFangSC_Regular(12);
        lb_tit_freeMargin.text=@"可用预付款";
        lb_tit_freeMargin.textColor=GXGray_priceDetailTrade_TextColor;
        [self addSubview:lb_tit_freeMargin];
    }
    
    //可用预付款
    if(!lb_freeMargin)
    {
        lb_freeMargin=[[UILabel alloc]initWithFrame:CGRectMake(0, lb_tit_freeMargin.frame.origin.y+lb_tit_freeMargin.frame.size.height, GXScreenWidth, 35)];
        lb_freeMargin.textColor=GXBlack_priceNameColor;
        lb_freeMargin.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lb_freeMargin];
    }
    [lb_freeMargin setAttributedText:Model.userFreeMargin_att];
    Model.userFreeMargin_att=nil;
    
    
    float titwidth=GXScreenWidth/2.0;

    
    //净值标题
    if(!lb_tit_worth)
    {
        lb_tit_worth=[[UILabel alloc]initWithFrame:CGRectMake(0, lb_freeMargin.frame.origin.y+lb_freeMargin.frame.size.height+18, titwidth, 15)];
        lb_tit_worth.textAlignment=NSTextAlignmentCenter;
        lb_tit_worth.font=GXFONT_PingFangSC_Regular(12);
        lb_tit_worth.text=@"净值";
        lb_tit_worth.textColor=GXGray_priceDetailTrade_TextColor;
        [self addSubview:lb_tit_worth];
    }

    //净值
    if(!lb_worth)
    {
        lb_worth=[[UILabel alloc]initWithFrame:CGRectMake(0, lb_tit_worth.frame.origin.y+lb_tit_worth.frame.size.height, titwidth, 25)];
        lb_worth.textColor=GXBlack_priceNameColor;
        lb_worth.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lb_worth];
    }
    [lb_worth setAttributedText:Model.userEquity_att];
    Model.userEquity_att=nil;
    
    

    //浮动盈亏标题
    if(!lb_tit_floatProfit)
    {
        lb_tit_floatProfit=[[UILabel alloc]init];
        lb_tit_floatProfit.textAlignment=NSTextAlignmentCenter;
        lb_tit_floatProfit.font=GXFONT_PingFangSC_Regular(12);
        lb_tit_floatProfit.text=@"浮动盈亏";
        lb_tit_floatProfit.textColor=GXGray_priceDetailTrade_TextColor;
        [self addSubview:lb_tit_floatProfit];
        [lb_tit_floatProfit sizeToFit];
        lb_tit_floatProfit.center=CGPointMake(titwidth+titwidth/2.0, lb_tit_worth.frame.origin.y+7.5);
    }
    
    if(!btn_spreadQuestion)
    {
        btn_spreadQuestion=[[UIButton alloc]initWithFrame:CGRectMake(0,0 , 42, 42)];
        [btn_spreadQuestion setImage:[UIImage imageNamed:@"tradeViewMake_question"] forState:UIControlStateNormal];
        [btn_spreadQuestion addTarget:self action:@selector(btn_spreadQuestion_Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_spreadQuestion];
        btn_spreadQuestion.center=CGPointMake(lb_tit_floatProfit.frame.origin.x+lb_tit_floatProfit.frame.size.width+10, lb_tit_floatProfit.frame.origin.y+7.5);
    }
    
    
    //浮动盈亏
    if(!lb_floatProfit)
    {
        lb_floatProfit=[[UILabel alloc]initWithFrame:CGRectMake(titwidth, lb_tit_floatProfit.frame.origin.y+lb_tit_floatProfit.frame.size.height, titwidth, 25)];
        lb_floatProfit.textColor=GXBlack_priceNameColor;
        lb_floatProfit.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lb_floatProfit];
    }
    [lb_floatProfit setAttributedText:Model.userFL_att];
    Model.userFL_att=nil;
    
    
    //线
    if(!lineImg)
    {
        lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(titwidth, lb_tit_floatProfit.frame.origin.y, 1, 30)];
        lineImg.backgroundColor=GXGrayLineColor;
        [self addSubview:lineImg];
    }
    
    
    if(!positionTableviewTitView)
    {
        positionTableviewTitView=[[UIView alloc]initWithFrame:CGRectMake(0, lb_floatProfit.frame.origin.y+lb_floatProfit.frame.size.height+20, GXScreenWidth, 95)];
        positionTableviewTitView.backgroundColor=[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:243.0f/255.0f alpha:1.0f];;
        [self addSubview:positionTableviewTitView];
        
        
//        //预付款比例前面叹号按钮
//        UIButton *btn_position_tanhao=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, 45, 45)];
//        [btn_position_tanhao setImage:[UIImage imageNamed:@"img_position_tanhao"] forState:UIControlStateNormal];
//        btn_position_tanhao.backgroundColor=GXBlue_HistoryListFilterBackgColor;
//        [btn_position_tanhao addTarget:self action:@selector(btn_position_tanhaoClick) forControlEvents:UIControlEventTouchUpInside];
//        [positionTableviewTitView addSubview:btn_position_tanhao];
    
        UIView *rishView=[[UIView alloc]initWithFrame:CGRectMake(0, 8, GXScreenWidth, 45)];
        rishView.backgroundColor=[UIColor whiteColor];
        [positionTableviewTitView addSubview:rishView];
        
        
        //预付款比例
        lb_Risk=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 45)];
        lb_Risk.textColor=GXRGBColor(245, 98, 98);
        lb_Risk.font=GXFONT_PingFangSC_Regular(14);
        [rishView addSubview:lb_Risk];
        
        //入金按钮
        UIButton *btn_intoGold=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-15-140, 10, 140, 25)];
        [btn_intoGold setTitle:@"入金可避免强平损失>>" forState:UIControlStateNormal];
        btn_intoGold.titleLabel.font=GXFONT_PingFangSC_Regular(12);
        [btn_intoGold setTitleColor:GXRGBColor(254, 121, 32) forState:UIControlStateNormal];
        [btn_intoGold addTarget:self action:@selector(inGold) forControlEvents:UIControlEventTouchUpInside];
        [btn_intoGold setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [rishView addSubview:btn_intoGold];
        
    
        
        //列表标题
        self.lb_titTableview=[[UILabel alloc]initWithFrame:CGRectMake(0, rishView.frame.origin.y+rishView.frame.size.height, GXScreenWidth, positionTableviewTitView.frame.size.height-rishView.frame.origin.y-rishView.frame.size.height)];
        self.lb_titTableview.textColor=GXGray_priceTitleColor;
        self.lb_titTableview.font=GXFONT_PingFangSC_Regular(14);
        self.lb_titTableview.backgroundColor=[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0f];
        self.lb_titTableview.text=@"    当前持仓";
        [positionTableviewTitView addSubview:self.lb_titTableview];
        
    }
    lb_Risk.text=[NSString stringWithFormat:@"风险率 %@",Model.marginLevel_str];
    
}

//入金
-(void)inGold
{
    [delegate positionHeaViewInGold];
}

//问号
-(void)btn_position_tanhaoClick
{
    [delegate positionHeaViewQuestion];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [delegate positionHeaViewClick];
}

-(void)btn_spreadQuestion_Click
{
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"浮动盈亏" message:@"交易品种行情变动造成的当前持仓的盈亏情况" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
}

@end
