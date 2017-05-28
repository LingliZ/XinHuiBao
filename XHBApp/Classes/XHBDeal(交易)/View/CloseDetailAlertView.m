//
//  CloseDetailAlertView.m
//  XHBApp
//
//  Created by shenqilong on 16/12/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "CloseDetailAlertView.h"
#import "PositionListModel.h"

#define alertView_maxWidth (GXScreenWidth-60)
#define tag_lbDetail_price 20160090
#define tag_lbDetail_ft 123123
@implementation CloseDetailAlertView
{
    UIView *alertv;
    UILabel *lb_tit;
    
    NSArray *lb_titar;
    
    UILabel *lb_tit_openOrderTip;//提示语
    
    UIButton *btn_cancel;
    UIButton *btn_orderClose;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate;
- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)]) {
        
        self.backgroundColor=[UIColor clearColor];
        
        UIView *backg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        backg.backgroundColor=[UIColor blackColor];
        backg.alpha=0.6;
        [self addSubview:backg];
        
        alertv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView_maxWidth, 300)];
        alertv.center=self.center;
        alertv.backgroundColor=[UIColor whiteColor];
        alertv.layer.masksToBounds=YES;
        alertv.layer.cornerRadius=4;
        [self addSubview:alertv];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(alertView_maxWidth-65, (66-50)/2.0, 50, 50)];
        icon.image=[UIImage imageNamed:@"littlewhale"];
        [alertv addSubview:icon];
        
        lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, icon.frame.origin.x-20, 66)];
        lb_tit.textColor=GXMainColor;
        lb_tit.font=GXFONT_PingFangSC_Medium(18);
        [alertv addSubview:lb_tit];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 66, alertView_maxWidth, 1)];
        line.backgroundColor=GXGrayLineColor;
        [alertv addSubview:line];
        
    }
    return self;
}

-(void)setPModel:(PositionListModel *)pModel
{
    lb_tit.text=pModel.InvestmentCode;
    
    if(!lb_titar)
    {
        lb_titar=@[@"订单号",@"建仓价格",@"现在价格",@"浮动盈亏"];
        NSArray *lb_valar=@[pModel.LocalOrderID,pModel.OrderPrice,pModel.OrderClosePrice,pModel.OrderProfit_att];
        
        for (int i=0; i<[lb_titar count]; i++) {
            
            UILabel *lb_msg_tit=[[UILabel alloc]initWithFrame:CGRectMake(15, lb_tit.frame.origin.y+lb_tit.frame.size.height + i*35, 70, 35)];
            lb_msg_tit.font = GXFONT_PingFangSC_Regular(14);
            lb_msg_tit.textAlignment=NSTextAlignmentLeft;
            lb_msg_tit.textColor = GXGray_priceTitleColor;
            lb_msg_tit.text=lb_titar[i];
            [alertv addSubview:lb_msg_tit];
            
            
            UILabel *lb_msg_val=[[UILabel alloc]initWithFrame:CGRectMake(alertv.frame.size.width-150-15, lb_msg_tit.frame.origin.y, 150, 35)];
            lb_msg_val.font = GXFONT_PingFangSC_Regular(14);
            lb_msg_val.textAlignment=NSTextAlignmentRight;
            lb_msg_val.textColor = GXBlack_priceNameColor;
            [alertv addSubview:lb_msg_val];
            
            if(i==[lb_titar count]-1)
            {
                [lb_msg_val setAttributedText:lb_valar[i]];
            }else
            {
                lb_msg_val.text=lb_valar[i];
            }
            
            if(i==[lb_titar count]-1)
            {
                lb_msg_val.tag=tag_lbDetail_ft;
            }else if(i==[lb_valar count]-2)
            {
                lb_msg_val.tag=tag_lbDetail_price;
            }
        }
    }
    
    UILabel *lb_price=[self viewWithTag:tag_lbDetail_price];
    lb_price.text=pModel.OrderClosePrice;
    
    UILabel *lb_ft=[self viewWithTag:tag_lbDetail_ft];
    lb_ft.attributedText=pModel.OrderProfit_att;
    
    
    //下单说明文本
    if(!lb_tit_openOrderTip)
    {
        lb_tit_openOrderTip=[[UILabel alloc]init];
        lb_tit_openOrderTip.font=GXFONT_PingFangSC_Regular(12);
        lb_tit_openOrderTip.textColor=GXGray_priceDetailTrade_TextColor;
        lb_tit_openOrderTip.text=@"由于网络延迟，订单最终成交价格以服务器成交价格为准";
        lb_tit_openOrderTip.numberOfLines=0;
        lb_tit_openOrderTip.textAlignment=NSTextAlignmentCenter;
        lb_tit_openOrderTip.backgroundColor=GXGrayLineColor;
        CGSize lbSize = [lb_tit_openOrderTip.text boundingRectWithSize:CGSizeMake(alertView_maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lb_tit_openOrderTip.font} context:nil].size;
        lb_tit_openOrderTip.frame=CGRectMake(0, alertv.frame.size.height-44-lbSize.height-14, alertView_maxWidth, lbSize.height+14);
        [alertv addSubview:lb_tit_openOrderTip];
    }
    
    if(!btn_cancel)
    {
        btn_cancel=[[UIButton alloc]initWithFrame:CGRectMake(0, alertv.frame.size.height-44, alertv.frame.size.width/2.0, 44)];
        [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
        btn_cancel.titleLabel.font=GXFONT_PingFangSC_Regular(14);
        [btn_cancel setTitleColor:GXGray_priceTitleColor forState:UIControlStateNormal];
        [self setBorderWithView:btn_cancel top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
        [btn_cancel addTarget:self action:@selector(btn_cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [alertv addSubview:btn_cancel];
    }
    
    if(!btn_orderClose)
    {
        btn_orderClose=[[UIButton alloc]initWithFrame:CGRectMake(alertv.frame.size.width/2.0, alertv.frame.size.height-44, alertv.frame.size.width/2.0, 44)];
        [btn_orderClose setTitle:@"现价平仓" forState:UIControlStateNormal];
        btn_orderClose.titleLabel.font=GXFONT_PingFangSC_Regular(14);
        btn_orderClose.backgroundColor=GXMainColor;
        [btn_orderClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_orderClose addTarget:self action:@selector(btn_orderCloseClick) forControlEvents:UIControlEventTouchUpInside];
        [alertv addSubview:btn_orderClose];
    }
    
}

-(void)btn_cancelClick
{
    [delegate CloseDetailAlertViewDelegate_cancel];
}

-(void)btn_orderCloseClick
{
    [delegate CloseDetailAlertViewDelegate_orderClose];
}

@end
