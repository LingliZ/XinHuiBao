//
//  XHBTimelyTradeViewController.m
//  XHBApp
//
//  Created by shenqilong on 17/2/28.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTimelyTradeViewController.h"
#import "XHBTradeTextFieldView.h"
#import <YYText/YYText.h>
#import "CloseKView.h"
#import "KlineModel.h"
#import "XHBTradeAlertView.h"
#import "XHBTraderUserMaginModel.h"
#import "XHBTradeInfo.h"
#import "XHBPriceDetailViewController.h"
#import "PriceMarketModel.h"
@interface XHBTimelyTradeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listmenu;

    NSMutableDictionary *viewDic;
    
    NSMutableDictionary *postDic;
    

    CloseKView *klineV;
    
    XHBTradeAlertView *tradeAlerV;
    
    
    UIButton *productName;
    UIButton *directionBtn;
    UILabel *sellBuyLabel_little;
    UILabel *sellLabel;
    UILabel *buyLabel;
    UILabel *sLossLabel;
    UILabel *sGainLabel;
    UILabel *orderPriceLabel;
    YYLabel *amount_detail;
    
    PriceMarketModel *marketModel;
    
    
    XHBTradeTextFieldView *tfv0;
    XHBTradeTextFieldView *tfv1;
    XHBTradeTextFieldView *tfv2;
    XHBTradeTextFieldView *tfv3;
}
@end

#define cellHeight1 40
#define cellHeight2 50
#define cellHeight3 85
#define cellHeight4 120

#define tag_tf 788187



