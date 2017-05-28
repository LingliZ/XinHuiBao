//
//  HistoryListModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "HistoryListModel.h"

@implementation HistoryListModel

-(NSString *)OrderTime_noHMM
{
    NSString *dateString = _OrderTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *mydate=[formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:mydate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:mydate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:mydate] integerValue];

    NSString *str=[NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];
    
    formatter=nil;
    
    return str;
}
-(NSString *)OrderCommission
{
    return [NSString stringWithFormat:@"%.2f",[_OrderCommission floatValue]];
}
-(NSString *)OrderProfit
{
    return [NSString stringWithFormat:@"%.2f",[_OrderProfit floatValue]];
}
-(NSString *)OrderAmount
{
    return [NSString stringWithFormat:@"%.2f",[_OrderAmount floatValue]/100.0];
}
-(NSString *)OrderInsterest
{
    return [NSString stringWithFormat:@"%.2f",[_OrderInsterest floatValue]];
}
-(NSString *)TotalLots
{
    return [NSString stringWithFormat:@"%.2f",[_TotalLots floatValue]];
}

-(NSString *)InvestmentCode
{
    NSString *str;
    if([_OrderLongShort intValue]==5)
    {
        str=@"返佣";
    }else if([_OrderLongShort intValue]==3||[_OrderLongShort intValue]==6)
    {
        str=@"出入金";
    }
    else if([_OrderLongShort intValue]==4)
    {
        str=@"信用";
    }
    else
    {
        str=_InvestmentCode;
    }
    
    return str;
}

-(NSString *)OrderLongShort_text
{
    if([_OrderLongShort intValue]==1)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return @"做多";
        }else if ([_OrderOpenClose intValue]==2)
        {
            return @"平仓";
        }
        
    }else if ([_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return @"做空";
        }else if ([_OrderOpenClose intValue]==2)
        {
            return @"平仓";
        }
    }else if ([_OrderLongShort intValue]==3)
    {
        if([_OrderNetProfit floatValue]>=0)
        {
            return @"入金";
        }else if([_OrderNetProfit floatValue]<0)
        {
            return @"出金";
        }
    }else if ([_OrderLongShort intValue]==5)
    {
        return @"返佣";
    }
    else if ([_OrderLongShort intValue]==6)
    {
        return @"退款";
    }
    else if ([_OrderLongShort intValue]==4)
    {
        return @"信用";
    }
    
    return @"--";
}

-(UIColor *)OrderLongShortBackgColor
{
    if([_OrderLongShort intValue]==1)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return GXRed_priceBackgColor;
        }else if ([_OrderOpenClose intValue]==2)
        {
            return GXMainColor;
        }
        
    }else if ([_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return GXGreen_priceBackgColor;
        }else if ([_OrderOpenClose intValue]==2)
        {
            return GXMainColor;
        }
    }else if ([_OrderLongShort intValue]==5 || [_OrderLongShort intValue]==3|| [_OrderLongShort intValue]==4)
    {
        return [UIColor colorWithRed:87.0f/255.0f green:160.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    }
    else if([_OrderLongShort intValue]==6)
    {
        return GXRed_priceBackgColor;
    }
    return GXGrayColor;
}

-(NSString *)OrderOpenClose
{
    NSString *str=@"";
    if([_OrderOpenClose intValue]==1)
    {
        str=@"建仓";
    }
    return str;
}

