//
//  PriceDetailTradeView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceDetailTradeView.h"
#import "PriceMarketModel.h"
#import "PriceUserTradeMarginModel.h"
#import "PriceDetailTradeViewAmountButton.h"

#define tradeViewTag_height_lb 22//做多还是做空标签的高度
#define tradeViewTag_height_line 3//红或绿线的高度
#define tradeViewRow_height_big 52//信息行高度大一点的
#define tradeViewRow_height_small 42//信息行高度小一点的
#define tradeViewDoneBtn_height 45//确认按钮高度

#define tradeView_lb_tit_openOrderTip_height 30//下单点差说明lb的高度

//交易详细信息操作框的高度,上面的相加
#define tradeView_detailT_height (tradeViewRow_height_big*4 + tradeViewRow_height_small+tradeView_lb_tit_openOrderTip_height + tradeViewDoneBtn_height+tradeViewTag_height_line+tradeViewTag_height_lb)


//手数增加和减少button图片的宽和高
#define tradeView_btn_contract_width 45
#define tradeView_btn_contract_height 45

//传接口用 做多传0 做空传1
#define uploadOrderType (tradeTypeindex==0?1:0)

@implementation PriceDetailTradeView
{
    PriceMarketModel *priceModel;
    NSInteger tradeTypeindex;//0做空 1做多
    
    UIView *detailTradeV_root;//操作内容区域总和view
    UIView *detailTradeV;//除了最上面的做多做空标签,下面的view
    
    //做多做空标题
    UILabel *lb_tit_sellOrBuy;
    //做多做空标题线
    UIImageView *lb_tit_sellOrBuy_line;
   
    //买入/卖出价格标题
    UILabel *lb_tit_sellOrBuyPrice;
    //买入/卖出报价
    UILabel *lb_sellOrBuyPrice;
    
    //交易手数标题
    UILabel *lb_tit_contract;
    //交易手数文本
    UITextField *tf_contract;
    //交易手数减少button
    PriceDetailTradeViewAmountButton *btn_contract_down;
    //交易手数增加button
    PriceDetailTradeViewAmountButton *btn_contract_up;
    
    
    //共多少手 占用保证金
    UILabel *lb_contractAndMargin;
    
    
    //可用预付款
    UILabel *lb_freemargin;
    //入金button
    UIButton *btn_inGold;
    
    //允许点差button
    UIButton *btn_spreadAllow;
    //允许点差标题
    UILabel *lb_tit_spread;
    //允许点差问好button
    UIButton *btn_spreadQuestion;
   
    //下单说明标题
    UILabel *lb_tit_openOrderTip;
    
    //确认按钮
    UIButton *btn_submit;
}
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.alpha=0;
        
        //黑色背景以及关闭
        UIButton *backgv=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        backgv.backgroundColor=[UIColor colorWithRed:32.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:0.6];
        [backgv addTarget:self action:@selector(closeTradeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgv];
        
        
        detailTradeV_root=[[UIView alloc]initWithFrame:CGRectMake(0, GXScreenHeight, GXScreenWidth, tradeView_detailT_height)];
        detailTradeV_root.backgroundColor=[UIColor clearColor];
        [self addSubview:detailTradeV_root];
        
        
        detailTradeV=[[UIView alloc]initWithFrame:CGRectMake(0, tradeViewTag_height_line+tradeViewTag_height_lb, GXScreenWidth, tradeView_detailT_height-tradeViewTag_height_line+tradeViewTag_height_lb)];
        detailTradeV.backgroundColor=[UIColor whiteColor];
        [detailTradeV_root addSubview:detailTradeV];
        
        
        //做多做空标题
        lb_tit_sellOrBuy=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, tradeViewTag_height_lb)];
        lb_tit_sellOrBuy.layer.masksToBounds=YES;
        lb_tit_sellOrBuy.layer.cornerRadius=2;
        lb_tit_sellOrBuy.textAlignment=NSTextAlignmentCenter;
        lb_tit_sellOrBuy.font=GXFONT_PingFangSC_Regular(14);
        lb_tit_sellOrBuy.textColor=[UIColor whiteColor];
        [detailTradeV_root addSubview:lb_tit_sellOrBuy];
        
        //线
        lb_tit_sellOrBuy_line=[[UIImageView alloc]initWithFrame:CGRectMake(0, lb_tit_sellOrBuy.frame.origin.y+lb_tit_sellOrBuy.frame.size.height, GXScreenWidth, tradeViewTag_height_line)];
        [detailTradeV_root addSubview:lb_tit_sellOrBuy_line];
        
        
        
        
        //买入/卖出价格标题
        lb_tit_sellOrBuyPrice=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, tradeViewRow_height_big-1)];
        lb_tit_sellOrBuyPrice.font=GXFONT_PingFangSC_Regular(14);
        lb_tit_sellOrBuyPrice.textColor=GXBlack_priceNameColor;
        [detailTradeV addSubview:lb_tit_sellOrBuyPrice];
        
        //买入/卖出报价
        lb_sellOrBuyPrice=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-200-15, 0, 200, tradeViewRow_height_big-1)];
        lb_sellOrBuyPrice.textAlignment=NSTextAlignmentRight;
        [detailTradeV addSubview:lb_sellOrBuyPrice];
        
        //灰线
        UIImageView *line_img1=[[UIImageView alloc]initWithFrame:CGRectMake(15, lb_tit_sellOrBuyPrice.frame.origin.y+lb_tit_sellOrBuyPrice.frame.size.height, GXScreenWidth-15, 1)];
        line_img1.backgroundColor=GXGrayLineColor;
        [detailTradeV addSubview:line_img1];
        
        
        
        //交易手数标题
        lb_tit_contract=[[UILabel alloc]initWithFrame:CGRectMake(15, tradeViewRow_height_big*1, 150, tradeViewRow_height_big-1)];
        lb_tit_contract.font=GXFONT_PingFangSC_Regular(14);
        lb_tit_contract.textColor=GXBlack_priceNameColor;
        lb_tit_contract.text=@"交易手数（最大3手）";
        [detailTradeV addSubview:lb_tit_contract];
        
        //交易手数增加button
        btn_contract_up=[[PriceDetailTradeViewAmountButton alloc]initWithFrame:CGRectMake(GXScreenWidth-tradeView_btn_contract_width, lb_tit_contract.frame.origin.y+ (tradeViewRow_height_big-tradeView_btn_contract_height)/2.0, tradeView_btn_contract_width, tradeView_btn_contract_height) style:OrderAmountButtonStyleUp];
        [btn_contract_up addTarget:self action:@selector(btn_contractPlus) forControlEvents:UIControlEventTouchUpInside];
        [btn_contract_up addLongPressGestureRecognizer:self action:@selector(btn_contractPlus_long)];
        [detailTradeV addSubview:btn_contract_up];
        
        
        
        
        //交易手数文本
        tf_contract=[[UITextField alloc]initWithFrame:CGRectMake(btn_contract_up.frame.origin.x-66-2, lb_tit_contract.frame.origin.y+ (tradeViewRow_height_big-30)/2.0, 66, 30)];//5是缝隙宽
        tf_contract.font=GXFONT_PingFangSC_Regular(14);
        tf_contract.textAlignment=NSTextAlignmentCenter;
        tf_contract.textColor=GXMainColor;
        tf_contract.layer.masksToBounds=YES;
        tf_contract.layer.cornerRadius=1;
        tf_contract.backgroundColor=GXGray_priceDetailTrade_TextFieldBackgColor;
        tf_contract.clearButtonMode = UITextFieldViewModeNever;
        [tf_contract setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_contract setBorderStyle:UITextBorderStyleNone];
        [tf_contract setKeyboardType:UIKeyboardTypeDecimalPad];
        [tf_contract setReturnKeyType:UIReturnKeyDone];
        tf_contract.delegate=self;
        tf_contract.text=[GXUserInfoTool getUserLastTradeContract];
        [detailTradeV addSubview:tf_contract];
        
        //交易手数减少button
        btn_contract_down=[[PriceDetailTradeViewAmountButton alloc]initWithFrame:CGRectMake(tf_contract.frame.origin.x-tradeView_btn_contract_width-2, lb_tit_contract.frame.origin.y+ (tradeViewRow_height_big-tradeView_btn_contract_height)/2.0, tradeView_btn_contract_width, tradeView_btn_contract_height) style:OrderAmountButtonStyleDown];
        [btn_contract_down addTarget:self action:@selector(btn_contractMin) forControlEvents:UIControlEventTouchUpInside];
        [btn_contract_down addLongPressGestureRecognizer:self action:@selector(btn_contractMin_long)];
        [detailTradeV addSubview:btn_contract_down];
        
        //灰线
        UIImageView *line_img2=[[UIImageView alloc]initWithFrame:CGRectMake(15, lb_tit_contract.frame.origin.y+lb_tit_contract.frame.size.height, GXScreenWidth-15, 1)];
        line_img2.backgroundColor=GXGrayLineColor;
        [detailTradeV addSubview:line_img2];
        
        
        
        //共多少手 占用保证金
        lb_contractAndMargin=[[UILabel alloc]initWithFrame:CGRectMake(0, tradeViewRow_height_big*2, GXScreenWidth-15, tradeViewRow_height_big)];
        lb_contractAndMargin.font=GXFONT_PingFangSC_Regular(14);
        lb_contractAndMargin.textAlignment=NSTextAlignmentRight;
        [detailTradeV addSubview:lb_contractAndMargin];
        [self setLbContractAndMargin];//初赋值
        
        
        //灰线
        UIImageView *line_img3=[[UIImageView alloc]initWithFrame:CGRectMake(15, tradeViewRow_height_big*3-1, GXScreenWidth-15, 1)];
        line_img3.backgroundColor=GXGrayLineColor;
        [detailTradeV addSubview:line_img3];
        
        
        
        //入金button
        btn_inGold=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-70, tradeViewRow_height_big*3, 70, tradeViewRow_height_big)];
        btn_inGold.titleLabel.font=GXFONT_PingFangSC_Regular(14);
        NSMutableAttributedString *inGold_attri=[[NSMutableAttributedString alloc]initWithString:@"[入金]"];
        [inGold_attri addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(0, 1)];
        [inGold_attri addAttribute:NSForegroundColorAttributeName value:GXMainColor range:NSMakeRange(1, 2)];
        [inGold_attri addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(3, 1)];
        [btn_inGold setAttributedTitle:inGold_attri forState:UIControlStateNormal];
        inGold_attri=nil;
        [btn_inGold addTarget:self action:@selector(btn_inGold_Click) forControlEvents:UIControlEventTouchUpInside];
        [detailTradeV addSubview:btn_inGold];
        
        //可用预付款
        lb_freemargin=[[UILabel alloc]initWithFrame:CGRectMake(btn_inGold.frame.origin.x-300+10, btn_inGold.frame.origin.y, 300, btn_inGold.frame.size.height)];
        lb_freemargin.textAlignment=NSTextAlignmentRight;
        lb_freemargin.font=GXFONT_PingFangSC_Regular(14);
        [detailTradeV addSubview:lb_freemargin];
        
        //灰线
        UIImageView *line_img4=[[UIImageView alloc]initWithFrame:CGRectMake(15, btn_inGold.frame.origin.y+btn_inGold.frame.size.height, GXScreenWidth-15, 1)];
        line_img4.backgroundColor=GXGrayLineColor;
        [detailTradeV addSubview:line_img4];
        
        
        
        //允许点差button
        btn_spreadAllow=[[UIButton alloc]initWithFrame:CGRectMake(0, tradeViewRow_height_big*4, tradeViewRow_height_small, tradeViewRow_height_small)];
        [btn_spreadAllow setImage:[UIImage imageNamed:@"tradeViewMake_btnSelect"] forState:UIControlStateNormal];
        [detailTradeV addSubview:btn_spreadAllow];
        
        //允许点差标题
        lb_tit_spread=[[UILabel alloc]init];
        lb_tit_spread.font=GXFONT_PingFangSC_Regular(14);
        lb_tit_spread.textColor=GXGray_priceDetailTrade_TextColor;
        lb_tit_spread.text=@"允许成交价和下单价的最大差价100";
        [lb_tit_spread sizeToFit];
        lb_tit_spread.frame=CGRectMake(btn_spreadAllow.frame.origin.x+btn_spreadAllow.frame.size.width, btn_spreadAllow.frame.origin.y, lb_tit_spread.frame.size.width, tradeViewRow_height_small);
        [detailTradeV addSubview:lb_tit_spread];
        
        //允许点差问好button
        btn_spreadQuestion=[[UIButton alloc]initWithFrame:CGRectMake(lb_tit_spread.frame.origin.x+lb_tit_spread.frame.size.width+5, tradeViewRow_height_big*4, tradeViewRow_height_small, tradeViewRow_height_small)];
        [btn_spreadQuestion setImage:[UIImage imageNamed:@"tradeViewMake_question"] forState:UIControlStateNormal];
        [btn_spreadQuestion addTarget:self action:@selector(btn_spreadQuestion_Click) forControlEvents:UIControlEventTouchUpInside];
        [detailTradeV addSubview:btn_spreadQuestion];
        
        //下单说明文本
        lb_tit_openOrderTip=[[UILabel alloc]init];
        lb_tit_openOrderTip.font=GXFONT_PingFangSC_Regular(12);
        lb_tit_openOrderTip.textColor=GXGray_priceDetailTrade_TextColor;
        lb_tit_openOrderTip.text=@"由于网络延迟，订单最终成交价格以服务器成交价格为准";
        lb_tit_openOrderTip.textAlignment=NSTextAlignmentCenter;
        lb_tit_openOrderTip.backgroundColor=GXGrayLineColor;
        lb_tit_openOrderTip.frame=CGRectMake(0, lb_tit_spread.frame.origin.y+tradeViewRow_height_small, GXScreenWidth, tradeView_lb_tit_openOrderTip_height);
        [detailTradeV addSubview:lb_tit_openOrderTip];
        
        
        
        //确认按钮
        btn_submit=[[UIButton alloc]initWithFrame:CGRectMake(0, lb_tit_openOrderTip.frame.origin.y+lb_tit_openOrderTip.frame.size.height, GXScreenWidth, tradeViewDoneBtn_height)];
        btn_submit.titleLabel.font=GXFONT_PingFangSC_Regular(16);
        [btn_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_submit setTitle:@"确认" forState:UIControlStateNormal];
        [btn_submit addTarget:self action:@selector(btn_submit_Click) forControlEvents:UIControlEventTouchUpInside];
        [detailTradeV addSubview:btn_submit];
        
    }
    return self;
}

