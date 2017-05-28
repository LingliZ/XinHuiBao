//
//  CloseDetailView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "CloseDetailView.h"
#import "PositionListModel.h"

@implementation CloseDetailView
{
    //列表名字与编码
    UIView *nameview;
    UILabel *lb_name;
    //方向
    UILabel *lb_OrderLongShort;
    
    NSArray *lb_titar;
    
}
#define tag_lbDetail_price 20160090
#define tag_lbDetail_ft 123123
#define cell_height 58
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, cell_height*4+40)]) {
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)setPModel:(PositionListModel *)pModel
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
    lb_name.text = [NSString stringWithFormat:@"%@",pModel.InvestmentCode];
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
    lb_OrderLongShort.text = [NSString stringWithFormat:@"%@",pModel.OrderLongShort_text];
    lb_OrderLongShort.backgroundColor=pModel.OrderLongShortBackgColor;
    lb_OrderLongShort.frame=CGRectMake(lb_name.frame.origin.x+lb_name.frame.size.width+12, (nameview.frame.size.height-18)/2.0, 35, 18);
    
    
    if(!lb_titar)
    {
        lb_titar=@[@"订单号",@"建仓时间",@"交易手数",@"手续费",@"隔夜利息",@"建仓价",@"现价",@"浮动盈亏"];
        NSArray *lb_valar=@[pModel.LocalOrderID,pModel.OrderTime,pModel.OrderAmount,pModel.OrderCommission,pModel.OrderInsterest,pModel.OrderPrice,pModel.OrderClosePrice,pModel.OrderProfit_att];
    
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
            if(i==[lb_titar count]-1)
            {
                [lb_val setAttributedText:lb_valar[i]];
            }else
            {
                lb_val.text=lb_valar[i];
            }

            if(i==[lb_titar count]-1)
            {
                lb_val.tag=tag_lbDetail_ft;
            }else if(i==[lb_valar count]-2)
            {
                lb_val.tag=tag_lbDetail_price;
            }
            
        }
    }
    
    UILabel *lb_price=[self viewWithTag:tag_lbDetail_price];
    lb_price.text=pModel.OrderClosePrice;
    
    UILabel *lb_ft=[self viewWithTag:tag_lbDetail_ft];
    lb_ft.attributedText=pModel.OrderProfit_att;
    
    
}

@end
