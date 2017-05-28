//
//  PriceMarketTableViewCell.m
//  XHBApp
//
//  Created by shenqilong on 16/11/7.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceMarketTableViewCell.h"
#import "XHBDealConst.h"



@implementation PriceMarketTableViewCell
{
    //列表名字与编码
    UILabel *lb_name;
    //时间
    UILabel *lb_time;
    //做空背景
    UIView *sellBackg;
    //做多背景
    UIView *buyBackg;
    //点差
    UILabel *lb_spread;
    //做空报价
    UILabel *lb_sell;
    //做多报价
    UILabel *lb_buy;
    //做空箭头
    UIImageView *priceListArrow_sell_img;
    //做多箭头
    UIImageView *priceListArrow_buy_img;
    //是否可交易标签
    UIImageView *img_isTrade;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *Identifier = @"Identifier";
    PriceMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
         cell = [[PriceMarketTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = GXLightLineColor;
    
    
    return cell;
}

- (void)setMarketModel:(PriceMarketModel *)marketModel {
    
    //名字
    if(!lb_name)
    {
        lb_name=[[UILabel alloc]initWithFrame:CGRectMake(15, priceList_tableView_cellHeight*0.21, WidthScale_IOS6(priceList_name_width), 25)];
        lb_name.font = GXFONT_PingFangSC_Regular(16);
        lb_name.textColor = GXBlack_priceNameColor;
        [self.contentView addSubview:lb_name];
    }
    lb_name.text = [NSString stringWithFormat:@"%@(%@)",marketModel.customTag1,marketModel.name];

    
    //时间
    if(!lb_time)
    {
        lb_time=[[UILabel alloc]initWithFrame:CGRectMake(15, priceList_tableView_cellHeight*0.64, WidthScale_IOS6(priceList_name_width), 15)];
        lb_time.font = GXFONT_PingFangSC_Regular(12);
        lb_time.textColor = GXGray_priceNameColor;
        [self.contentView addSubview:lb_time];
    }
    lb_time.text =marketModel.quoteTime2;
    
    
    //做空的背景
    if(!sellBackg)
    {
        sellBackg=[[UIView alloc]initWithFrame:CGRectMake(lb_name.frame.origin.x+lb_name.frame.size.width, (priceList_tableView_cellHeight-priceList_sellOrbuyBackground_height)/2.0, WidthScale_IOS6(priceList_sellOrbuyBackground_width), priceList_sellOrbuyBackground_height)];
        sellBackg.layer.masksToBounds=YES;
        sellBackg.layer.cornerRadius=2;
        [self.contentView addSubview:sellBackg];
    }
    sellBackg.backgroundColor=marketModel.sellOrBuy_bgColor;
    
    
    //做多的背景
    if(!buyBackg)
    {
        buyBackg=[[UIView alloc]initWithFrame:CGRectMake(sellBackg.frame.origin.x+sellBackg.frame.size.width+priceListSellOrBuyBg_space, sellBackg.frame.origin.y, WidthScale_IOS6(priceList_sellOrbuyBackground_width), priceList_sellOrbuyBackground_height)];
        buyBackg.backgroundColor=GXRed_priceBackgColor;
        buyBackg.layer.masksToBounds=YES;
        buyBackg.layer.cornerRadius=2;
        [self.contentView addSubview:buyBackg];
    }
    buyBackg.backgroundColor=sellBackg.backgroundColor;
    
    
    //点差
    if(!lb_spread)
    {
        lb_spread=[[UILabel alloc]initWithFrame:CGRectMake(sellBackg.frame.origin.x+sellBackg.frame.size.width-(priceListTable_spread_width-priceListSellOrBuyBg_space)/2.0, sellBackg.frame.origin.y+(priceList_sellOrbuyBackground_height-priceListTable_spread_height)/2.0, priceListTable_spread_width, priceListTable_spread_height)];
        lb_spread.backgroundColor=[UIColor whiteColor];
        lb_spread.layer.masksToBounds=YES;
        lb_spread.layer.cornerRadius=1;
        lb_spread.textAlignment=NSTextAlignmentCenter;
        lb_spread.font=GXFONT_PingFangSC_Regular(12);
        lb_spread.textColor = GXBlack_priceNameColor;
        [self.contentView addSubview:lb_spread];
    }
    lb_spread.text=marketModel.spread;
    
    
    //做空文本报价
    if(!lb_sell)
    {
        lb_sell=[[UILabel alloc]init];
        lb_sell.textColor=[UIColor whiteColor];
        [self.contentView addSubview:lb_sell];
    }
    [lb_sell setAttributedText:marketModel.buy_headLarg];
    marketModel.buy_headLarg=nil;
    [lb_sell sizeToFit];
    lb_sell.frame=CGRectMake(sellBackg.frame.origin.x+(sellBackg.frame.size.width-5-(priceListArrow_width+lb_sell.frame.size.width))/2.0, sellBackg.frame.origin.y, lb_sell.frame.size.width, sellBackg.frame.size.height);//这里的5是文本和箭头整体向左的偏移量
    
    
    //做空箭头
    if(!priceListArrow_sell_img)
    {
        priceListArrow_sell_img=[[UIImageView alloc]init];
        [self.contentView addSubview:priceListArrow_sell_img];
    }
    if(CGColorEqualToColor(sellBackg.backgroundColor.CGColor, GXGreen_priceBackgColor.CGColor))
    {
        priceListArrow_sell_img.image=[UIImage imageNamed:@"priceListArrow2"];
    }else
    {
        priceListArrow_sell_img.image=[UIImage imageNamed:@"priceListArrow"];
    }
    priceListArrow_sell_img.frame=CGRectMake(lb_sell.frame.origin.x+lb_sell.frame.size.width, sellBackg.frame.origin.y+(sellBackg.frame.size.height-priceListArrow_height)/2.0, priceListArrow_width, priceListArrow_height);
    
    
    
    //做多文本报价
    if(!lb_buy)
    {
        lb_buy=[[UILabel alloc]init];
        lb_buy.textColor=[UIColor whiteColor];
        [self.contentView addSubview:lb_buy];
    }
    [lb_buy setAttributedText:marketModel.sell_headLarg];
    marketModel.sell_headLarg=nil;
    [lb_buy sizeToFit];
    lb_buy.frame=CGRectMake(buyBackg.frame.origin.x+(buyBackg.frame.size.width+13-(priceListArrow_width+lb_buy.frame.size.width))/2.0, buyBackg.frame.origin.y, lb_buy.frame.size.width, buyBackg.frame.size.height);//这里的13是文本和箭头整体向右的偏移量
    
    
    //做多箭头
    if(!priceListArrow_buy_img)
    {
        priceListArrow_buy_img=[[UIImageView alloc]init];
        [self.contentView addSubview:priceListArrow_buy_img];
    }
    if(CGColorEqualToColor(buyBackg.backgroundColor.CGColor, GXGreen_priceBackgColor.CGColor))
    {
        priceListArrow_buy_img.image=[UIImage imageNamed:@"priceListArrow2"];
    }else
    {
        priceListArrow_buy_img.image=[UIImage imageNamed:@"priceListArrow"];
    }
    priceListArrow_buy_img.frame=CGRectMake(lb_buy.frame.origin.x+lb_buy.frame.size.width, buyBackg.frame.origin.y+(buyBackg.frame.size.height-priceListArrow_height)/2.0, priceListArrow_width, priceListArrow_height);
    
    
    
    //是否可交易
    if(!img_isTrade)
    {
        img_isTrade=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        img_isTrade.image=[UIImage imageNamed:@"labelTrade"];
        [self.contentView addSubview:img_isTrade];
    }
    img_isTrade.hidden=marketModel.status_hidden;
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