-(void)closeTradeView
{
    [tf_contract resignFirstResponder];
    
    //移出操作view
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect r=detailTradeV_root.frame;
        r.origin.y=GXScreenHeight;
        detailTradeV_root.frame=r;
        
        self.alpha=0;
    }];
}

-(void)setTradeTypeIndex:(NSInteger) tradeIndex
{
    tradeTypeindex=tradeIndex;
    
    [self setColorAndTit];
    
    [self setPriceBuyOrSell];
    
    
    //移进操作view
    [UIView animateWithDuration:0.2 animations:^{
    
        CGRect r=detailTradeV_root.frame;
        r.origin.y=self.frame.size.height-tradeView_detailT_height;
        detailTradeV_root.frame=r;
        
        self.alpha=1;
    }];
}

//赋值颜色
-(void)setColorAndTit
{
    NSString *tit;
    UIColor *cor;
    if(tradeTypeindex==0)
    {
        tit=@"做空";
        cor=GXGreen_priceBackgColor;
        
    }else
    {
        tit=@"做多";
        cor=GXRed_priceBackgColor;
    }
    lb_tit_sellOrBuy_line.backgroundColor=cor;
    
    lb_tit_sellOrBuy.text=tit;
    lb_tit_sellOrBuy.backgroundColor=cor;
    
    lb_tit_sellOrBuyPrice.text=[tit stringByAppendingString:@"价格"];
    
    btn_submit.backgroundColor=cor;
}