@implementation XHBTimelyTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];

        
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-40-105)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.separatorStyle=UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=[UIColor clearColor];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    

    viewDic=[[NSMutableDictionary alloc]init];

    
    postDic=[[NSMutableDictionary alloc]init];

    
    [self setProductNameView];
    [self setKView];
    [self setDirectionView];
    [self setPriceInputView];
    [self setAmountInputView];
    [self setStopLossInputView];
    [self setStopGainInputView];
    [self setPriceLabelAndOrderButtonView];
 
    [self updateSLTPLabelValue];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeVCPriceReresh" object:self.TradeCode userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeVCKLineDateReresh" object:self.TradeCode userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMarginReresh" object:nil userInfo:nil];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    GXLog(@"disappear");
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            return cellHeight2;
        }
        
        return cellHeight4+10;
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            return cellHeight2;
        }
        
        return cellHeight3;
    }
    
    
    
    if(indexPath.row==0)
    {
        return cellHeight4;
    }
    return cellHeight3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
        if(self.isOpen1)
        {
            return 2;
        }
        return 1;
    }
    
    if(section==1)
    {
        if(self.isOpen2)
        {
            return 2;
        }
        return 1;
    }

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell) {
        [cell removeFromSuperview];
        cell=nil;
    }
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];

    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            [cell.contentView addSubview:viewDic[@"productNameView"]];
        }else
        {
            [cell.contentView addSubview:viewDic[@"kView"]];
        }
        
        return cell;
    }

    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            [cell.contentView addSubview:viewDic[@"directionView"]];
        }else
        {
            [cell.contentView addSubview:viewDic[@"PriceInputView"]];
        }
        
        return cell;
    }

    
    if(indexPath.row==0)
    {
        [cell.contentView addSubview:viewDic[@"AmountInputView"]];
    }else if(indexPath.row==1)
    {
        [cell.contentView addSubview:viewDic[@"StopLossInputView"]];
    }
    else if(indexPath.row==2)
    {
        [cell.contentView addSubview:viewDic[@"StopGainInputView"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark -
-(void)setLabelAndTextFieldDefault
{
    tfv0.tradeCode=self.TradeCode;
    tfv2.tradeCode=self.TradeCode;
    tfv3.tradeCode=self.TradeCode;
    tfv0.customTf.text=@"";
    tfv2.customTf.text=@"";
    tfv3.customTf.text=@"";
    
    sellBuyLabel_little.text=@"";
    buyLabel.text=@"--";
    sellLabel.text=@"--";
    
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
        [productName setTitle:@"llg(伦敦金)" forState:UIControlStateNormal];
    else
        [productName setTitle:@"lls(伦敦银)" forState:UIControlStateNormal];
}

-(void)updateKdata:(NSArray *)ar
{
    NSArray *modelAr=[KlineModel mj_objectArrayWithKeyValuesArray:ar];
    
    //更新k线数据
    klineV.code=self.TradeCode;
    [klineV setKLinemodel:modelAr];
    modelAr=nil;
    
    [klineV setIndiView:NO];
}

-(void)updateCodePrice:(NSArray *)ar
{
    marketModel=[PriceMarketModel mj_objectWithKeyValues:ar[0]];
    
    sellLabel.text=ar[0][@"buy"];
    buyLabel.text=ar[0][@"sell"];
    
    //更新报价label
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",sellLabel.text,buyLabel.text]];
    [str addAttribute:NSForegroundColorAttributeName value:GXRGBColor(0, 184, 118) range:NSMakeRange(0, sellLabel.text.length)];
    [str addAttribute:NSForegroundColorAttributeName value:GXRGBColor(245, 98, 98) range:NSMakeRange( sellLabel.text.length,buyLabel.text.length+2)];
    sellBuyLabel_little.attributedText=str;
    str=nil;

    
    //判断止损止盈的价格范围
    [self updateSLTPLabelValue];
    
    
    //更新框
    if(tradeAlerV)
    {
        if(self.isOpen2)
        {
            
        }else
        {
            [postDic setObject:(self.TradeDirection==0?buyLabel.text:sellLabel.text) forKey:@"price"];
            
            [tradeAlerV setAlerRightData:@[postDic[@"price"],postDic[@"amount"],([postDic[@"sGainTf"] doubleValue]==0?@"未设置":postDic[@"sGainTf"]),([postDic[@"sLossTf"] doubleValue]==0?@"未设置":postDic[@"sLossTf"])]];
        }
    }
}

-(void)updateUserMagin
{
    XHBTraderUserMaginModel *model=GXInstance.trade_userMarginModel;
    if(model.margin && model.marginFree)
    {
        NSMutableAttributedString *text=[self setAmountInputViewString:[NSString stringWithFormat:@"%.2f",[XHBTradeInfo compleUseMarginAmount:[tfv1.customTf.text doubleValue] code:nil type:nil]] freeMargin:model.marginFree];
        amount_detail.attributedText=text;
        text=nil;
    }
}

-(void)updateSLTPLabelValue
{
    //判断止损价格范围
    {
        NSString *strmark=@"≥";
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            strmark=@"≤";
        }
        NSString *sl=[self stopLossPrice];
            
        NSMutableAttributedString *sLstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@%@)",strmark,sl]];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(0, 1)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(245, 98, 98) range:NSMakeRange(1, 1+sl.length)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(sLstr.length-1, 1)];
        sLossLabel.attributedText=sLstr;
        sLstr=nil;
        
        
        //更新textfield默认值
        tfv2.tfActivateValue= sl;
    }
    
    //判断止盈价格范围
    {
        NSString *strmark=@"≤";
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            strmark=@"≥";
        }
        NSString *sl=[self stopGainPrice];
     
        NSMutableAttributedString *sLstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@%@)",strmark,sl]];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(0, 1)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(245, 98, 98) range:NSMakeRange(1, 1+sl.length)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(sLstr.length-1, 1)];
        sGainLabel.attributedText=sLstr;
        sLstr=nil;
        
        //更新textfield默认值
        tfv3.tfActivateValue= sl;
    }
    
    
    //更新挂单价格范围
    {
        NSString *strmark=@"≥";
        if(self.TradeDirection==0||self.TradeDirection==3)
        {
            strmark=@"≤";
        }
        float a=[[self setTfActivateValue] floatValue];
        NSString *price=[NSString stringToFloat:a Code:self.TradeCode];
        
        NSMutableAttributedString *sLstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@%@)",strmark,price]];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(0, 1)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(245, 98, 98) range:NSMakeRange(1, 1+price.length)];
        [sLstr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(sLstr.length-1, 1)];
        orderPriceLabel.attributedText=sLstr;
        sLstr=nil;
        
        //更新textfield默认值
        //不同挂单类型，挂单价格应计算的值
        tfv0.tfActivateValue= price;
    }
}

-(NSString *)setTfActivateValue
{
    CGFloat point=0;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        point=2;
    }else
    {
        point=0.15;
    }

    float a=0;
    if(self.TradeDirection==0)
    {
        a=[buyLabel.text floatValue]-point;
        
    }else if(self.TradeDirection==1)
    {
        a=[sellLabel.text floatValue]+point;

    }else if(self.TradeDirection==2)
    {
        a=[buyLabel.text floatValue]+point;

    }else if(self.TradeDirection==3)
    {
        a=[sellLabel.text floatValue]-point;
    }
    
    return [NSString stringToFloat:a Code:self.TradeCode];
}

