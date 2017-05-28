//
//  XHBOrderCloseViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBLimitOrderDetailViewController.h"
#import "XHBTradePositionModel.h"
#import "CloseKView.h"
#import "KlineModel.h"
#import "XHBTradeAlertView.h"
#import "PriceMarketModel.h"
#import "XHBPriceDetailViewController.h"

#define tag_contentviewLabel 12412
@interface XHBLimitOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask_Price;//请求任务
    NSURLSessionDataTask *dataTask_Kview;
    
    NSTimer *timer;
    
    CloseKView *klineV;
    
    UITableView *listmenu;
    UIView *kView;
    UIView *ContentView;
    UIView *ButtonView;
    
    XHBTradeAlertView *tradeAlerV;
    
    PriceMarketModel *marketModel;
}
@end

@implementation XHBLimitOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
   
    self.title=@"";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.separatorStyle=UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=[UIColor clearColor];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    
    
    [self setNavTitleView];
    [self setKView];
    [self setButtonView];
    
}

-(void)refresh
{
    //加载k线
    [self KLineDateRereshing];
    
    //刷行情
    [self setpriceReresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //加载k线
    [self KLineDateRereshing];
    
    //刷行情
    [self setpriceReresh];
    
    [self setContentView];
    
    [listmenu reloadData];
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
    
    if(dataTask_Kview)
    {
        [dataTask_Kview cancel];
        dataTask_Kview=nil;
    }
    
    [self.view removeTipView];
}

-(void)KLineDateRereshing
{
    [klineV setIndiView:YES];
    
    if(dataTask_Kview)
    {
        [dataTask_Kview cancel];
        dataTask_Kview=nil;
    }
    dataTask_Kview=[GXHttpTool POST:GXUrl_kline parameters:@{@"maxrecords":@"50",@"code":self.PositionModel.symbolCode,@"level":@"60"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            NSArray *ar=[KlineModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            //更新k线数据
            [klineV setKLinemodel:ar];
            ar=nil;
        }
        
        [klineV setIndiView:NO];
        
        
    } failure:^(NSError *error) {
        
        [klineV setIndiView:NO];
        
    }];
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
            
            
            marketModel=[PriceMarketModel mj_objectWithKeyValues:ar[0]];

            
            
            //更新buy 和 sell
            XHBTradePositionModel *model=self.PositionModel;
            
            if([model.cmd integerValue]==2||[model.cmd integerValue]==4)
            {
                model.closePrice=ar[0][@"sell"];
            }else
            {
                model.closePrice=ar[0][@"buy"];
            }
            self.PositionModel=model;
            
            
            //更新现在价格
            UILabel *lb=[self.view viewWithTag:tag_contentviewLabel+3];
            lb.text=self.PositionModel.closePrice;
            
            
            if(tradeAlerV)
            {
                [tradeAlerV setAlerRightData:@[self.PositionModel.openPrice,self.PositionModel.closePrice,self.PositionModel.volume,([self.PositionModel.tp doubleValue]==0?@"未设置":self.PositionModel.tp),([self.PositionModel.sl doubleValue]==0?@"未设置":self.PositionModel.sl)]];

            }
        }
        
        dataTask_Price=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_Price=nil;
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        return kView.frame.size.height;
    }
    if(indexPath.section==1)
    {
        return ContentView.frame.size.height;
    }
    if(indexPath.section==2)
    {
        return ButtonView.frame.size.height;
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
        [cell.contentView addSubview:kView];
    }
    if(indexPath.section==1)
    {
        [cell.contentView addSubview:ContentView];
    }
    if(indexPath.section==2)
    {
        [cell.contentView addSubview:ButtonView];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 设置UI
-(void)setNavTitleView
{
    UIView *vv=[[UIView alloc]init];
    vv.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *lb_OrderLongShort=[[UILabel alloc]init];
    lb_OrderLongShort.font = GXFONT_PingFangSC_Regular(14);
    lb_OrderLongShort.textColor = [UIColor whiteColor];
    lb_OrderLongShort.textAlignment=NSTextAlignmentCenter;
    lb_OrderLongShort.layer.masksToBounds=YES;
    lb_OrderLongShort.layer.cornerRadius=2;
    [vv addSubview:lb_OrderLongShort];
    lb_OrderLongShort.text = [NSString stringWithFormat:@"%@",self.PositionModel.cmd_str];
    lb_OrderLongShort.backgroundColor=self.PositionModel.cmd_BackgColor;
    lb_OrderLongShort.frame=CGRectMake(0,(44-18)/2.0, 64, 18);
    
    
    
    UILabel *lb1=[[UILabel alloc]init];
    lb1.text=self.PositionModel.symbol;
    lb1.font=GXFONT_PingFangSC_Regular(15);
    lb1.textColor=GXColor(18, 29, 61, 1);
    [lb1 sizeToFit];
    [vv addSubview:lb1];
    lb1.frame=CGRectMake(lb_OrderLongShort.frame.origin.x+lb_OrderLongShort.frame.size.width +10, (44-lb1.bounds.size.height)/2.0, lb1.bounds.size.width, lb1.bounds.size.height);
    vv.frame=CGRectMake((GXScreenWidth-(lb1.frame.origin.x+lb1.frame.size.width))/2.0, 0, lb1.frame.origin.x+lb1.frame.size.width, 44);
    
    self.navigationItem.titleView=vv;
    
}
-(void)setKView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 140)];
    vv.backgroundColor=GXRGBColor(239, 239, 243);
    kView=vv;
    
    klineV=[[CloseKView alloc]initWithFrame:CGRectMake(10, 10, GXScreenWidth-20, 120)];
    klineV.backgroundColor=[UIColor whiteColor];
    klineV.code=self.PositionModel.symbolCode;
    [vv addSubview:klineV];
 
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapKview)];
    [kView addGestureRecognizer:tap];
    kView.userInteractionEnabled=YES;
}

