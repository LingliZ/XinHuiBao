//
//  XHBSetOrderStTpViewController.m
//  XHBApp
//
//  Created by shenqilong on 17/3/8.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBSetOrderStTpViewController.h"
#import "XHBTradePositionModel.h"
#import "XHBTradeTextFieldView.h"

@interface XHBSetOrderStTpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask_Price;
    NSTimer *timer;
    UITableView *listmenu;
    
    UIView *PriceView;
    UIView *setSlTpView;
    UIView *buttonView;
    
    UILabel *sLossLabel;
    UILabel *sGainLabel;
}
@end

#define cellHeight3 85
#define tag_tf 7881872
#define tag_tfView 77191


@implementation XHBSetOrderStTpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    self.title=@"设置止损止盈";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.separatorStyle=UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=[UIColor clearColor];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    
    
    [self setPriceView];
    [self setStopLossInputView];
    [self setStopGainInputView];
    [self setButtonView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    //刷行情
    [self setpriceReresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if(dataTask_Price)
    {
        [dataTask_Price cancel];
        dataTask_Price=nil;
    }
    
    [self.view removeTipView];
}

-(void)refresh
{
    //刷行情
    [self setpriceReresh];
}

-(void)setpriceReresh
{
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
    if(dataTask_Price)
    {
        [dataTask_Price cancel];
        dataTask_Price=nil;
    }
    //加载行情
    [self priceRereshing];
    //刷行情
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(priceRereshing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


-(void)priceRereshing
{
    if(dataTask_Price)
    {
        return;
    }
    
    dataTask_Price =[GXHttpTool POST:GXUrl_quotation parameters:@{@"code":self.PositionModel.symbolCode} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            NSArray *ar=responseObject[@"value"];
            if([ar count]==0)return ;
            
            //更新buy 和 sell
            XHBTradePositionModel *model=self.PositionModel;
            if([model.cmd integerValue]==0)
            {
                model.closePrice=ar[0][@"buy"];
            }else
            {
                model.closePrice=ar[0][@"sell"];
            }
            
            model.buy=ar[0][@"buy"];
            model.sell=ar[0][@"sell"];
            self.PositionModel=model;
            
            
            //更新现在价格
            UILabel *lb=[PriceView subviews][3];
            lb.text=self.PositionModel.closePrice;
            
            
            
            //判断止损价格范围
            {
                NSString *strmark=@"≥";
                if([self.PositionModel.cmd integerValue]==0)
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
                XHBTradeTextFieldView *tfv2=[self.view viewWithTag:tag_tfView+2];
                tfv2.tfActivateValue= sl;
            }
            
            //判断止盈价格范围
            {
                NSString *strmark=@"≤";
                if([self.PositionModel.cmd integerValue]==0)
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
                XHBTradeTextFieldView *tfv3=[self.view viewWithTag:tag_tfView+3];
                tfv3.tfActivateValue= sl;
            }

        }
        
        dataTask_Price=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_Price=nil;
    }];
}
#pragma mark -

-(NSString *)stopLossPrice
{
    CGFloat point=0;
    if([[self.PositionModel.symbolCode lowercaseString]isEqualToString:@"llg"])
    {
        point=2;
    }else
    {
        point=0.15;
    }
    
    
    float a=0;
    
    if([self.PositionModel.buy floatValue]==0||[self.PositionModel.sell floatValue]==0)
    {
        return @"0.00";
    }
    
    if([self.PositionModel.cmd integerValue]==0)
    {
        a=[self.PositionModel.buy floatValue]-point;
    }else
    {
        a=[self.PositionModel.sell floatValue]+point;
    }
    
    return [NSString stringToFloat:a Code:self.PositionModel.symbolCode];
}

-(NSString *)stopGainPrice
{
    CGFloat point=0;
    if([[self.PositionModel.symbolCode lowercaseString]isEqualToString:@"llg"])
    {
        point=2;
    }else
    {
        point=0.15;
    }
    
    
    float a=0;
    
    if([self.PositionModel.buy floatValue]==0||[self.PositionModel.sell floatValue]==0)
    {
        return @"0.00";
    }
    
    if([self.PositionModel.cmd integerValue]==0)
    {
        a=[self.PositionModel.sell floatValue]+point;
    }else
    {
        a=[self.PositionModel.buy floatValue]-point;
    }
    
    return [NSString stringToFloat:a Code:self.PositionModel.symbolCode];
}

-(void)tradeTextField:(UITextField *)tf
{
    GXLog(@"%@",tf.text);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        return PriceView.frame.size.height+10;
    }
    
    if(indexPath.section==1)
    {
        return setSlTpView.frame.size.height;
    }
    
    if(indexPath.section==2)
    {
        return buttonView.frame.size.height;
    }
  
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    if(indexPath.section==0)
    {
        [cell.contentView addSubview:PriceView];
    }
    if(indexPath.section==1)
    {
        [cell.contentView addSubview:setSlTpView];
    }
    if(indexPath.section==2)
    {
        [cell.contentView addSubview:buttonView];
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 设置UI
-(void)setPriceView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 80)];
    vv.backgroundColor=[UIColor whiteColor];
    PriceView=vv;
    
    UILabel *lb1=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, GXScreenWidth/2.0, 20)];
    lb1.font=GXFONT_PingFangSC_Regular(13);
    lb1.textColor=GXColor(165, 165, 165, 1);
    lb1.textAlignment=NSTextAlignmentCenter;
    [vv addSubview:lb1];
    
    lb1.text=@"建仓价格";
    
    UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(0, 46, GXScreenWidth/2.0, 20)];
    lb2.font=GXFONT_PingFangSC_Regular(18);
    lb2.textColor=GXColor(51, 51, 51, 1);
    lb2.text=self.PositionModel.openPrice;
    lb2.textAlignment=NSTextAlignmentCenter;
    [vv addSubview:lb2];
    
    
    UILabel *lb3=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 20, GXScreenWidth/2.0, 20)];
    lb3.font=GXFONT_PingFangSC_Regular(13);
    lb3.textColor=GXColor(165, 165, 165, 1);
    lb3.text=@"现在价格";
    lb3.textAlignment=NSTextAlignmentCenter;
    [vv addSubview:lb3];
    
    UILabel *lb4=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 46, GXScreenWidth/2.0, 20)];
    lb4.font=GXFONT_PingFangSC_Regular(18);
    lb4.textColor=GXColor(51, 51, 51, 1);
    lb4.text=self.PositionModel.closePrice;
    lb4.textAlignment=NSTextAlignmentCenter;
    [vv addSubview:lb4];
    
    
    UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 25, 0.5, 30)];
    lineimg.backgroundColor=GXRGBColor(242, 243, 243);
    [vv addSubview:lineimg];

}