#pragma mark -

-(NSString *)stopLossPrice
{
    CGFloat point=0;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        point=2;
    }else
    {
        point=0.15;
    }
    
    
    float a=0;
    
    if(self.isOpen2)
    {
        if(self.isOpen2&&[tfv0.customTf.text floatValue]==0)
        {
            return [NSString stringToFloat:a Code:self.TradeCode];;
        }
        
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            a=[tfv0.customTf.text floatValue]-point;
        }else
        {
            a=[tfv0.customTf.text floatValue]+point;
        }
    }else
    {
        if([buyLabel.text floatValue]==0||[sellLabel.text floatValue]==0)
        {
            return [NSString stringToFloat:a Code:self.TradeCode];;
        }
        
        if(self.TradeDirection==0)
        {
            a=[sellLabel.text floatValue]-point;
        }else
        {
            a=[buyLabel.text floatValue]+point;
        }
    }
    
    return [NSString stringToFloat:a Code:self.TradeCode];
}

-(NSString *)stopGainPrice
{
    CGFloat point=0;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        point=2;
    }else
    {
        point=0.15;
    }
    
    
    float a=0;
    
    if(self.isOpen2)
    {
        if(self.isOpen2&&[tfv0.customTf.text floatValue]==0)
        {
            return [NSString stringToFloat:a Code:self.TradeCode];;
        }
        
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            a=[tfv0.customTf.text floatValue]+point;
        }else
        {
            a=[tfv0.customTf.text floatValue]-point;
        }
    }else
    {
        if([buyLabel.text floatValue]==0||[sellLabel.text floatValue]==0)
        {
            return [NSString stringToFloat:a Code:self.TradeCode];;
        }
        
        if(self.TradeDirection==0)
        {
            a=[buyLabel.text floatValue]+point;
        }else
        {
            a=[sellLabel.text floatValue]-point;
        }
    }
    
    return [NSString stringToFloat:a Code:self.TradeCode];
}

-(void)tradeTextField:(UITextField *)tf
{
    if(tf.tag==tag_tf)//价格
    {
        [self updateSLTPLabelValue];
        
    }else if (tf.tag==tag_tf+1)//手数
    {
        if([tf.text doubleValue]>=3)
        {
            tf.text=@"3.00";
        }
        
        //更新占用预付款
        [self updateUserMagin];
        
    }else if (tf.tag==tag_tf+2)//止损
    {

    }else if (tf.tag==tag_tf+3)//止盈
    {
       
    }
}

#pragma mark - 建立UI
-(void)setProductNameView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight2)];
    rootView.backgroundColor=GXRGBColor(239, 239, 243);
    
    UIView *rootViewChildView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight1)];
    [rootViewChildView setBorderWithView:rootViewChildView top:NO left:NO bottom:YES right:NO borderColor:GXRGBColor(231, 231, 231) borderWidth:0.5f];
    rootViewChildView.backgroundColor=[UIColor whiteColor];
    [rootView addSubview:rootViewChildView];
    
    
    productName=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 150, cellHeight1)];
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
        [productName setTitle:@"llg(伦敦金)" forState:UIControlStateNormal];
    else
        [productName setTitle:@"lls(伦敦银)" forState:UIControlStateNormal];
    [productName setImage:[UIImage imageNamed:@"priceDetailKBarSelectMore"] forState:UIControlStateNormal];
    [productName setImagePosition:1 spacing:10];
    [productName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    productName.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [productName setTitleColor:GXRGBColor(18, 29, 61) forState:UIControlStateNormal];
    [productName addTarget:self action:@selector(productNameClick) forControlEvents:UIControlEventTouchUpInside];
    [rootViewChildView addSubview:productName];
    

    UIButton *kviewOpenButton=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-15-cellHeight1, 0, cellHeight1, cellHeight1)];
    [kviewOpenButton setImage:[UIImage imageNamed:@"tradeKviewOpen"] forState:UIControlStateNormal];
    [kviewOpenButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [kviewOpenButton addTarget:self action:@selector(kviewOpenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rootViewChildView addSubview:kviewOpenButton];
    
    
    
    sellBuyLabel_little=[[UILabel alloc]initWithFrame:CGRectMake(kviewOpenButton.frame.origin.x- 150+10, 0, 150, cellHeight1)];
    sellBuyLabel_little.font=GXFONT_PingFangSC_Regular(15);
    sellBuyLabel_little.textAlignment=NSTextAlignmentRight;
    [rootViewChildView addSubview:sellBuyLabel_little];
    
    
    [viewDic setObject:rootView forKey:@"productNameView"];
}

-(void)productNameClick
{
    int a;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        a=0;
    }else
    {
        a=1;
    }
    
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"选择商品" delegate:self buttonAr:@[@"llg(伦敦金)",@"lls(伦敦银)"] buttonDesAr:@[] selectButton:a];
    al.tag=100;
    [al show];
}