-(UIColor *)OrderOpenCloseBackgColor
{
    if([_OrderOpenClose intValue]==1)
    {
        return [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    }else
    {
        return GXGrayColor;
    }
}

-(BOOL)OrderOpenClose_isHidden
{
    if([_OrderOpenClose intValue]==1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSString *)LocalOrderID_text
{
    NSString *str=[NSString stringWithFormat:@"订单号：%@",_LocalOrderID];
    return str;
}
-(NSString *)left_tit
{
    if([_OrderLongShort intValue]==1||[_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return @"建仓价";
        }
        else if ([_OrderOpenClose intValue]==2)
        {
            return @"平仓价";
        }
    }
    else if ([_OrderLongShort intValue]==5)
    {
        return @"原单号";
    }
    else if ([_OrderLongShort intValue]==3||[_OrderLongShort intValue]==6||[_OrderLongShort intValue]==4)
    {
        return @"金额";
    }
    
    return @"";
}
-(NSMutableAttributedString *)left_val_att
{
    NSString *str=@"";
    UIColor *cor1=GXBlack_priceNameColor;
    UIColor *cor2=GXBlack_priceNameColor;
    
    if([_OrderLongShort intValue]==1||[_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            str= _OrderPrice;
        }
        else if ([_OrderOpenClose intValue]==2)
        {
            str= _OrderClosePrice;
        }
    }
    else if ([_OrderLongShort intValue]==5)
    {
        str= _ExchangeOrderID;
    }
    else if ([_OrderLongShort intValue]==3||[_OrderLongShort intValue]==6||[_OrderLongShort intValue]==4)
    {
        str= [@"$"stringByAppendingString: _OrderNetProfit ];
        if([_OrderNetProfit floatValue]>=0)
        {
            cor2=GXRed_priceBackgColor;
        }else
        {
            cor2=GXGreen_priceBackgColor;
        }
        cor1=GXGray_PositionTrade_TextColor;
    }
    
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    if(attStr.length>=1)
    [attStr addAttribute:NSForegroundColorAttributeName value:cor1 range:NSMakeRange(0, 1)];
    if(attStr.length>=2)
    [attStr addAttribute:NSForegroundColorAttributeName value:cor2 range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;

}
-(NSString *)right_tit
{
    if([_OrderLongShort intValue]==1||[_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return @"建仓时间";
        }
        else if ([_OrderOpenClose intValue]==2)
        {
            return @"平仓时间";
        }
    }
    else if ([_OrderLongShort intValue]==5)
    {
        return @"返佣时间";
    }
    else if ([_OrderLongShort intValue]==3)
    {
        if([_OrderNetProfit floatValue]>=0)
        {
            return @"入金时间";
        }else
        {
            return @"出金时间";
        }
    }
    else if ([_OrderLongShort intValue]==6)
    {
        return @"退款时间";
    }
    else if ([_OrderLongShort intValue]==4)
    {
        return @"时间";
    }
    return @"";
}
-(NSString *)middle_tit
{
    if([_OrderLongShort intValue]==1||[_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            return @"交易手数";
        }
        else if ([_OrderOpenClose intValue]==2)
        {
            return @"盈亏";
        }
    }else if ([_OrderLongShort intValue]==5)
    {
        return @"金额";
    }
    
    return @"";
}
-(NSMutableAttributedString *)middle_val_att
{
    NSString *str=@"";
    UIColor *cor1=GXGray_PositionTrade_TextColor;
    UIColor *cor2=GXBlack_priceNameColor;
    
    if([_OrderLongShort intValue]==1||[_OrderLongShort intValue]==2)
    {
        if([_OrderOpenClose intValue]==1)
        {
            str= [NSString stringWithFormat:@"%.2f",[_OrderAmount floatValue]/100.0];
            cor1=GXBlack_priceNameColor;
            cor2=GXBlack_priceNameColor;
        }
        else if ([_OrderOpenClose intValue]==2)
        {
            str=[NSString stringWithFormat:@"$%.2f",[_OrderNetProfit floatValue]];
            
            if([_OrderNetProfit floatValue]>=0)
            {
                cor2=GXRed_priceBackgColor;
            }else
            {
                cor2=GXGreen_priceBackgColor;
            }
        }
    }
    else if ([_OrderLongShort intValue]==5)
    {
        str= [@"$"stringByAppendingString: _OrderNetProfit ];
        cor2=GXRed_priceBackgColor;
    }
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    if(attStr.length>=1)
    [attStr addAttribute:NSForegroundColorAttributeName value:cor1 range:NSMakeRange(0, 1)];
    if(attStr.length>=2)
    [attStr addAttribute:NSForegroundColorAttributeName value:cor2 range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}
@end
