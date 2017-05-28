//
//  PriceUserTradeMarginModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceUserTradeMarginModel.h"

@implementation PriceUserTradeMarginModel

-(NSString *)FreeMargin
{
    return [self changefloatValue:_FreeMargin];
}

-(NSString *)Equity
{
    return [self changefloatValue:_Equity];
}

-(NSString *)FL
{
    return [self changefloatValue:_FL];
}

-(NSString *)DynamicBalance
{
    return [self changefloatValue:_DynamicBalance];
}

-(NSString *)Margin
{
    return [self changefloatValue:_Margin];
}

-(NSString *)Credit
{
    return [self changefloatValue:_Credit];
}

-(NSString *)changefloatValue:(NSString *)str
{
    return [NSString stringWithFormat:@"%.2f",[str floatValue]];
}

-(NSMutableAttributedString *)userFreeMargin_att1
{
    NSString *strtit=@"可用预付款：";
    
    NSString *fmarginstr =[NSString stringWithFormat:@"%.2f",[_FreeMargin floatValue]];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ $%@",strtit,fmarginstr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(0, strtit.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_priceTitleColor range:NSMakeRange(strtit.length, attStr.length-strtit.length)];
    
    return attStr;
}

-(NSMutableAttributedString *)userFreeMargin_att2
{
    NSString *fmarginstr =[NSString stringWithFormat:@"%.2f",[_FreeMargin floatValue]];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",fmarginstr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(25) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(29) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSMutableAttributedString *)userEquity_att
{
    NSString *equitystr =[NSString stringWithFormat:@"%.2f",[_Equity floatValue]];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",equitystr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSMutableAttributedString *)userEquity_att_smallFont
{
    NSString *equitystr =[NSString stringWithFormat:@"%.2f",[_Equity floatValue]];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",equitystr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(14) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(16) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSMutableAttributedString *)userFL_att
{
    NSString *flstr =[NSString stringWithFormat:@"%.2f",[_FL floatValue]];
    UIColor *cor;
    if([flstr floatValue]>0)
    {
        cor=GXRed_priceBackgColor;
        
    }else if ([flstr floatValue]<0)
    {
        cor=GXGreen_priceBackgColor;
    }else
    {
        cor=GXGrayColor;
    }
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",flstr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSString *)Risk
{
    NSString *Riskstr =[NSString stringWithFormat:@"%.2f",[_Risk floatValue]];
    NSString *str=[Riskstr stringByAppendingString:@"%"];
    return str;
}

@end