-(void)kviewOpenButtonClick
{
    GXLog(@"kview");
    self.isOpen1=!self.isOpen1;
    
    [listmenu beginUpdates];
    
    NSInteger section = 0;
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < 1 + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (self.isOpen1)
    {   [listmenu insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [listmenu deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    
    rowToInsert=nil;
    
    [listmenu endUpdates];
    
}

-(void)setKView
{
    UIView *kView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight4+10)];
    kView.backgroundColor=GXRGBColor(239, 239, 243);
    
    klineV=[[CloseKView alloc]initWithFrame:CGRectMake(10, 0, GXScreenWidth-20, cellHeight4)];
    klineV.backgroundColor=[UIColor whiteColor];
    [kView addSubview:klineV];
    
    [viewDic setObject:kView forKey:@"kView"];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapKview)];
    [kView addGestureRecognizer:tap];
    kView.userInteractionEnabled=YES;
}

-(void)tapKview
{
    if(marketModel)
    {
        XHBPriceDetailViewController *detail=[[XHBPriceDetailViewController alloc]init];
        detail.fromTradeEnter=YES;
        detail.marketModel=marketModel;
        [self.navigationController pushViewController:detail animated:YES];
    }
}


-(void)setDirectionView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight2)];
    rootView.backgroundColor=GXRGBColor(239, 239, 243);
    
    UIView *rootViewChildView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight1)];
    [rootViewChildView setBorderWithView:rootViewChildView top:NO left:NO bottom:YES right:NO borderColor:GXRGBColor(231, 231, 231) borderWidth:0.5f];
    rootViewChildView.backgroundColor=[UIColor whiteColor];
    [rootView addSubview:rootViewChildView];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, cellHeight1)];
    if(self.isOpen2)
    {
        [title setText:@"挂单类型"];
    }else
    {
        [title setText:@"交易方向"];
    }
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootViewChildView addSubview:title];
    
    
    directionBtn=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-100-15, 0, 100, cellHeight1)];
    [self setDirectionButtonTitle];
    directionBtn.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [directionBtn setTitleColor:GXRGBColor(165, 165, 165) forState:UIControlStateNormal];
    [directionBtn setImage:[UIImage imageNamed:@"priceDetailKBarSelectMore"] forState:UIControlStateNormal];
    [directionBtn setImagePosition:1 spacing:10];
    [directionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [directionBtn addTarget:self action:@selector(directionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [directionBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [rootViewChildView addSubview:directionBtn];
    

    
    [viewDic setObject:rootView forKey:@"directionView"];
    
}

-(void)directionBtnClick
{
    UIActionSheet*actionSheet;
    if(self.isOpen2)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"挂单类型" delegate:self buttonAr:@[@"做多限价",@"做空限价",@"做多止损",@"做空止损"] buttonDesAr:@[@"低于现在价格做多",@"高于现在价格做空",@"高于现在价格做多",@"低于现在价格做空"] selectButton:self.TradeDirection];
        al.tag=101;
        [al show];
    }
    else
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"交易方向" delegate:self buttonAr:@[@"做多",@"做空"] buttonDesAr:@[] selectButton:self.TradeDirection];
        al.tag=101;
        [al show];
    }
    
    actionSheet.tag=101;
    [actionSheet showInView:self.view.window];
}

-(void)setDirectionButtonTitle
{
    if(self.isOpen2)
    {
        if(self.TradeDirection==0)
            [directionBtn setTitle:@"做多限价" forState:UIControlStateNormal];
        else if(self.TradeDirection==1)
            [directionBtn setTitle:@"做空限价" forState:UIControlStateNormal];
        else if(self.TradeDirection==2)
            [directionBtn setTitle:@"做多止损" forState:UIControlStateNormal];
        else if(self.TradeDirection==3)
            [directionBtn setTitle:@"做空止损" forState:UIControlStateNormal];
    }else
    {
        if(self.TradeDirection==0)
            [directionBtn setTitle:@"做多" forState:UIControlStateNormal];
        else if(self.TradeDirection==1)
            [directionBtn setTitle:@"做空" forState:UIControlStateNormal];
    }
    
}

