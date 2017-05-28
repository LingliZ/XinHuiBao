//
//  XHBTradeRootViewController.m
//  XHBApp
//
//  Created by shenqilong on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTradeRootViewController.h"
#import "XHBTimelyTradeViewController.h"
#import "XHBPositionMoreViewController.h"
#import "NinaPagerView.h"
#import "XHBTraderUserMaginModel.h"
@interface XHBTradeRootViewController ()
{
    XHBTimelyTradeViewController *t1;
    XHBTimelyTradeViewController *t2;
    XHBPositionMoreViewController *t3;
    
    NSURLSessionDataTask *dataTask_Kdata;

    NSURLSessionDataTask *dataTask_Price;
    NSTimer *timer;
    
    NinaPagerView *inPagerView;
}
@end

@implementation XHBTradeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"交易";
    
    
    
    if(!self.TradeCode)
    {
        self.TradeCode=@"llg";
    }
    if(!self.TradeDirection)
    {
        self.TradeDirection=0;
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(priceReresh:) name:@"tradeVCPriceReresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLineDateReresh:) name:@"tradeVCKLineDateReresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMarginRefreshing) name:@"userMarginReresh" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromTradeEnterPriceDetailVC:) name:@"fromTradeEnterPriceDetailVC" object:nil];
    
    
    
    t1=[[XHBTimelyTradeViewController alloc]init];
    t1.TradeCode=self.TradeCode;
    t1.TradeDirection=self.TradeDirection;
    t1.isOpen1=YES;
    
    t2=[[XHBTimelyTradeViewController alloc]init];
    t2.TradeCode=self.TradeCode;
    t2.isOpen2=YES;
    
    t3=[[XHBPositionMoreViewController alloc]init];
    
    
    
    
    inPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:@[@"即时交易",@"挂单交易",@"当前持仓"] WithVCs:@[t1,t2,t3] WithColorArrays:@[GXRGBColor(254, 121, 32),GXRGBColor(165 , 165, 165),GXRGBColor(254, 121, 32),GXRGBColor(255, 255, 255)] WithDefaultIndex:self.twobarIndex];
    inPagerView.titleScale = 1;
    inPagerView.delegate = (id)self;
    [self.view addSubview:inPagerView];
    inPagerView.pushEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
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
    
    if(dataTask_Kdata)
    {
        [dataTask_Kdata cancel];
        dataTask_Kdata=nil;
    }
    
    GXInstance.trade_userMarginModel=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (BOOL)deallocVCsIfUnnecessary
{
    return YES;
}

- (void)ninaCurrentPageIndex:(NSString *)currentPage
{
    if([currentPage integerValue]== 2)
    {
        [self userMarginRefreshing];
    }
}
#pragma mark -
//请求资金账户数据
- (void)userMarginRefreshing{
    [GXHttpTool Get:GXUrl_appqtaccount parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId]} success:^(id responseObject){
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            GXInstance.trade_userMarginModel = [XHBTraderUserMaginModel mj_objectWithKeyValues:[responseObject[GXValue] firstObject]];
            
            
            [t1 updateUserMagin];
            [t2 updateUserMagin];
            [t3 updateUserMagin];
            
        }else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -
-(void)kLineDateReresh:(NSNotification *)notification
{
    if(notification.object)
    {
        self.TradeCode=notification.object;
        
        t1.TradeCode=self.TradeCode;
        t2.TradeCode=self.TradeCode;
    }

    if(dataTask_Kdata)
    {
        [dataTask_Kdata cancel];
        dataTask_Kdata=nil;
    }
    
    
    dataTask_Kdata=[GXHttpTool POST:GXUrl_kline parameters:@{@"maxrecords":@"50",@"code":self.TradeCode,@"level":@"60"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            [t1 updateKdata:responseObject[@"value"]];
            
            [t2 updateKdata:responseObject[@"value"]];
        }
        
        dataTask_Kdata=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_Kdata=nil;
    }];

}

-(void)priceReresh:(NSNotification *)notification
{
    if(notification.object)
    {
        if([notification.object isKindOfClass:[NSArray class]])
        {
            self.TradeCode=notification.object[0];
            
            t1.TradeCode=self.TradeCode;
            t2.TradeCode=self.TradeCode;
            
            [t1 setLabelAndTextFieldDefault];
            [t2 setLabelAndTextFieldDefault];
        }else
        {
            self.TradeCode=notification.object;
            
            t1.TradeCode=self.TradeCode;
            t2.TradeCode=self.TradeCode;
        }
    }
    
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
    [self priceTimerRereshing];
    //刷行情
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(priceTimerRereshing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)priceTimerRereshing
{
    if(dataTask_Price)
    {
        return;
    }
    
    dataTask_Price =[GXHttpTool POST:GXUrl_quotation parameters:@{@"code":self.TradeCode} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            NSArray *ar=responseObject[@"value"];
         
            [t1 updateCodePrice:ar];
            
            [t2 updateCodePrice:ar];
        }
        
        dataTask_Price=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_Price=nil;
    }];
}

#pragma mark -

-(void)fromTradeEnterPriceDetailVC:(NSNotification *)notification {
    
    //barTouchIndex 行情detail下面的bar点击事件 0做空 1做多 2持仓
    int barTouchIndex=[notification.object intValue];
    
    int a=0;
    if(barTouchIndex==2)
    {
        a=2;
    }

    if(barTouchIndex==0)
    {
        t1.TradeDirection=1;
    }else
    {
        t1.TradeDirection=0;
    }
    [t1 setDirectionButtonTitle];
    
    NinaBaseView *ninaBaseV =  (NinaBaseView *)inPagerView.pagerView;
    UIButton *titleBtn = (UIButton *)ninaBaseV.subviews[0].subviews[a];
    if ([ninaBaseV respondsToSelector:NSSelectorFromString(@"touchAction:")]) {
        [ninaBaseV performSelectorOnMainThread:NSSelectorFromString(@"touchAction:") withObject:titleBtn waitUntilDone:YES];
    }
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
