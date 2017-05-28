//
//  XHBTraderUserMaginModel.m
//  XHBApp
//
//  Created by shenqilong on 17/3/6.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTraderUserMaginModel.h"

@implementation XHBTraderUserMaginModel
-(NSMutableAttributedString *)userEquity_att_smallFont
{
    NSString *equitystr =[NSString stringWithFormat:@"%.2f",[_equity floatValue]];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",equitystr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(14) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(16) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}


-(NSMutableAttributedString *)userFreeMargin_att
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",_marginFree]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(25) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Medium(29) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSMutableAttributedString *)userEquity_att
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",_equity]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSString *)FL
{
    if([_FL floatValue]==0)
    {
        return @"0.00";
    }
    return _FL;
}

-(NSMutableAttributedString *)userFL_att
{
    UIColor *cor;
    if([_FL floatValue]>0)
    {
        cor=GXRed_priceBackgColor;
        
    }else if ([_FL floatValue]<0)
    {
        cor=GXGreen_priceBackgColor;
    }else
    {
        cor=GXGrayColor;
    }
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$ %@",self.FL]];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(0, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:cor range:NSMakeRange(1, attStr.length-1)];
    [attStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(17) range:NSMakeRange(1, attStr.length-1)];
    
    return attStr;
}

-(NSString *)marginLevel_str
{
    NSString *str=[_marginLevel stringByAppendingString:@"%"];
    return str;
}

@end