- (void)gxAlertView:(GXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GXLog(@"%ld",buttonIndex);
    
    if(alertView.tag==100)
    {
        if(buttonIndex==0) {
            self.TradeCode=@"llg";
        }else if(buttonIndex==1) {
            self.TradeCode=@"lls";
        }
        
        
        [klineV setIndiView:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeVCPriceReresh" object:@[self.TradeCode] userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeVCKLineDateReresh" object:self.TradeCode userInfo:nil];
    }else if(alertView.tag==101)
    {
        //更新交易方向
        self.TradeDirection=(int)buttonIndex;
        [self setDirectionButtonTitle];
        
        
        //更新行情
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeVCPriceReresh" object:self.TradeCode userInfo:nil];
        
        
        [directionBtn setImage:[UIImage imageNamed:@"priceDetailKBarSelectMore"] forState:UIControlStateNormal];
        [directionBtn setImagePosition:1 spacing:10];
    }
    else if (alertView.tag==1000)
    {
        if(buttonIndex==1)
        {
            GXLog(@"rujin");
            
            XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
            ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
            ingold.homeTit=@"入金";
            [self.navigationController pushViewController:ingold animated:YES];
        }
    }
        
}

-(void)setPriceInputView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 35)];
    [title setText:@"挂单价格"];
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootView addSubview:title];
    
    
    orderPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 0, 100, 35)];
    orderPriceLabel.font=GXFONT_PingFangSC_Regular(13);
    [orderPriceLabel setTextColor:GXRGBColor(165, 165, 165)];
    [rootView addSubview:orderPriceLabel];
    
    
    tfv0=[[XHBTradeTextFieldView alloc]initWithTfText:@"挂单价格" y:35 tradeTfStyle:0];
    tfv0.tfTag=tag_tf;
    tfv0.delegate=(id)self;
    tfv0.tradeCode=self.TradeCode;
    [rootView addSubview:tfv0];
    
    [viewDic setObject:rootView forKey:@"PriceInputView"];
    
}

-(void)setAmountInputView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight4)];
    rootView.backgroundColor=[UIColor whiteColor];
    [rootView setBorderWithView:rootView top:NO left:NO bottom:YES right:NO borderColor:GXRGBColor(231, 231, 231) borderWidth:0.5];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 35)];
    [title setText:@"交易手数"];
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootView addSubview:title];
    
    tfv1=[[XHBTradeTextFieldView alloc]initWithTfText:@"交易手数" y:35 tradeTfStyle:0];
    tfv1.tfTag=tag_tf+1;
    tfv1.delegate=(id)self;
    [rootView addSubview:tfv1];
    
    
    amount_detail=[[YYLabel alloc]initWithFrame:CGRectMake(15, tfv1.frame.origin.y+tfv1.frame.size.height+6, GXScreenWidth-15, 20)];
    amount_detail.textAlignment=NSTextAlignmentLeft;
    amount_detail.lineBreakMode = NSLineBreakByWordWrapping;
    amount_detail.numberOfLines = 1;
    [rootView addSubview:amount_detail];
    
    NSMutableAttributedString *text;
    if(GXInstance.trade_userMarginModel)
    {
        XHBTraderUserMaginModel *model=GXInstance.trade_userMarginModel;
        text=[self setAmountInputViewString:model.margin freeMargin:model.marginFree];
    }else
    {
        text=[self setAmountInputViewString:@"0.00" freeMargin:@"0.00"];
    }
    amount_detail.attributedText=text;
    text=nil;
    
    
    
    
    
    
    [viewDic setObject:rootView forKey:@"AmountInputView"];
    
}

-(NSMutableAttributedString *)setAmountInputViewString:(NSString *)useMargin freeMargin:(NSString *)freeMargin
{
    NSMutableAttributedString *text= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"占用预付款：$%@  可用预付款：$%@  [入金]",useMargin,freeMargin]];
    text.yy_font = GXFONT_PingFangSC_Regular(12);
    text.yy_lineSpacing = 1;
    
    [text yy_setColor:GXRGBColor(165, 165, 165) range:NSMakeRange(0, 7)];
    [text yy_setColor:GXRGBColor(254, 136, 42) range:NSMakeRange(7, useMargin.length)];
    [text yy_setColor:GXRGBColor(165, 165, 165) range:NSMakeRange(7+useMargin.length, 9)];
    [text yy_setColor:GXRGBColor(254, 136, 42) range:NSMakeRange(7+useMargin.length+9, freeMargin.length)];
    [text yy_setColor:GXRGBColor(165, 165, 165) range:NSMakeRange(16+useMargin.length+freeMargin.length, 3)];
    [text yy_setColor:GXRGBColor(254, 136, 42) range:NSMakeRange(19+useMargin.length+freeMargin.length, 2)];
    [text yy_setColor:GXRGBColor(165, 165, 165) range:NSMakeRange(text.length-1, 1)];
    
    [text yy_setTextHighlightRange:NSMakeRange(text.length-3, 2) color:nil backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)
    {
        GXLog(@"入金");
        XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
        ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
        ingold.homeTit=@"入金";
        [self.navigationController pushViewController:ingold animated:YES];
    }];
    
    return text;
    
}

