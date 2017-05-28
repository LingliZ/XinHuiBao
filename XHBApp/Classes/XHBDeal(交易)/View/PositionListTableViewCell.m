//
//  PositionListTableViewCell.m
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PositionListTableViewCell.h"
#import "XHBDealConst.h"


@implementation PositionListTableViewCell
{
    //列表名字与编码
    UILabel *lb_name;
    //方向
    UILabel *lb_OrderLongShort;
    //时间
    UILabel *lb_time;
    //建仓价文本
    UILabel *lb_tit_OrderPrice;
    //建仓价
    UILabel *lb_OrderPrice;
    //箭头图片
    UIImageView *arrowImg;
    //平仓价标题
    UILabel *lb_tit_OrderClosePrice;
    //平仓价
    UILabel *lb_OrderClosePrice;
    //浮动盈亏标题
    UILabel *lb_tit_fT;
    //浮动盈亏
    UILabel *lb_fT;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *Identifier = @"Identifier";
    PositionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[PositionListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
        //cell箭头图片
        UIImageView *cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, (positionList_tableView_cellHeight-16)/2.0, 16, 16)];
        cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
        [cell.contentView addSubview:cellindimg];
    }
    
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = GXLightLineColor;
    
    return cell;
}

- (void)setPModel:(XHBTradePositionModel *)pModel {
   
    
    //方向
    if(!lb_OrderLongShort)
    {
        lb_OrderLongShort=[[UILabel alloc]init];
        lb_OrderLongShort.font = GXFONT_PingFangSC_Regular(14);
        lb_OrderLongShort.textColor = [UIColor whiteColor];
        lb_OrderLongShort.textAlignment=NSTextAlignmentCenter;
        lb_OrderLongShort.layer.masksToBounds=YES;
        lb_OrderLongShort.layer.cornerRadius=2;
        [self.contentView addSubview:lb_OrderLongShort];
    }
    lb_OrderLongShort.text = [NSString stringWithFormat:@"%@",pModel.cmd_str];
    lb_OrderLongShort.backgroundColor=pModel.cmd_BackgColor;
    lb_OrderLongShort.frame=CGRectMake(15, 15 + (25-18)/2.0, 35, 18);
    

    
    
    //名字
    if(!lb_name)
    {
        lb_name=[[UILabel alloc]init];
        lb_name.font = GXFONT_PingFangSC_Regular(16);
        lb_name.textColor = GXBlack_priceNameColor;
        [self.contentView addSubview:lb_name];
    }
    lb_name.text = [NSString stringWithFormat:@"%@",pModel.symbol];
    [lb_name sizeToFit];
    lb_name.frame=CGRectMake(lb_OrderLongShort.frame.origin.y+45, 15, lb_name.frame.size.width, 25);
    

    
    //时间
    if(!lb_time)
    {
        lb_time=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-155, lb_name.frame.origin.y, 140, lb_name.frame.size.height)];
        lb_time.font = GXFONT_PingFangSC_Regular(12);
        lb_time.textColor = GXGray_priceNameColor;
        lb_time.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lb_time];
    }
    lb_time.text =pModel.openTime;
    

    //建仓价文本标题
    if(!lb_tit_OrderPrice)
    {
        lb_tit_OrderPrice=[[UILabel alloc]initWithFrame:CGRectMake(15, lb_name.frame.origin.y+lb_name.frame.size.height+10, 60, 20)];
        lb_tit_OrderPrice.font = GXFONT_PingFangSC_Regular(14);
        lb_tit_OrderPrice.textColor = GXGray_priceTitleColor;
        lb_tit_OrderPrice.textAlignment=NSTextAlignmentLeft;
        lb_tit_OrderPrice.text=@"建仓价";
        [self.contentView addSubview:lb_tit_OrderPrice];
    }
    
    //建仓价
    if(!lb_OrderPrice)
    {
        lb_OrderPrice=[[UILabel alloc]initWithFrame:CGRectMake(lb_tit_OrderPrice.frame.origin.x, lb_tit_OrderPrice.frame.origin.y+lb_tit_OrderPrice.frame.size.height + 3, 60, 20)];
        lb_OrderPrice.font = GXFONT_PingFangSC_Medium(14);
        lb_OrderPrice.textColor = GXBlack_priceNameColor;
        lb_OrderPrice.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lb_OrderPrice];
    }
    lb_OrderPrice.text=pModel.openPrice;
    
    
    //箭头
    if(!arrowImg)
    {
        arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(lb_OrderPrice.frame.origin.x+lb_OrderPrice.frame.size.width+WidthScale_IOS6(10), lb_OrderPrice.frame.origin.y, 20, 20)];
        arrowImg.image=[UIImage imageNamed:@"positionListArrow"];
        [self.contentView addSubview:arrowImg];
    }
    
    
    //平仓价文本标题
    if(!lb_tit_OrderClosePrice)
    {
        lb_tit_OrderClosePrice=[[UILabel alloc]initWithFrame:CGRectMake(arrowImg.frame.origin.x+arrowImg.frame.size.width+WidthScale_IOS6(20), lb_tit_OrderPrice.frame.origin.y, lb_tit_OrderPrice.frame.size.width, lb_tit_OrderPrice.frame.size.height)];
        lb_tit_OrderClosePrice.font = GXFONT_PingFangSC_Regular(14);
        lb_tit_OrderClosePrice.textColor = GXGray_priceTitleColor;
        lb_tit_OrderClosePrice.textAlignment=NSTextAlignmentLeft;
        lb_tit_OrderClosePrice.text=@"现价";
        [self.contentView addSubview:lb_tit_OrderClosePrice];
    }
    
    //平仓价
    if(!lb_OrderClosePrice)
    {
        lb_OrderClosePrice=[[UILabel alloc]initWithFrame:CGRectMake(lb_tit_OrderClosePrice.frame.origin.x, lb_tit_OrderClosePrice.frame.origin.y+lb_tit_OrderClosePrice.frame.size.height + 3, lb_OrderPrice.frame.size.width, 20)];
        lb_OrderClosePrice.font = GXFONT_PingFangSC_Medium(14);
        lb_OrderClosePrice.textColor = GXBlack_priceNameColor;
        lb_OrderClosePrice.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lb_OrderClosePrice];
    }
    lb_OrderClosePrice.text=pModel.closePrice;
    
    
    
    //浮动盈亏标题
    if(!lb_tit_fT)
    {
        lb_tit_fT=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-WidthScale_IOS6(110)-WidthScale_IOS6(50), lb_tit_OrderClosePrice.frame.origin.y,WidthScale_IOS6(110),lb_tit_OrderClosePrice.frame.size.height)];
        lb_tit_fT.font = GXFONT_PingFangSC_Regular(14);
        lb_tit_fT.textColor = GXGray_priceTitleColor;
        lb_tit_fT.textAlignment=NSTextAlignmentRight;
        lb_tit_fT.text=@"浮动盈亏";
        [self.contentView addSubview:lb_tit_fT];
        
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(lb_tit_fT.frame.origin.x+10, lb_tit_fT.frame.origin.y, 1, 35)];
        line.backgroundColor=GXRGBColor(242, 243, 243);
        [self.contentView addSubview:line];
    }
    
    //浮动盈亏
    if(!lb_fT)
    {
        lb_fT=[[UILabel alloc]initWithFrame:CGRectMake(lb_tit_fT.frame.origin.x, lb_tit_fT.frame.origin.y+lb_tit_fT.frame.size.height + 3, lb_tit_fT.frame.size.width, 20)];
        lb_fT.font = GXFONT_PingFangSC_Medium(14);
        lb_fT.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lb_fT];
    }
    [lb_fT setAttributedText:pModel.OrderProfit_att];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
