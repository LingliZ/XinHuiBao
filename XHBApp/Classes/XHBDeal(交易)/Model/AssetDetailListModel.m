//
//  AssetListModel.m
//  XHBApp
//
//  Created by shenqilong on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AssetDetailListModel.h"

@implementation AssetDetailListModel
-(NSString *)operationtype_text
{
    if([_operationtype intValue]==0)
    {
        return @"入金";
    }
    else
    {
        return @"出金";
    }
}
-(UIColor *)operationtype_color
{
    if([_operationtype intValue]==0)
    {
        return GXRed_priceBackgColor;
    }
    else
    {
        return GXGreen_priceBackgColor;
    }
}
-(NSString *)bankname
{
    if([_operationtype intValue]==0)
    {

        return [NSString stringWithFormat:@"由 %@ 入金",_bankname];
    }else
    {
        return [NSString stringWithFormat:@"出金至 %@",_bankname];
    }
}
-(NSMutableAttributedString *)amountnum_att
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"$%@",_amountnum]];
    if(attStr.length>=1)
        [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_PositionTrade_TextColor range:NSMakeRange(0, 1)];
    if(attStr.length>=2)
        [attStr addAttribute:NSForegroundColorAttributeName value:GXMainColor range:NSMakeRange(1, attStr.length-1)];
    return attStr;
}
-(NSString *)status_text
{
    if([_status intValue]==0)
    {
        return @"出金申请中";
    }else if([_status intValue]==1)
    {
        return @"成功";
    }else
    {
        return @"失败";
    }
}
-(UIColor *)status_color
{
    if([_status intValue]==0||[_status intValue]==1)
    {
        return GXMainColor;
    }else
    {
        return GXGray_priceNameColor;
    }
}
@end