-(void)setStopLossInputView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 35)];
    [title setText:@"止损价格"];
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootView addSubview:title];
    
    
    sLossLabel=[[UILabel alloc]init];
    sLossLabel.font=GXFONT_PingFangSC_Regular(13);
    [sLossLabel setTextColor:GXRGBColor(165, 165, 165)];
    [rootView addSubview:sLossLabel];
    [sLossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@85);
        make.top.equalTo(@0);
        make.height.equalTo(@35);
    }];
    
    //问号button
    UIButton *questionBtn=[[UIButton alloc]init];
    [questionBtn setImage:[UIImage imageNamed:@"tradeViewMake_question"] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(questionBtn_sLoss) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:questionBtn];
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sLossLabel.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    
    tfv2=[[XHBTradeTextFieldView alloc]initWithTfText:@"止损价格" y:35 tradeTfStyle:1];
    tfv2.tfTag=tag_tf+2;
    tfv2.delegate=(id)self;
    tfv2.tradeCode=self.TradeCode;
    [rootView addSubview:tfv2];
    
    [viewDic setObject:rootView forKey:@"StopLossInputView"];
    
}

-(void)setStopGainInputView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 35)];
    [title setText:@"止盈价格"];
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootView addSubview:title];
    
    
    sGainLabel=[[UILabel alloc]init];
    sGainLabel.font=GXFONT_PingFangSC_Regular(13);
    [sGainLabel setTextColor:GXRGBColor(165, 165, 165)];
    [rootView addSubview:sGainLabel];
    [sGainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@85);
        make.top.equalTo(@0);
        make.height.equalTo(@35);
    }];
    
    //问号button
    UIButton *questionBtn=[[UIButton alloc]init];
    [questionBtn setImage:[UIImage imageNamed:@"tradeViewMake_question"] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(questionBtn_sGain) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:questionBtn];
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sGainLabel.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    
    tfv3=[[XHBTradeTextFieldView alloc]initWithTfText:@"止盈价格" y:35 tradeTfStyle:1];
    tfv3.tfTag=tag_tf+3;
    tfv3.delegate=(id)self;
    tfv3.tradeCode=self.TradeCode;
    [rootView addSubview:tfv3];
    
    [viewDic setObject:rootView forKey:@"StopGainInputView"];
    
}

-(void)questionBtn_sLoss
{
    NSString *point;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        point=@"200";
    }else
    {
        point=@"150";
    }
    
    NSString *str=@"";
    if(self.isOpen2)
    {
        str=[NSString stringWithFormat:@"设置止损将依照挂单价格进行设置；\n为保证设置有效，止损点数必须远离挂单价格至少%@点",point];
    }else
    {
        if(self.TradeDirection==0)
        {
            str=[NSString stringWithFormat:@"设置止损将依照做空价格进行设置；\n为保证设置有效，止损点数必须远离做空价格至少%@点",point];
        }else
        {
            str=[NSString stringWithFormat:@"设置止损将依照做多价格进行设置；\n为保证设置有效，止损点数必须远离做多价格至少%@点",point];
        }
    }
        
    
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"止损" message:str delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
}

-(void)questionBtn_sGain
{
    NSString *point;
    if([[self.TradeCode lowercaseString]isEqualToString:@"llg"])
    {
        point=@"200";
    }else
    {
        point=@"150";
    }
    
    NSString *str=@"";
    if(self.isOpen2)
    {
        str=[NSString stringWithFormat:@"设置止盈将依照挂单价格进行设置；\n为保证设置有效，止盈点数必须远离挂单价格至少%@点",point];
    }else
    {
        if(self.TradeDirection==0)
        {
            str=[NSString stringWithFormat:@"设置止盈将依照做多价格进行设置；\n为保证设置有效，止盈点数必须远离做多价格至少%@点",point];
        }else
        {
            str=[NSString stringWithFormat:@"设置止盈将依照做空价格进行设置；\n为保证设置有效，止盈点数必须远离做空价格至少%@点",point];
        }
    }
    
    
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"止盈" message:str delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
}