//赋值价格
-(void)setPriceBuyOrSell
{
    NSString *price=[self readOrderPrice];
    
    NSString *lb_sellOrBuyPrice_string=[NSString stringWithFormat:@"$%@ 以最终成交价格为准",price];
    NSMutableAttributedString *lb_sellOrBuyPrice_attri=[[NSMutableAttributedString alloc]initWithString:lb_sellOrBuyPrice_string];
    [lb_sellOrBuyPrice_attri addAttribute:NSForegroundColorAttributeName value:GXMainColor range:NSMakeRange(0, price.length+1)];
    [lb_sellOrBuyPrice_attri addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(price.length+1, lb_sellOrBuyPrice_string.length-price.length-1)];
    [lb_sellOrBuyPrice_attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(14) range:NSMakeRange(0, price.length+1)];
    [lb_sellOrBuyPrice_attri addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(12) range:NSMakeRange(price.length+1, lb_sellOrBuyPrice_string.length-price.length-1)];
    [lb_sellOrBuyPrice setAttributedText:lb_sellOrBuyPrice_attri];
    
    lb_sellOrBuyPrice_attri=nil;
}

-(NSString *)readOrderPrice
{
    NSString *price;
    if(tradeTypeindex==0)
    {
        price=priceModel.buy;
        
    }else
    {
        price=priceModel.sell;
    }
    
    return price;
}

