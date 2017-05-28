//
//  PositionListModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PositionListModel.h"

@implementation PositionListModel

-(NSString *)OrderLongShort_text
{
    if([_OrderLongShort intValue]==1)
    {
        return @"做多";
    }else if ([_OrderLongShort intValue]==2)
    {
        return @"做空";
    }else
    {
        return @"--";
    }
}

-(UIColor *)OrderLongShortBackgColor
{
    if([_OrderLongShort intValue]==1)
    {
        return GXRed_priceBackgColor;
    }else if ([_OrderLongShort intValue]==2)
    {
        return GXGreen_priceBackgColor;
    }else
    {
        return GXGrayColor;
    }
}

-(NSString *)OrderClosePrice
{
    NSString *str=@"";
    if([_OrderLongShort intValue]==1)
    {
        str= _buy;
    }else if ([_OrderLongShort intValue]==2)
    {
        str= _sell;
    }
    
    if([str floatValue]==0)
    {
        str=@"--";
    }

    return str;
}

-(NSString *)OrderProfit
{
    if([self.OrderClosePrice floatValue]==0)
    {
        return @"--";
    }
    else
    {
        float profit=[self computeProfit];
        
        NSString *str=[NSString stringWithFormat:@"%.2f",profit];//盈亏
        
        return  str;
    }
}

-(NSMutableAttributedString *)OrderProfit_att
{
    if([self.OrderClosePrice floatValue]==0)
    {
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:@"--"];
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGrayColor range:NSMakeRange(0, attStr.length)];
        
        return attStr;
    }else
    {
        float profit=[self computeProfit];
        
        NSString *str=[NSString stringWithFormat:@"%.2f",profit];//盈亏
        
        //判断颜色
        UIColor *cor;
        if(profit>0)
        {
            cor=GXRed_priceBackgColor;
            
        }else if (profit<0)
        {
            cor=GXGreen_priceBackgColor;
        }else
        {
            cor=GXGrayColor;
        }
        
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",str]];
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
        
        return attStr;
    }
}

-(float)computeProfit
{
    //如果平仓价有值，计算浮动盈亏，此处为持仓的，OrderPrice返回都是0，不用管它，如果是历史直接读取OrderPrice
    //计算浮动盈亏时候，黄金*100，白银*5000，但是建仓时候算预付款都是*1000，
    
    float unit=0;
    if([[self.QuoteUUID lowercaseString]isEqualToString:@"llg"])
    {
        unit=100;
    }else if ([[self.QuoteUUID lowercaseString]isEqualToString:@"lls"])
    {
        unit=5000;
    }
    
    
    float profit;
    if([_OrderLongShort intValue]==1)
    {
        profit=([self.OrderClosePrice floatValue]-[_OrderPrice floatValue])*[self.OrderAmount floatValue]*unit + [_OrderInsterest floatValue];
    }else
    {
        profit=-([self.OrderClosePrice floatValue]-[_OrderPrice floatValue])*[self.OrderAmount floatValue]*unit + [_OrderInsterest floatValue];
    }
    return profit;
}

-(NSString *)OrderAmount
{
    NSString *str=[NSString stringWithFormat:@"%.2f",[_OrderAmount floatValue]/100.0];
    
    return str;
}

-(NSString *)QuoteUUID
{
    NSString *str=@"";
    if(_QuoteUUID.length>=3)
    {
        str=[_QuoteUUID substringWithRange:NSMakeRange(0, 3)];
    }
    
    return str;
}

-(NSString *)OrderInsterest
{
    return [NSString stringWithFormat:@"%.2f",[_OrderInsterest floatValue]];
}

@end