-(void)setPriceLabelAndOrderButtonView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, listmenu.frame.origin.y+listmenu.frame.size.height, GXScreenWidth, 105)];
    rootView.backgroundColor=GXRGBColor(242, 242, 243);
    [self.view addSubview:rootView];
    
    UILabel *title1=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 20, 60)];
    [title1 setText:@"空"];
    title1.font=GXFONT_PingFangSC_Regular(15);
    [title1 setTextColor:GXRGBColor(165, 165, 165)];
    [rootView addSubview:title1];
    
    
    
    UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth/2.0)+40, 0, 20, 60)];
    [title2 setText:@"多"];
    title2.font=GXFONT_PingFangSC_Regular(15);
    [title2 setTextColor:GXRGBColor(165, 165, 165)];
    [rootView addSubview:title2];
    
    
    sellLabel=[[UILabel alloc]initWithFrame:CGRectMake(title1.frame.origin.x+title1.frame.size.width, 0, GXScreenWidth/2.0-60, 60)];
    [sellLabel setText:@"--"];
    sellLabel.font=GXFONT_PingFangSC_Regular(23);
    [sellLabel setTextColor:GXRGBColor(0, 184, 118)];
    [rootView addSubview:sellLabel];
    
    buyLabel=[[UILabel alloc]initWithFrame:CGRectMake(title2.frame.origin.x+title2.frame.size.width, 0, GXScreenWidth/2.0-60, 60)];
    [buyLabel setText:@"--"];
    buyLabel.font=GXFONT_PingFangSC_Regular(23);
    [buyLabel setTextColor:GXRGBColor(245, 98, 98)];
    [rootView addSubview:buyLabel];
    
    
    UIButton *orderbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 60, GXScreenWidth, 45)];
    [orderbutton setTitle:@"下单" forState:UIControlStateNormal];
    orderbutton.titleLabel.font=GXFONT_PingFangSC_Medium(16);
    [orderbutton setTitleColor:GXRGBColor(255, 255, 255) forState:UIControlStateNormal];
    [orderbutton setBackgroundColor:GXRGBColor(254, 136, 42)];
    [orderbutton addTarget:self action:@selector(orderbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:orderbutton];
    
}

