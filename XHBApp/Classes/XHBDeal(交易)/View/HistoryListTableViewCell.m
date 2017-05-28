//
//  HistoryListTableViewCell.m
//  XHBApp
//
//  Created by shenqilong on 16/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "HistoryListTableViewCell.h"
#import "XHBDealConst.h"
#import "XHBTradePositionModel.h"

@implementation HistoryListTableViewCell
{
    //列表名字与编码
    UILabel *lb_name;
    //标签1
    UILabel *lb_tag1;
    //标签2
    UILabel *lb_tag2;
    //订单号
    UILabel *lb_LocalOrderID;
    //时间标题
    UILabel *lb_tit_time;
    //时间
    UILabel *lb_time;
    //建仓价标题
    UILabel *lb_tit_OrderPrice;
    //建仓价
    UILabel *lb_OrderPrice;
    //平仓价标题
    UILabel *lb_tit_OrderClosePrice;
    //平仓价
    UILabel *lb_OrderClosePrice;
    
    UIImageView *cellindimg;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *Identifier = @"Identifier";
    HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[HistoryListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = GXLightLineColor;
    
    return cell;
}

- (void)setHModel:(XHBTradePositionModel *)hModel {
    
    
    //标签1
    if(!lb_tag1)
    {
        lb_tag1=[[UILabel alloc]init];
        lb_tag1.font = GXFONT_PingFangSC_Regular(14);
        lb_tag1.textColor = [UIColor whiteColor];
        lb_tag1.textAlignment=NSTextAlignmentCenter;
        lb_tag1.layer.masksToBounds=YES;
        lb_tag1.layer.cornerRadius=2;
        [self.contentView addSubview:lb_tag1];
    }
    lb_tag1.text = [NSString stringWithFormat:@"%@",hModel.historyList_tag];
    lb_tag1.backgroundColor=hModel.historyList_tagBg;
    
    CGSize s=[lb_tag1.text boundingWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) FontSize:14];
    lb_tag1.frame=CGRectMake(15, 15, s.width+6, 19);
    
    lb_tag1.hidden=NO;
    if(hModel.historyList_tag.length==0)
    {
        lb_tag1.hidden=YES;
    }
    
    //标签2
    if(!lb_tag2)
    {
        lb_tag2=[[UILabel alloc]init];
        lb_tag2.font = GXFONT_PingFangSC_Regular(14);
        lb_tag2.textColor = [UIColor whiteColor];
        lb_tag2.textAlignment=NSTextAlignmentCenter;
        lb_tag2.layer.masksToBounds=YES;
        lb_tag2.layer.cornerRadius=2;
        [self.contentView addSubview:lb_tag2];
    }
    lb_tag2.text = [NSString stringWithFormat:@"%@",hModel.cmd_str];
    lb_tag2.backgroundColor=hModel.cmd_BackgColor;
    
    s=[lb_tag2.text boundingWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) FontSize:14];
    
    lb_tag2.frame=CGRectMake(lb_tag1.frame.origin.x+lb_tag1.frame.size.width+6, 15, s.width+6, 19);
    if(hModel.historyList_tag.length==0)
    {
        lb_tag2.frame=CGRectMake(15, 15, s.width+6, 19);
    }
    
    
    
    
    
    //名字
    if(!lb_name)
    {
        lb_name=[[UILabel alloc]init];
        lb_name.font = GXFONT_PingFangSC_Regular(16);
        lb_name.textColor = GXBlack_priceNameColor;
        [self.contentView addSubview:lb_name];
    }
    lb_name.text = [NSString stringWithFormat:@"%@",hModel.hisName];
    [lb_name sizeToFit];
    lb_name.frame=CGRectMake(lb_tag2.frame.origin.x+lb_tag2.frame.size.width+10, 0, lb_name.frame.size.width, 49);
    
    
    
    
    
    //订单号
    if(!lb_LocalOrderID)
    {
        lb_LocalOrderID=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-135, lb_name.frame.origin.y, 120, lb_name.frame.size.height)];
        lb_LocalOrderID.font = GXFONT_PingFangSC_Regular(12);
        lb_LocalOrderID.textColor = GXGray_priceDetailTrade_TextColor;
        lb_LocalOrderID.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lb_LocalOrderID];
    }
    lb_LocalOrderID.text =[NSString stringWithFormat:@"订单号：%@",hModel.ticket];
    
    
    //左边标题
    if(!lb_tit_OrderPrice)
    {
        lb_tit_OrderPrice=[[UILabel alloc]initWithFrame:CGRectMake(15, lb_name.frame.origin.y+lb_name.frame.size.height, 70, 20)];
        lb_tit_OrderPrice.font = GXFONT_PingFangSC_Regular(14);
        lb_tit_OrderPrice.textColor = GXGray_priceTitleColor;
        lb_tit_OrderPrice.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lb_tit_OrderPrice];
    }
    lb_tit_OrderPrice.text=hModel.left_tit;
    
    
    //左边内容
    if(!lb_OrderPrice)
    {
        lb_OrderPrice=[[UILabel alloc]initWithFrame:CGRectMake(lb_tit_OrderPrice.frame.origin.x, lb_tit_OrderPrice.frame.origin.y+lb_tit_OrderPrice.frame.size.height + 3, 70, 20)];
        lb_OrderPrice.font = GXFONT_PingFangSC_Medium(14);
        lb_OrderPrice.textAlignment=NSTextAlignmentLeft;
        lb_OrderPrice.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:lb_OrderPrice];
    }
    lb_OrderPrice.attributedText=hModel.left_val_att;
    
    
   
    //右边标题
    if(!lb_tit_time)
    {
        lb_tit_time=[[UILabel alloc]init];
        lb_tit_time.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lb_tit_time];
    }
    lb_tit_time.frame=CGRectMake(GXScreenWidth-120-WidthScale_IOS6(40), lb_tit_OrderPrice.frame.origin.y,120,lb_tit_OrderPrice.frame.size.height);
    lb_tit_time.text=hModel.right_tit;
    lb_tit_time.font = GXFONT_PingFangSC_Regular(14);
    lb_tit_time.textColor = GXGray_priceTitleColor;
    if([lb_tit_time.text isEqualToString:@"已撤单"])
    {
        lb_tit_time.frame=CGRectMake(GXScreenWidth-120-WidthScale_IOS6(40), lb_tit_OrderPrice.frame.origin.y+8,120,lb_tit_OrderPrice.frame.size.height);
        lb_tit_time.textColor = GXRGBColor(165, 165, 165);
    }
    
    //右边内容
    if(!lb_time)
    {
        lb_time=[[UILabel alloc]init];
        lb_time.font = GXFONT_PingFangSC_Regular(12);
        lb_time.textAlignment=NSTextAlignmentRight;
        lb_time.textColor = GXBlack_priceNameColor;
        [self.contentView addSubview:lb_time];
    }
    lb_time.text=hModel.right_value;
    [lb_time sizeToFit];
    lb_time.frame=CGRectMake(GXScreenWidth-lb_time.frame.size.width-WidthScale_IOS6(40), lb_OrderPrice.frame.origin.y, lb_time.frame.size.width, 20);
    lb_time.hidden=NO;
    if([lb_tit_time.text isEqualToString:@"已撤单"])
    {
        lb_time.hidden=YES;
    }
    
    
    
    //中间标题
    if(!lb_tit_OrderClosePrice)
    {
        float w=lb_time.frame.origin.x-lb_OrderPrice.frame.origin.x-lb_OrderPrice.frame.size.width;
        
        lb_tit_OrderClosePrice=[[UILabel alloc]initWithFrame:CGRectMake(lb_OrderPrice.frame.origin.x+lb_OrderPrice.frame.size.width, lb_tit_OrderPrice.frame.origin.y, w, 20)];
        lb_tit_OrderClosePrice.font = GXFONT_PingFangSC_Regular(14);
        lb_tit_OrderClosePrice.textColor = GXGray_priceTitleColor;
        lb_tit_OrderClosePrice.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:lb_tit_OrderClosePrice];
    }
    lb_tit_OrderClosePrice.text=hModel.middle_tit;
 
    
    //中间内容
    if(!lb_OrderClosePrice)
    {
        lb_OrderClosePrice=[[UILabel alloc]initWithFrame:CGRectMake(lb_tit_OrderClosePrice.frame.origin.x, lb_OrderPrice.frame.origin.y, lb_tit_OrderClosePrice.frame.size.width, 20)];
        lb_OrderClosePrice.font = GXFONT_PingFangSC_Medium(14);
        lb_OrderClosePrice.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:lb_OrderClosePrice];
    }
    lb_OrderClosePrice.attributedText=hModel.middle_val_att;
    
    
    
    //cell箭头图片
    if(!cellindimg)
    {
        cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, lb_tit_OrderPrice.frame.origin.y+10, 16, 16)];
        cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
        [self.contentView addSubview:cellindimg];
    }
    cellindimg.hidden=YES;
    if([hModel.cmd intValue]==0||[hModel.cmd intValue]==1||[hModel.cmd intValue]==2||[hModel.cmd intValue]==3||[hModel.cmd intValue]==4||[hModel.cmd intValue]==5)
    {
        cellindimg.hidden=NO;
    }
    
 
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
