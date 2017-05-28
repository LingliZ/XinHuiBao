//
//  XHBSetOrderStTpViewController.m
//  XHBApp
//
//  Created by shenqilong on 17/3/8.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBOrderCloseDetailViewController.h"
#import "XHBTradePositionModel.h"
#import "XHBTradeTextFieldView.h"

@interface XHBOrderCloseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask_Price;
    NSTimer *timer;
    UITableView *listmenu;
    
    UIView *PriceView;
    UIView *ProfitView;
    UIView *ProfitDetailView;
    UIView *AmountView;
    UIView *buttonView;
    
    BOOL isOpen;
}
@end

#define cellHeight3 85
#define tag_tf 7881872
#define tag_tfView 77191


@implementation XHBOrderCloseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    if([self.PositionModel.cmd integerValue]==0)
    {
        self.title=@"平仓";
    }else
    {
        self.title=@"平仓";
    }
    
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
    [self setProfitView];
    [self setProfitDetailView];
    [self setAmountView];
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
            
            
           
            
        }
        
        dataTask_Price=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_Price=nil;
    }];
}
#pragma mark -

-(void)tradeTextField:(UITextField *)tf
{
    GXLog(@"%@",tf.text);
    if (tf.tag==tag_tf)//手数
    {
        if([tf.text doubleValue]>=[self.PositionModel.volume floatValue])
        {
            tf.text=self.PositionModel.volume;
        }
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        return PriceView.frame.size.height+10;
    }
    
    if(indexPath.section==1)
    {
        if(isOpen)
        {
            if(indexPath.row==1)
            {
                return ProfitDetailView.frame.size.height;
            }
        }
        return ProfitView.frame.size.height;
    }
    
    if(indexPath.section==2)
    {
        return AmountView.frame.size.height;
    }
    
    if(indexPath.section==3)
    {
        return buttonView.frame.size.height;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isOpen)
    {
        if(section==1)
        {
            return 2;
        }
    }
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
        if(indexPath.row==0)
        {
            [cell.contentView addSubview:ProfitView];
        }else
        [cell.contentView addSubview:ProfitDetailView];
    }
    if(indexPath.section==2)
    {
        [cell.contentView addSubview:AmountView];
    }
    if(indexPath.section==3)
    {
        [cell.contentView addSubview:buttonView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==1)
    {
        isOpen=!isOpen;
        
        [listmenu beginUpdates];
        
        NSInteger section = 1;
        
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        for (NSUInteger i = 1; i < 1 + 1; i++) {
            NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
            [rowToInsert addObject:indexPathToInsert];
        }
        
        if (isOpen)
        {
            [listmenu insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [listmenu deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        }
        
        rowToInsert=nil;
        
        [listmenu endUpdates];
        
        [UIView animateWithDuration:0.2 animations:^{
            UIButton *imgArrow=[ProfitView subviews][2];
            if(isOpen)
            {
                [imgArrow.imageView setTransform:CGAffineTransformMakeRotation(M_PI-0.01)];
            }else
            {
                [imgArrow.imageView setTransform:CGAffineTransformMakeRotation(0)];
            }
        }];
    }
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

-(void)setProfitView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 55)];
    vv.backgroundColor=[UIColor whiteColor];
    ProfitView=vv;
    
    UILabel *lb1=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, 100, 30)];
    lb1.text=@"浮动盈亏";
    lb1.font=GXFONT_PingFangSC_Regular(15);
    lb1.textColor=GXColor(18, 29, 61, 1);
    [vv addSubview:lb1];
    
    
    UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(15, 30, 150, 20)];
    lb2.text=@"(包含手续费、库存费)";
    lb2.font=GXFONT_PingFangSC_Regular(12);
    lb2.textColor=GXColor(165, 165, 165, 1);
    [vv addSubview:lb2];
    
    UIButton *cellArrow=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-45, 0, 30, 55)];
    [cellArrow setImage:[UIImage imageNamed:@"priceDetailKBarSelectMore"] forState:UIControlStateNormal];
    cellArrow.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    cellArrow.enabled=NO;
    [vv addSubview:cellArrow];
    
    UILabel *lb3=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-45-150, 0, 150, 55)];
    lb3.textAlignment=NSTextAlignmentRight;
    lb3.attributedText=self.PositionModel.OrderProfit_att;
    [vv addSubview:lb3];
    self.PositionModel.OrderProfit_att=nil;
}

