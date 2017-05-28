//
//  XHBTradePositionModel.m
//  XHBApp
//
//  Created by shenqilong on 17/3/7.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTradePositionModel.h"

@implementation XHBTradePositionModel

-(NSString *)symbolCode
{
    if([[_symbol lowercaseString] containsString:@"llg"])
    {
        return @"llg";
    }
    
    if([[_symbol lowercaseString] containsString:@"lls"])
    {
        return @"lls";
    }
    return  _symbol;
}

-(NSString *)cmd_str
{
    if([self.cmd integerValue]==0)
    {
        return @"做多";
    }else if ([self.cmd integerValue]==1)
    {
        return @"做空";
    }else if ([self.cmd integerValue]==2)
    {
        return @"做多限价";
    }else if ([self.cmd integerValue]==3)
    {
        return @"做空限价";
    }else if ([self.cmd integerValue]==4)
    {
        return @"做多止损";
    }else if ([self.cmd integerValue]==5)
    {
        return @"做空止损";
    }else if ([self.cmd integerValue]==6)
    {
        if([_comment containsString:@"agent"])
        {
            return @"返佣";
        }
        else if([_comment containsString:@"REFUND"])
        {
            return @"退款";
        }
        else
        {
            if([_profit floatValue]>=0)
            {
                return @"入金";
            }else
            {
                return @"出金";
            }
        }
    }else if ([self.cmd integerValue]==7)
    {
        return @"信用";
    }
    
    return @"--";
}

-(UIColor *)cmd_BackgColor
{
    if([self.cmd integerValue]==0||[self.cmd integerValue]==2||[self.cmd integerValue]==4)
    {
        return GXRed_priceBackgColor;
    }else if ([self.cmd integerValue]==1||[self.cmd integerValue]==3||[self.cmd integerValue]==5)
    {
        return GXGreen_priceBackgColor;
    }else if ([self.cmd integerValue]==6||[self.cmd integerValue]==7)
    {
        return [UIColor colorWithRed:87.0f/255.0f green:160.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    }else
    {
        return GXGrayColor;
    }
}

-(NSString *)sl_str
{
    if([_sl floatValue]==0)
    {
        return @"未设置";
    }
    return _sl;
}

-(NSString *)tp_str
{
    if([_tp floatValue]==0)
    {
        return @"未设置";
    }
    return _tp;
}

-(NSString *)volume
{
    return [NSString stringWithFormat:@"%.2f",[_volume floatValue]/100.00];
}

-(NSString *)swapsCommission_str
{
    return [NSString stringWithFormat:@"%.2f",[_swaps floatValue]+[_commission floatValue]];
}

-(NSMutableAttributedString *)OrderProfit_noCommission_att
{
    //判断颜色
    UIColor *cor;
    if([_profit floatValue]>0)
    {
        cor=GXRed_priceBackgColor;
        
    }else if ([_profit floatValue]<0)
    {
        cor=GXGreen_priceBackgColor;
    }else
    {
        cor=GXGrayColor;
    }
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",_profit]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSMutableAttributedString *)OrderProfit_att
{
    if([_closePrice floatValue]==0)
    {
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:@"--"];
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGrayColor range:NSMakeRange(0, attStr.length)];
        
        return attStr;
    }else
    {
        //判断颜色
        UIColor *cor;
        if([self.FL floatValue]>0)
        {
            cor=GXRed_priceBackgColor;
            
        }else if ([self.FL floatValue]<0)
        {
            cor=GXGreen_priceBackgColor;
        }else
        {
            cor=GXGrayColor;
        }
        
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",self.FL]];
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
        
        return attStr;
    }
}

-(NSString *)FL
{
    //如果平仓价有值，计算浮动盈亏，此处为持仓的，OrderPrice返回都是0，不用管它，如果是历史直接读取OrderPrice
    //计算浮动盈亏时候，黄金*100，白银*5000，但是建仓时候算预付款都是*1000，
    
    float unit=0;
    if([[_symbol lowercaseString] containsString:@"llg"])
    {
        unit=100;
    }else if ([[_symbol lowercaseString] containsString:@"lls"])
    {
        unit=5000;
    }
    
    
    float profit;
    if([self.cmd integerValue]==0)
    {
        profit=([_closePrice floatValue] - [_openPrice floatValue])*[self.volume floatValue] *unit + [_swaps floatValue] +[_commission floatValue];
    }else
    {
        profit=([_openPrice floatValue] - [_closePrice floatValue])*[self.volume floatValue] *unit + [_swaps floatValue] +[_commission floatValue];
    }
    return [NSString stringWithFormat:@"%.2f",profit];
}

