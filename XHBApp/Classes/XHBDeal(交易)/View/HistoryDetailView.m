//
//  HistoryDetailView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/28.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "HistoryDetailView.h"

@implementation HistoryDetailView
{
    //列表名字与编码
    UIView *nameview;
    UILabel *lb_name;
    //方向
    UILabel *lb_OrderLongShort;
    //类型
    UILabel *lb_OrderOpenClose;
    
    NSArray *lb_titar;
    
    UILabel *lb_totalProfit_tit;//总盈亏
    UILabel *lb_totalProfit;
}

#define cell_height 58
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, cell_height*3+40)]) {
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)setHModel:(HistoryListModel *)hModel
{
    if(!nameview)
    {
        nameview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 40)];
        nameview.backgroundColor=[UIColor colorWithRed:251.0/255.0f green:251.0/255.0f blue:252.0/255.0f alpha:1.0f];
        [self addSubview:nameview];
    }
    //名字
    if(!lb_name)
    {
        lb_name=[[UILabel alloc]init];
        lb_name.font = GXFONT_PingFangSC_Regular(16);
        lb_name.textColor = GXBlack_priceNameColor;
        [nameview addSubview:lb_name];
    }
    lb_name.text = [NSString stringWithFormat:@"%@",hModel.InvestmentCode];
    [lb_name sizeToFit];
    lb_name.frame=CGRectMake(15, 0, lb_name.frame.size.width, nameview.frame.size.height);
    
    
    //方向
    if(!lb_OrderLongShort)
    {
        lb_OrderLongShort=[[UILabel alloc]init];
        lb_OrderLongShort.font = GXFONT_PingFangSC_Regular(14);
        lb_OrderLongShort.textColor = [UIColor whiteColor];
        lb_OrderLongShort.textAlignment=NSTextAlignmentCenter;
        lb_OrderLongShort.layer.masksToBounds=YES;
        lb_OrderLongShort.layer.cornerRadius=2;
        [nameview addSubview:lb_OrderLongShort];
    }
    lb_OrderLongShort.text = [NSString stringWithFormat:@"%@",hModel.OrderLongShort_text];
    lb_OrderLongShort.backgroundColor=hModel.OrderLongShortBackgColor;
    lb_OrderLongShort.frame=CGRectMake(lb_name.frame.origin.x+lb_name.frame.size.width+12, (nameview.frame.size.height-18)/2.0, 35, 18);
    
    
    //类型
    if(!lb_OrderOpenClose)
    {
        lb_OrderOpenClose=[[UILabel alloc]init];
        lb_OrderOpenClose.font = GXFONT_PingFangSC_Regular(14);
        lb_OrderOpenClose.textColor = [UIColor whiteColor];
        lb_OrderOpenClose.textAlignment=NSTextAlignmentCenter;
        lb_OrderOpenClose.layer.masksToBounds=YES;
        lb_OrderOpenClose.layer.cornerRadius=2;
        [nameview addSubview:lb_OrderOpenClose];
    }
    lb_OrderOpenClose.text = [NSString stringWithFormat:@"%@",hModel.OrderOpenClose];
    lb_OrderOpenClose.backgroundColor=GXMainColor;
    lb_OrderOpenClose.hidden=hModel.OrderOpenClose_isHidden;
    lb_OrderOpenClose.frame=CGRectMake(lb_OrderLongShort.frame.origin.x+lb_OrderLongShort.frame.size.width+10, (nameview.frame.size.height-18)/2.0, 35, 18);
    
    
    
    BOOL isCloseOrder=YES;
    if([hModel.OrderOpenClose isEqualToString:@"建仓"])
    {
        isCloseOrder=NO;
    }
    
    if(!lb_titar)
    {
        NSArray *lb_valar;
        
        if(isCloseOrder)
        {
            lb_titar=@[@"订单号",@"平仓时间",@"交易手数",@"盈亏",@"手续费",@"隔夜利息",@"建仓价",@"平仓价"];
            lb_valar=@[hModel.LocalOrderID,hModel.OrderTime,hModel.OrderAmount,hModel.OrderProfit,hModel.OrderCommission,hModel.OrderInsterest,hModel.OrderPrice,hModel.OrderClosePrice];
        }else
        {
            lb_titar=@[@"订单号",@"建仓时间",@"交易手数",@"建仓价",@"手续费",@"隔夜利息"];
            lb_valar=@[hModel.LocalOrderID,hModel.OrderTime,hModel.OrderAmount,hModel.OrderPrice,hModel.OrderCommission,hModel.OrderInsterest];
        }
        
        for (int i=0; i<[lb_titar count]; i++) {
            
            int x=i%2;
            int y=i/2;
            
            UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(x*GXScreenWidth/2.0, nameview.frame.size.height+ y*cell_height, GXScreenWidth/2.0, cell_height)];
            if(x==0)
            {
                [self setBorderWithView:vv top:YES left:NO bottom:NO right:YES borderColor:GXGrayLineColor borderWidth:1];
            }else
            {
                [self setBorderWithView:vv top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
            }
            [self addSubview:vv];
            
            UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, vv.frame.size.width, 20)];
            lb_tit.font = GXFONT_PingFangSC_Regular(14);
            lb_tit.textAlignment=NSTextAlignmentCenter;
            lb_tit.textColor = GXGray_priceDetailTrade_TextColor;
            lb_tit.text=lb_titar[i];
            [vv addSubview:lb_tit];
            
            
            UILabel *lb_val=[[UILabel alloc]initWithFrame:CGRectMake(0, lb_tit.frame.origin.y+lb_tit.frame.size.height, vv.frame.size.width, 20)];
            lb_val.font = GXFONT_PingFangSC_Medium(14);
            lb_val.textAlignment=NSTextAlignmentCenter;
            lb_val.textColor = GXBlack_priceNameColor;
            [vv addSubview:lb_val];
            
            if(i==3)
            {
                if(isCloseOrder)
                {
                    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$%@",lb_valar[i]]];
                    if(attStr.length>=1)
                        [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
                    if(attStr.length>=2)
                        [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
                    [lb_val setAttributedText:attStr];
                    attStr=nil;
                }else
                {
                   lb_val.text=lb_valar[i];
                }
            }else
            {
                lb_val.text=lb_valar[i];
            }
            
        }
    }
    
    
    if(isCloseOrder)
    {
        if(!lb_totalProfit)
        {
            UIView *profitView=[[UIView alloc]initWithFrame:CGRectMake(0, 40+4*cell_height, GXScreenWidth, cell_height)];
            profitView.backgroundColor=[UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
            [self setBorderWithView:profitView top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
            [self addSubview:profitView];
            
            
            lb_totalProfit_tit=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth/2.0, profitView.frame.size.height)];
            lb_totalProfit_tit.font = GXFONT_PingFangSC_Regular(16);
            lb_totalProfit_tit.textAlignment=NSTextAlignmentCenter;
            lb_totalProfit_tit.textColor = GXGray_priceTitleColor;
            lb_totalProfit_tit.text=@"总盈亏";
            [profitView addSubview:lb_totalProfit_tit];

            lb_totalProfit=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 0, GXScreenWidth/2.0, profitView.frame.size.height)];
            lb_totalProfit.font = GXFONT_PingFangSC_Regular(14);
            lb_totalProfit.textAlignment=NSTextAlignmentCenter;
            lb_totalProfit.attributedText=[self totalProfitAtt:hModel.OrderNetProfit];
            [profitView addSubview:lb_totalProfit];

        }
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cell_height*5+40);
    }
    
}


-(NSMutableAttributedString *)totalProfitAtt:(NSString *)netProfit
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$%.2f",[netProfit floatValue]]];
    if(attStr.length>=1)
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    
    UIColor *cor;
    if([netProfit floatValue]>=0)
    {
        cor=GXRed_priceBackgColor;
    }else
    {
        cor=GXGreen_priceBackgColor;
    }
    
    if(attStr.length>=2)
        [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}


@end