-(void)setProfitDetailView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 45)];
    vv.backgroundColor=[UIColor whiteColor];
    ProfitDetailView=vv;
    
    float w=GXScreenWidth/3.0;
    
    NSArray *ar=@[@"订单盈亏",@"库存费",@"手续费"];
    for (int i=0; i<3; i++) {
        UILabel *lb1=[[UILabel alloc]initWithFrame:CGRectMake(w*i, 0, w, 20)];
        lb1.text=ar[i];
        lb1.textAlignment=NSTextAlignmentCenter;
        lb1.font=GXFONT_PingFangSC_Regular(12);
        lb1.textColor=GXColor(165, 165, 165, 1);
        [vv addSubview:lb1];
        
        
        UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(w*i, 15, w, 30)];
        lb2.textAlignment=NSTextAlignmentCenter;
        lb2.font=GXFONT_PingFangSC_Regular(14);
        lb2.textColor=GXColor(51, 51, 51, 1);
        [vv addSubview:lb2];
        
        if(i==0)
        {
            lb2.text=[NSString stringWithFormat:@"%.2f",[self.PositionModel.FL floatValue]-[self.PositionModel.swaps floatValue]-[self.PositionModel.commission floatValue]];
        }else if (i==1)
        {
            lb2.text=[NSString stringWithFormat:@"%@",self.PositionModel.swaps];
        }else
        {
            lb2.text=[NSString stringWithFormat:@"%@",self.PositionModel.commission];
        }
    }
    
    
}

-(void)setAmountView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, cellHeight3)];
    rootView.backgroundColor=[UIColor whiteColor];
    [self.view setBorderWithView:rootView top:YES left:NO bottom:NO right:NO borderColor:GXColor(231, 231, 231, 1) borderWidth:0.5];
    AmountView=rootView;
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, GXScreenWidth-30, 35)];
    title.font=GXFONT_PingFangSC_Regular(15);
    [title setTextColor:GXRGBColor(18, 29, 61)];
    [rootView addSubview:title];
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"交易手数 (当前持仓%@手)",self.PositionModel.volume]];
    [str addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(12) range:NSMakeRange(5, str.length-5)];
    [str addAttribute:NSForegroundColorAttributeName value:GXColor(165, 165, 165, 1) range:NSMakeRange(5, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:GXColor(165, 165, 165, 1) range:NSMakeRange(str.length-2, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:GXColor(245, 98, 98, 1) range:NSMakeRange(10, self.PositionModel.volume.length)];
    [title setAttributedText:str];
    str=nil;
    
    
    
    
    XHBTradeTextFieldView *tfv=[[XHBTradeTextFieldView alloc]initWithTfText:@"交易手数" y:35 tradeTfStyle:0];
    tfv.tfTag=tag_tf;
    tfv.tag=tag_tfView;
    tfv.delegate=(id)self;
    [rootView addSubview:tfv];
    
    tfv.customTf.text=self.PositionModel.volume;
}



-(void)setButtonView
{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 120)];
    rootView.backgroundColor=[UIColor clearColor];
    buttonView=rootView;
    
    UIView *childv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 45)];
    childv.backgroundColor=[UIColor whiteColor];
    [rootView addSubview:childv];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, GXScreenWidth-100, 45)];
    [title setText:@"由于网络延迟，最终成交价格以服务器成交价格为准"];
    title.font=GXFONT_PingFangSC_Regular(11);
    [title setTextColor:GXRGBColor(165, 165, 165)];
    title.numberOfLines=0;
    title.textAlignment=NSTextAlignmentCenter;
    [rootView addSubview:title];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(15,75,GXScreenWidth-30,45)];
    button.backgroundColor=GXRGBColor(254, 136, 42);
    button.layer.cornerRadius=4;
    button.titleLabel.font=GXFONT_PingFangSC_Medium(16);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认平仓" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButton) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:button];
    
}

-(void)doneButton
{
   
    XHBTradeTextFieldView *tfv=[self.view viewWithTag:tag_tfView];
    if([tfv.customTf.text floatValue]==0)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"交易手数不符合要求" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        [al show];
        
        return;
    }
    
    
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交平仓"];
    
    [GXHttpTool POST:GXUrl_apporderclose parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"price":self.PositionModel.closePrice,@"volume":tfv.customTf.text,@"order":self.PositionModel.ticket} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            [self.view removeTipView];
            [self.view showSuccessWithTitle:@"平仓成功"];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSMutableArray *vcAr=[[NSMutableArray alloc]init];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if(![vc isKindOfClass: NSClassFromString(@"XHBOrderCloseViewController")])
                    {
                        [vcAr addObject:vc];
                    }
                }
                self.navigationController.viewControllers=vcAr;
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