-(NSString *)openTime_noHMM
{
    NSString *dateString = _openTime;
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

#pragma mark - 历史列表专用
-(NSString *)historyList_tag
{
    if([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5||[self.cmd integerValue]==6||[self.cmd integerValue]==7)
    {
        return @"";
    }
    
    if([_comment hasPrefix:@"[sl]"])
    {
        return @"止损";
    }
    
    if([_comment hasPrefix:@"[tp]"])
    {
        return @"止盈";
    }
    
    if([_comment hasPrefix:@"so:"])
    {
        return @"强平";
    }
    
    if([_closeTime containsString:@"1970"])
    {
        return @"建仓";
    }else
    {
        return @"平仓";
    }
}

-(UIColor *)historyList_tagBg
{
    return GXRGBColor(255, 151, 84);
}


-(NSString *)left_tit
{
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            return @"建仓价";
        }else
        {
            return @"平仓价";
        }
    }
    else if([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5)
    {
        return @"挂单价格";
    }
    else if([self.cmd integerValue]==6||[self.cmd integerValue]==7)
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
 
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            str= _openPrice;
        }else
        {
            str= _closePrice;
        }
    }
    else if([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5)
    {
        str=_openPrice;
    }
    else
    {
        str= [@"$"stringByAppendingString: _profit ];
        if([_profit floatValue]>=0)
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
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            return @"建仓时间";
        }else
        {
            return @"平仓时间";
        }
    }
    else if ([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5)
    {
        return @"已撤单";
    }
    else if ([self.cmd integerValue]==6)
    {
        if([_comment containsString:@"agent"])
        {
            return @"返佣时间";
        }
        else if([_comment containsString:@"REFUND"])
        {
            return @"退款时间";
        }
        else
        {
            if([_profit floatValue]>=0)
            {
                return @"入金时间";
            }else
            {
                return @"出金时间";
            }
        }
    }else if ([self.cmd integerValue]==7)
    {
        return @"返佣时间";
    }
    
    return @"";
}

-(NSString *)right_value
{
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            return _openTime;
        }else
        {
            return _closeTime;
        }
    }
    return _closeTime;
}

-(NSString *)middle_tit
{
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            return @"交易手数";
        }else
        {
            return @"盈亏";
        }
    }
    else if([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5)
    {
        return @"交易手数";
    }
    else if ([self.cmd integerValue]==6)
    {
        if([_comment containsString:@"agent"])
        {
            return @"原单号";
        }
    }
    
    return @"";
}
-(NSMutableAttributedString *)middle_val_att
{
    NSString *str=@"";
    UIColor *cor1=GXGray_PositionTrade_TextColor;
    UIColor *cor2=GXBlack_priceNameColor;
    
    if([self.cmd integerValue]==0 || [self.cmd integerValue]==1)
    {
        if([_closeTime containsString:@"1970"])
        {
            str= self.volume;
            cor1=GXBlack_priceNameColor;
            cor2=GXBlack_priceNameColor;
        }else
        {
            str=[NSString stringWithFormat:@"$%.2f",[_profit floatValue]];
            
            if([_profit floatValue]>=0)
            {
                cor2=GXRed_priceBackgColor;
            }else
            {
                cor2=GXGreen_priceBackgColor;
            }
        }
    }
    else if([self.cmd integerValue]==2||[self.cmd integerValue]==3||[self.cmd integerValue]==4||[self.cmd integerValue]==5)
    {
        str= self.volume;
        cor1=GXBlack_priceNameColor;
        cor2=GXBlack_priceNameColor;
    }
    else if ([self.cmd integerValue]==6)
    {
        if([_comment containsString:@"agent"])
        {
            NSArray *ar=[_comment componentsSeparatedByString:@"#"];
            if([ar count]>0)
            {
                str=[ar lastObject];
            }
            cor1=GXBlack_priceNameColor;
            cor2=GXBlack_priceNameColor;
        }
    }
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    if(attStr.length>=1)
        [attStr addAttribute:NSForegroundColorAttributeName value:cor1 range:NSMakeRange(0, 1)];
    if(attStr.length>=2)
        [attStr addAttribute:NSForegroundColorAttributeName value:cor2 range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSString *)hisName
{
    if ([self.cmd integerValue]==6)
    {
        if([_comment containsString:@"agent"])
        {
            return @"返佣";
        }
        else if([_comment containsString:@"REFUND"])
        {
            return @"退款";
        }
        else
        {
            if([_profit floatValue]>=0)
            {
                return @"入金";
            }else
            {
                return @"出金";
            }
        }
    }else if ([self.cmd integerValue]==7)
    {
        return @"信用";
    }
    
    return _symbol;
}

@end
