//
//  PriceMarketModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceMarketModel.h"

@implementation PriceMarketModel


//code GET
- (NSString *)code {
    return [_code lowercaseString];
}


// 交易时间
- (NSString *)quoteTime {
    return [NSString StringFromquoteTime:_quoteTime];
}
// 交易时间不带年月日
- (NSString *)quoteTime2 {
    return [NSString StringFromquoteTime_notYMD:_quoteTime];
}

// 交易状态
- (NSString *)status {
    
    if ([_status isEqualToString:@"open"]) {
        return @"交易中";
    } else if ([_status isEqualToString:@"close"]) {
        return @"结束交易";
    } else if (_status.length == 0) {
        return @"";
    }
    return @"";
}


- (NSString *)buy {
    
    CGFloat floatBuy = [_buy floatValue];
    
    if (floatBuy != 0) {
        
        return _buy;
    } else {
        
        return _sell;
    }
    
}

// 涨幅
- (NSString *)increase {
    
    float increaseNumber = [self.last floatValue] - [self.lastclose floatValue];
    
    if (increaseNumber > 0) {
        if([self.code containsString:@"lls"])
        {
            return [NSString stringWithFormat:@"+%.3f",increaseNumber];
        }
        return [NSString stringWithFormat:@"+%.2f",increaseNumber];
    } else {
        if([self.code containsString:@"lls"])
        {
            return [NSString stringWithFormat:@"%.3f",increaseNumber];
        }
        return [NSString stringWithFormat:@"%.2f",increaseNumber];
    }
}


// 涨幅百分比
- (NSString *)increasePercentage {
    
    float increaseNumber = [self.last floatValue] - [self.lastclose floatValue];
    float increasePercentage = increaseNumber  * 100 / [self.lastclose floatValue];
    
    if (increasePercentage > 0 ) {
        return [NSString stringWithFormat:@"+%.2f%%",increasePercentage];
    } else {
        return [NSString stringWithFormat:@"%.2f%%",increasePercentage];
    }
}

// 颜色
- (UIColor *)increaseBackColor {
    
    if ([self.increasePercentage floatValue] > 0) {
        return GXRedColor;
    } else {
        return GXGreenColor;
    }
}



/**
 *  最新价格颜色
 */
- (UIColor *)lastColor {
    return [self compareWithLastClose:self.last];
}


/**
 *  卖价的颜色
 */
- (UIColor *)sellColor {
    return [self compareWithLastClose:self.sell];
}


/**
 *  买价的颜色
 */
- (UIColor *)buyColor {
    return [self compareWithLastClose:self.buy];
}

/**
 *  最高的颜色
 */
- (UIColor *)highColor {
    return [self compareWithLastClose:self.high];
}

/**
 *  最低的颜色
 */
- (UIColor *)lowColor {
    return [self compareWithLastClose:self.low];
}


/**
 *  根据昨收的比较
 *
 *  @param value 参数
 *
 *  @return 不同的颜色
 */
- (UIColor *)compareWithLastClose:(NSString *)value {
    if ([value floatValue] > [self.open floatValue]) {
        return GXRed_priceBackgColor;
    } else if ([value floatValue] < [self.open floatValue]) {
        return GXGreen_priceBackgColor;
    } else {
        return GXGrayColor;
    }
}

-(NSString *)spread
{
    CGFloat floatBuy = [_buy floatValue];
    
    CGFloat floatSell = [_sell floatValue];
    
    return [NSString stringWithFormat:@"%.2f",fabs(floatBuy-floatSell)];
    
}

- (UIColor *)sellOrBuy_bgColor {
    
    if(![GXInstance.last_lastDic objectForKey:_code])
    {
        [GXInstance.last_lastDic setObject:@[_last,[self compareWithLastClose:_last]] forKey:_code];
        
        return [self compareWithLastClose:_last];
    }else
    {
        if([_last floatValue] > [[GXInstance.last_lastDic objectForKey:_code][0] floatValue])
        {
            [GXInstance.last_lastDic setObject:@[_last,GXRed_priceBackgColor] forKey:_code];
            
            return GXRed_priceBackgColor;
        }
        else if([_last floatValue] < [[GXInstance.last_lastDic objectForKey:_code][0] floatValue])
        {
            [GXInstance.last_lastDic setObject:@[_last,GXGreen_priceBackgColor] forKey:_code];
            
            return GXGreen_priceBackgColor;
        }
        else
        {
            return [GXInstance.last_lastDic objectForKey:_code][1];
        }
        
    }
}

-(BOOL)isTrade
{
    if(![self.code isEqualToString:@"lls"]&&![self.code isEqualToString:@"llg"])
    {
        return YES;
    }
    return NO;
}

-(NSMutableAttributedString *)sell_headLarg
{
    NSMutableAttributedString *attri=[[NSMutableAttributedString alloc]initWithString:self.sell];
    
    NSRange range=[self.sell rangeOfString:@"."];
    if (range.location == NSNotFound) {
        return attri;
    }else
    {
        [attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(PriceListCellFont16) range:NSMakeRange(0, range.location)];
        [attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(PriceListCellFont14) range:NSMakeRange(range.location, self.sell.length-range.location)];
        
        return attri;
    }
}

-(NSMutableAttributedString *)buy_headLarg
{
    NSMutableAttributedString *attri=[[NSMutableAttributedString alloc]initWithString:self.buy];
    
    NSRange range=[self.buy rangeOfString:@"."];
    if (range.location == NSNotFound) {
        return attri;
    }else
    {
        [attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(PriceListCellFont16) range:NSMakeRange(0, range.location)];
        [attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(PriceListCellFont14) range:NSMakeRange(range.location, self.buy.length-range.location)];
        
        return attri;
    }
}

-(BOOL)status_hidden
{
    if ([_status isEqualToString:@"open"]) {
        
        if(![self.code isEqualToString:@"lls"]&&![self.code isEqualToString:@"llg"])
        {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

-(NSString *)customTag1
{
    NSString *str;
    
    if([self.code isEqualToString:@"llg"])
    {
        str=@"LLG";
    }else if([self.code isEqualToString:@"lls"])
    {
        str=@"LLS";
    }else if([self.code isEqualToString:@"$dxy"])
    {
        str=@"USDX";
    }else if([self.code isEqualToString:@"hf_cl"])
    {
        str=@"CLWTI";
    }else
    {
        str=@"";
    }
    
    return str;
}


@end