-(void)setStopLossInputView
{
    setSlTpView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3*2)];
    
    
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    [setSlTpView addSubview:rootView];

    
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
    
    
    
    XHBTradeTextFieldView *tfv=[[XHBTradeTextFieldView alloc]initWithTfText:@"止损价格" y:35 tradeTfStyle:1];
    tfv.tfTag=tag_tf+2;
    tfv.tag=tag_tfView+2;
    tfv.delegate=(id)self;
    tfv.tradeCode=self.PositionModel.symbolCode;
    [rootView addSubview:tfv];
    
    tfv.customTf.text=([self.PositionModel.sl floatValue]==0?@"":self.PositionModel.sl);
    [tfv seleButton:tfv.cusSelectButton];//调用此方法使框默认打开
}

-(void)setStopGainInputView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight3, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    [setSlTpView addSubview:rootView];
    
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
    
    XHBTradeTextFieldView *tfv=[[XHBTradeTextFieldView alloc]initWithTfText:@"止盈价格" y:35 tradeTfStyle:1];
    tfv.tfTag=tag_tf+3;
    tfv.tag=tag_tfView+3;
    tfv.delegate=(id)self;
    tfv.tradeCode=self.PositionModel.symbolCode;
    [rootView addSubview:tfv];
  
    tfv.customTf.text=([self.PositionModel.tp floatValue]==0?@"":self.PositionModel.tp);
    [tfv seleButton:tfv.cusSelectButton];//调用此方法使框默认打开
}