-(void)orderbuttonClick
{
    GXLog(@"下单");
    
    if(self.isOpen2)
    {
        if([tfv0.customTf.text floatValue]==0)
        {
            GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"挂单价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
            [al show];
            return;
        }
        
        float a=[[self setTfActivateValue] floatValue];
        
        if(self.TradeDirection==0||self.TradeDirection==3)
        {
            if([tfv0.customTf.text floatValue]>a)
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"挂单价格不能大于%@",[NSString stringToFloat:[[self setTfActivateValue] floatValue] Code:self.TradeCode]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                return;
            }
            
        }else if(self.TradeDirection==1||self.TradeDirection==2)
        {
            if([tfv0.customTf.text floatValue]<a)
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"挂单价格不能小于%@",[NSString stringToFloat:[[self setTfActivateValue] floatValue] Code:self.TradeCode]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                return;
            }
            
        }
    }
    
    
    
    
    if([tfv1.customTf.text doubleValue]==0)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"交易手数不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        [al show];
        
        return;
    }
    
    //判断占用预付款
    XHBTraderUserMaginModel *marginModel= GXInstance.trade_userMarginModel;
    CGFloat userMagin=[XHBTradeInfo compleUseMarginAmount:[tfv1.customTf.text doubleValue] code:nil type:nil];
    if(userMagin>[marginModel.marginFree floatValue])
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"您的可用预付款不足，请及时入金" delegate:self cancelButtonTitle:@"立即入金" otherButtonTitles:@"知道了",nil];
        al.tag=1000;
        [al show];
        
        return;
    }    
    
    
    
    
    if(tfv2.customTf.enabled && [tfv2.customTf.text doubleValue]>0)
    {
        NSString *sl=[self stopLossPrice];
        
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            if([tfv2.customTf.text doubleValue] > [sl doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止损价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }else
        {
            if([tfv2.customTf.text doubleValue] < [sl doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止损价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }
    }
    
    if(tfv3.customTf.enabled && [tfv3.customTf.text doubleValue]>0)
    {
        NSString *sg=[self stopGainPrice];
        
        if(self.TradeDirection==0||self.TradeDirection==2)
        {
            if([tfv3.customTf.text doubleValue] < [sg doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止盈价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
            
                return;
            }
        }else
        {
            if([tfv3.customTf.text doubleValue] > [sg doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止盈价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }
    }
    
    if(tradeAlerV)
    {
        [tradeAlerV removeFromSuperview];
        tradeAlerV=nil;
    }
    
   
    
    //设置post
    [postDic setObject:tfv1.customTf.text forKey:@"amount"];
    [postDic setObject:(tfv2.customTf.enabled?tfv2.customTf.text:@"0.00") forKey:@"sLossTf"];
    [postDic setObject:(tfv3.customTf.enabled?tfv3.customTf.text:@"0.00") forKey:@"sGainTf"];
    if(self.isOpen2)
    {
        [postDic setObject:tfv0.customTf.text forKey:@"price"];
    }else
    {
        [postDic setObject:(self.TradeDirection==0?buyLabel.text:sellLabel.text) forKey:@"price"];
    }
    
    
    if(self.isOpen2)
    {
        tradeAlerV=[[XHBTradeAlertView alloc]initWithTitle:productName.titleLabel.text leftText:@[@"挂单价格",@"交易手数",@"止盈价格",@"止损价格"]];
        tradeAlerV.delegate=(id)self;
        
        NSString *tit=@"";
        if(self.TradeDirection==0)
        {
            tit=@"做多限价";
        }else if (self.TradeDirection==1)
        {
            tit=@"做空限价";
        }else if (self.TradeDirection==2)
        {
            tit=@"做多止损";
        }else if (self.TradeDirection==3)
        {
            tit=@"做空止损";
        }
        
        [tradeAlerV setOrderCloseButtonText:tit backgroundColor:((self.TradeDirection==1||self.TradeDirection==3)?GXRGBColor(0, 184, 118):GXRGBColor(245, 98, 98))];
        [self.view.window addSubview:tradeAlerV];
        
        
        
        [tradeAlerV setAlerRightData:@[postDic[@"price"],postDic[@"amount"],([postDic[@"sGainTf"] doubleValue]==0?@"未设置":postDic[@"sGainTf"]),([postDic[@"sLossTf"] doubleValue]==0?@"未设置":postDic[@"sLossTf"])]];
    }
    else
    {
        tradeAlerV=[[XHBTradeAlertView alloc]initWithTitle:productName.titleLabel.text leftText:@[@"建仓价格",@"交易手数",@"止盈价格",@"止损价格",@"占用金额"]];
        tradeAlerV.delegate=(id)self;
        [tradeAlerV setOrderCloseButtonText:(self.TradeDirection==0?@"做多":@"做空") backgroundColor:(self.TradeDirection==0?GXRGBColor(245, 98, 98):GXRGBColor(0, 184, 118))];
        [self.view.window addSubview:tradeAlerV];
        
        
        [tradeAlerV setAlerRightData:@[postDic[@"price"],postDic[@"amount"],([postDic[@"sGainTf"] doubleValue]==0?@"未设置":postDic[@"sGainTf"]),([postDic[@"sLossTf"] doubleValue]==0?@"未设置":postDic[@"sLossTf"]),[NSString stringWithFormat:@"%.2f",userMagin]]];
    }
}

#define mark - XHBTradeAlertViewdelegate
-(void)XHBTradeAlertViewDelegate_done
{
    
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交下单"];
    
    
    NSString *cmd=@"";
    
    if(self.isOpen2)
    {
        if(self.TradeDirection==0)
        {
            cmd=@"2";
        }else if(self.TradeDirection==1)
        {
            cmd=@"3";
        }else if(self.TradeDirection==2)
        {
            cmd=@"4";
        }else
        {
            cmd=@"5";
        }
    }else
    {
        if(self.TradeDirection==0)
        {
            cmd=@"0";
        }else
        {
            cmd=@"1";
        }
    }
    
    GXLog(@"%@",postDic);
    
    [GXHttpTool POST:GXUrl_appmt4order parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"price":postDic[@"price"],@"volume":postDic[@"amount"],@"sl":postDic[@"sLossTf"],@"tp":postDic[@"sGainTf"],@"cmd":cmd,@"putSymbol":self.TradeCode,@"comment":@"",@"deviation":@"100"} success:^(id responseObject){
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            
            [self.view removeTipView];
            [self.view showSuccessWithTitle:@"下单成功"];
        }else
        {
            [self.view removeTipView];
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"加载数据失败"];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