-(void)setPriceShowView:(PriceMarketModel*)marketModel
{
    priceModel=marketModel;
    
    [self setPriceBuyOrSell];
    
}

//更新用户可用款等信息
-(void)setPriceUserTradeMarginModel:(PriceUserTradeMarginModel *)tradeModel
{
    self.marginModel=tradeModel;
    
    lb_freemargin.attributedText=tradeModel.userFreeMargin_att1;
    
    tradeModel.userFreeMargin_att1=nil;//有必要制为nil
}

//更新共多少手，占用多少保证金
-(void)setLbContractAndMargin
{
    NSString *str1=@"共";
    NSString *str2=[NSString stringWithFormat:@"%.2f",[tf_contract.text floatValue]];
    tf_contract.text=str2;
    NSString *str3=@"手    预付款： ";
    NSString *str4=[NSString stringWithFormat:@"$%.2f",[self compleUseMargin]];
    
    NSString *lbText=[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
    
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:lbText];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(0, str1.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXBlack_priceNameColor range:NSMakeRange(str1.length, str2.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXGray_priceDetailTrade_TextColor range:NSMakeRange(str2.length+str1.length,str3.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:GXMainColor range:NSMakeRange(str3.length+str2.length+str1.length, str4.length)];
    
    [lb_contractAndMargin setAttributedText:attStr];
  
    attStr=nil;
}

//计算占用保证金
-(float)compleUseMargin
{
    return [tf_contract.text floatValue]*1000;
}

-(void)btn_contractPlus
{
    tf_contract.text=[NSString stringWithFormat:@"%.2f",[tf_contract.text floatValue]+0.01];
    
    if([tf_contract.text floatValue]>=3)
    {
        tf_contract.text=@"3.00";
    }
    
    [self setLbContractAndMargin];
}

-(void)btn_contractMin
{
    tf_contract.text=[NSString stringWithFormat:@"%.2f",[tf_contract.text floatValue]-0.01];
    
    if([tf_contract.text floatValue]<=0)
    {
        tf_contract.text=@"0.00";
    }
    
    [self setLbContractAndMargin];
}

-(void)btn_contractPlus_long
{
    [self btn_contractPlus];
}

-(void)btn_contractMin_long
{
    [self btn_contractMin];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([tf_contract.text floatValue]>=3)
    {
        tf_contract.text=@"3.00";
    }
    if([tf_contract.text floatValue]<=0)
    {
        tf_contract.text=@"0.00";
    }
    [self setLbContractAndMargin];
}

#pragma mark - 确认
-(void)btn_submit_Click
{
    float userMargin=[self compleUseMargin];
    
    if(userMargin>[self.marginModel.FreeMargin floatValue])
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"您的可用预付款不足，请及时入金" delegate:self cancelButtonTitle:@"立即入金" otherButtonTitles:@"知道了",nil];
        al.tag=1000;
        [al show];
        
        return;
    }
    
    [self removeTipView];
    [self banClickView];
    [self showLoadingWithTitle:@"正在提交"];
    
    

    NSDictionary *par=@{@"AppSessionId":[GXUserInfoTool getAppSessionId],
                        @"OrderPrice":[self readOrderPrice],
                        @"OrderType":[NSString stringWithFormat:@"%d",uploadOrderType],
                        @"OrderAmount":[NSString stringWithFormat:@"%.2f",[tf_contract.text floatValue]*100],
                        @"OrderSlippage":@"1",
                        @"OrderSL":@"0",
                        @"OrderTP":@"0",
                        @"InvestmentCode":priceModel.code};
    
    [GXHttpTool POST:GXUrl_openorderinsert parameters:par success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            [self removeTipView];
            [self showSuccessWithTitle:@"建仓成功"];
            
            //保存交易手数
            [GXUserInfoTool saveUserLastTradeContract:tf_contract.text];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self oderinserok];
            });
        }
        else
        {
            [self removeTipView];
            [self showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self removeTipView];
        [self showFailWithTitle:@"提交失败"];
    }];
}

-(void)oderinserok
{
    [self closeTradeView];
    [delegate priceDetailTradeViewDelegate_openOrderInsertOk];
}

#pragma mark - 问号
-(void)btn_spreadQuestion_Click
{
    [delegate priceDetailTradeViewDelegate_question];
}

#pragma mark - 入金
-(void)btn_inGold_Click
{
    [self closeTradeView];
    [delegate priceDetailTradeViewDelegate_inGold];
}

- (void)gxAlertView:(GXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self btn_inGold_Click];
    }
}


@end