-(void)setButtonView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 130)];
    rootView.backgroundColor=[UIColor clearColor];
    buttonView=rootView;
    
    UIView *childv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 55)];
    childv.backgroundColor=[UIColor whiteColor];
    [rootView addSubview:childv];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, GXScreenWidth-100, 55)];
    [title setText:@"为保证设置有效的止损/止盈价格，需考虑到买入价格与现在价格之间的点差"];
    title.font=GXFONT_PingFangSC_Regular(11);
    [title setTextColor:GXRGBColor(165, 165, 165)];
    title.numberOfLines=0;
    title.textAlignment=NSTextAlignmentCenter;
    [rootView addSubview:title];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(15,85,GXScreenWidth-30,45)];
    button.backgroundColor=GXRGBColor(254, 136, 42);
    button.layer.cornerRadius=4;
    button.titleLabel.font=GXFONT_PingFangSC_Medium(16);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认设置" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButton) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:button];

}


-(void)questionBtn_sLoss
{
    NSString *point;
    if([[self.PositionModel.symbolCode lowercaseString]isEqualToString:@"llg"])
    {
        point=@"200";
    }else
    {
        point=@"150";
    }
    
    NSString *str=@"";
    if([self.PositionModel.cmd integerValue]==0)
    {
        str=[NSString stringWithFormat:@"设置止损将依照做空价格进行设置；\n为保证设置有效，止损点数必须远离做空价格至少%@点",point];
    }else
    {
        str=[NSString stringWithFormat:@"设置止损将依照做多价格进行设置；\n为保证设置有效，止损点数必须远离做多价格至少%@点",point];
    }
    
    
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"止损" message:str delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
}

-(void)questionBtn_sGain
{
    NSString *point;
    if([[self.PositionModel.symbolCode lowercaseString]isEqualToString:@"llg"])
    {
        point=@"200";
    }else
    {
        point=@"150";
    }
    
    NSString *str=@"";
    if([self.PositionModel.cmd integerValue]==0)
    {
        str=[NSString stringWithFormat:@"设置止盈将依照做多价格进行设置；\n为保证设置有效，止盈点数必须远离做多价格至少%@点",point];
    }else
    {
        str=[NSString stringWithFormat:@"设置止盈将依照做空价格进行设置；\n为保证设置有效，止盈点数必须远离做空价格至少%@点",point];
    }
    
    
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"止盈" message:str delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
}

-(void)doneButton
{
    XHBTradeTextFieldView *tfv2=[self.view viewWithTag:tag_tfView+2];
    XHBTradeTextFieldView *tfv3=[self.view viewWithTag:tag_tfView+3];
    
    if(tfv2.customTf.enabled && [tfv2.customTf.text doubleValue]>0)
    {
        NSString *sl=[self stopLossPrice];
        
        if([self.PositionModel.cmd integerValue]==1)
        {
            if([tfv2.customTf.text doubleValue] < [sl doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止损价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }else
        {
            if([tfv2.customTf.text doubleValue] > [sl doubleValue])
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
        
        if([self.PositionModel.cmd integerValue]==1)
        {
            if([tfv3.customTf.text doubleValue] > [sg doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止盈价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }else
        {
            if([tfv3.customTf.text doubleValue] < [sg doubleValue])
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"止盈价格不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [al show];
                
                return;
            }
        }
    }
    
    NSString *sl=tfv2.customTf.text;
    if(!tfv2.customTf.enabled || [tfv2.customTf.text floatValue]==0)
    {
        sl=@"0.00";
    }
    NSString *tp=tfv3.customTf.text;
    if(!tfv3.customTf.enabled || [tfv3.customTf.text floatValue]==0)
    {
        tp=@"0.00";
    }
    
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交修改"];
    
    [GXHttpTool POST:GXUrl_appordermodify parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"order":self.PositionModel.ticket,@"sl":sl ,@"tp":tp} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            [self.view removeTipView];
            [self.view showSuccessWithTitle:@"修改成功"];
            
            
            self.PositionModel.sl=tfv2.customTf.text;
            self.PositionModel.tp=tfv3.customTf.text;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self.view removeTipView];
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"连接服务器失败"];
        
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