-(void)tapKview
{
    if(marketModel)
    {
        XHBPriceDetailViewController *detail=[[XHBPriceDetailViewController alloc]init];
        detail.fromLimitEnter=YES;
        detail.marketModel=marketModel;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

-(void)setContentView
{
    if(ContentView)
    {
        [ContentView removeFromSuperview];
        ContentView=nil;
    }
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 55*4)];
    vv.backgroundColor=[UIColor whiteColor];
    ContentView=vv;
    
    NSArray *valueAr=@[self.PositionModel.openTime,self.PositionModel.ticket,self.PositionModel.openPrice,self.PositionModel.closePrice,self.PositionModel.volume,self.PositionModel.swapsCommission_str,self.PositionModel.sl_str,self.PositionModel.tp_str];
    
    
    NSArray *ar=@[@"挂单时间",@"订单号",@"挂单价格",@"现在价格",@"交易手数",@"交易金额",@"止损价格",@"止盈价格"];
    for (int i=0; i<[ar count]; i++) {
        
        float w=GXScreenWidth/2.0;
        int x=i%2;
        int y=i/2;
        
        UIView *childV=[[UIView alloc]initWithFrame:CGRectMake(w*x, y*55, w, 55)];
        [vv addSubview:childV];
        if(x==0)
        {
            [self.view setBorderWithView:childV top:YES left:NO bottom:NO right:YES borderColor:GXRGBColor(231, 231, 231) borderWidth:0.5];
        }else
            [self.view setBorderWithView:childV top:YES left:NO bottom:NO right:NO borderColor:GXRGBColor(231, 231, 231) borderWidth:0.5];
        
        
        UILabel *lb1=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, w, 20)];
        lb1.text=ar[i];
        lb1.textAlignment=NSTextAlignmentCenter;
        lb1.font=GXFONT_PingFangSC_Regular(12);
        lb1.textColor=GXColor(165, 165, 165, 1);
        [childV addSubview:lb1];
        
        
        UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, w, 30)];
        lb2.text=@"--";
        lb2.textAlignment=NSTextAlignmentCenter;
        lb2.font=GXFONT_PingFangSC_Regular(14);
        lb2.textColor=GXColor(51, 51, 51, 1);
        lb2.tag=tag_contentviewLabel+i;
        [childV addSubview:lb2];
        
        lb2.text=valueAr[i];
        
    }
}


-(void)setButtonView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 75)];
    vv.backgroundColor=[UIColor clearColor];
    ButtonView=vv;
    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(15, 30, GXScreenWidth-30, 45)];
    btn1.backgroundColor=GXColor(254, 136, 42, 1);
    btn1.layer.cornerRadius=4;
    btn1.titleLabel.font=GXFONT_PingFangSC_Medium(16);
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"撤单" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(chedan) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:btn1];
    
}

#pragma mark -

-(void)chedan
{
    if(tradeAlerV)
    {
        [tradeAlerV removeFromSuperview];
        tradeAlerV=nil;
    }
    tradeAlerV=[[XHBTradeAlertView alloc]initWithTitle:self.PositionModel.symbol leftText:@[@"挂单价格",@"现在价格",@"交易手数",@"止盈价格",@"止损价格"]];
    tradeAlerV.delegate=(id)self;
    
    [tradeAlerV setOrderCloseButtonText:@"确认撤单" backgroundColor:GXRGBColor(254, 136, 42)];
    [self.view.window addSubview:tradeAlerV];
    
    [tradeAlerV setAlerRightData:@[self.PositionModel.openPrice,self.PositionModel.closePrice,self.PositionModel.volume,([self.PositionModel.tp doubleValue]==0?@"未设置":self.PositionModel.tp),([self.PositionModel.sl doubleValue]==0?@"未设置":self.PositionModel.sl)]];
}
#define mark - XHBTradeAlertViewdelegate
-(void)XHBTradeAlertViewDelegate_done
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交撤单"];
    
    [GXHttpTool POST:GXUrl_appordercancel parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"order":self.PositionModel.ticket} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            [self.view removeTipView];
            [self.view showSuccessWithTitle:@"撤单成功"];
            
            
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
