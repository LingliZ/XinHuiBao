//
//  XHBPriceDetailViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBPriceDetailViewController.h"
#import "XHBDealConst.h"
#import "PriceDetailHeaderView.h"
#import "PriceMarketModel.h"
#import "PriceDetailKSelectBarView.h"
#import "PriceDetailTabbarView.h"
#import "PriceDetailTradeView.h"
#import "PriceUserTradeMarginModel.h"
#import "XHBInGoldViewController.h"
#import "XHBLoginViewController.h"

#import "CCSKLineWithIndexChart.h"
#import "CCSTimeLineChart.h"
#import "CCSTimeLineData.h"
#import "CCSTimeLineItemData.h"
#import "CCSKLineData.h"
#import "GXSmaAverageModel.h"

#import "XHBTradeRootViewController.h"

#define IntervalRefesh 2.0

@interface XHBPriceDetailViewController ()<CCSTimeLineChartDelegate,CCSKLineChartDelegate>
{
    NSURLSessionDataTask *dataTask;//请求任务
    NSURLSessionDataTask *dataTask_userMargin;
    UIScrollView *rootScrollv; // 行情一级列表
    NSTimer *timer; // 定时器
    PriceDetailHeaderView *priceDetailV;
    PriceDetailTradeView *tradeView;
    
    BOOL isCancel;
    
    NSString *klineHttpInd;//k线请求时段类型
    
    PriceDetailKSelectBarView *kbarView;
}

// 分时图
@property(strong, nonatomic) CCSTimeLineChart  *timeLineChart;
// K线图
@property(strong, nonatomic) CCSKLineWithIndexChart *kLineChart;
// 时段模型
@property (nonatomic, strong) NSMutableArray *CCSSmaModelsArray;
// 指标模型
@property (nonatomic, strong) GXSmaAverageModel *SmaAverageModel;




@end

@implementation XHBPriceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(navButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setNavTitView];
    
    
    rootScrollv=[[UIScrollView alloc]init];
    rootScrollv.bounces=YES;
    [self.view addSubview:rootScrollv];
    
    
    //初始化详细报价视图
    priceDetailV = [[PriceDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, priceDetailHeaderView_height)];
    [priceDetailV setPriceDetailView:self.marketModel];
    priceDetailV.delegate=(id)self;
    [self.view setBorderWithView:priceDetailV top:NO left:NO bottom:YES right:NO borderColor:GXRGBColor(242, 243, 243) borderWidth:1];
    [rootScrollv addSubview:priceDetailV];
    
    
    
    //判断是否可交易
    float barHeight=0;
    if(!self.marketModel.status_hidden)
    {
        //tabbar
        PriceDetailTabbarView *detabbar=[[PriceDetailTabbarView alloc]init];
        detabbar.delegate=(id)self;
        [self.view addSubview:detabbar];
        [detabbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).equalTo(@0);
            make.right.equalTo(self.view.mas_right).equalTo(@0);
            make.bottom.equalTo(self.view.mas_bottom).equalTo(@0);
            make.height.equalTo(@priceDetailTabbar_height);
        }];
        
        barHeight=priceDetailTabbar_height;
    }
    
    rootScrollv.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-barHeight);
    rootScrollv.contentSize=CGSizeMake(GXScreenWidth, rootScrollv.frame.size.height+1);
    
    
    
    
    //添加分时
    CCSTimeLineChart *timeLineChart = [[CCSTimeLineChart alloc] initWithFrame:CGRectMake(0, priceDetailHeaderView_height+priceDetailKSelectBarView_height, GXScreenWidth, rootScrollv.frame.size.height-priceDetailHeaderView_height-priceDetailKSelectBarView_height)];
    [rootScrollv addSubview:timeLineChart];
    self.timeLineChart = timeLineChart;
    self.timeLineChart.timeLineChartDelegate = self;
    [self.timeLineChart setNeedsDisplay];
    
    
    // 添加K线图
    CCSKLineWithIndexChart *klineChart = [[CCSKLineWithIndexChart alloc] initWithFrame:timeLineChart.frame];
    [rootScrollv addSubview:klineChart];
    self.kLineChart = klineChart;
    self.kLineChart.kLineChartDelegate = self;
    self.kLineChart.hidden = YES;
    self.kLineChart.marketModel = self.marketModel;
    
    
    //图形周期选择bar
    kbarView=[[PriceDetailKSelectBarView alloc]initWithFrame:CGRectMake(0, priceDetailHeaderView_height, GXScreenWidth, priceDetailKSelectBarView_height)];
    kbarView.delegate=(id)self;
    [rootScrollv addSubview:kbarView];
    
   
    
    
    //加载分时
    [self loadTimeChartWithActivityIndicator];
    
    
    //分时和k线的触碰的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ccsChartTouch:) name:@"ccsChartTouch" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBarTintColor:self.marketModel.lastColor];
 
    isCancel=NO;
    
    [self headerRefreshing];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:IntervalRefesh target:self selector:@selector(headerRefreshing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    //创建建仓视图
    [self setInitOrderView];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBarTintColor:GXNavigationBarBackColor];
    
    isCancel=YES;
    
    [self timerInvalidate];
    [self taskCancel_head];
    [self taskCancel_margin];
    
    
    //必须移除建仓视图
    [tradeView removeFromSuperview];
    tradeView=nil;
}

-(void)setNavTitView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];

    UILabel *lb=[[UILabel alloc]init];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=GXFONT_PingFangSC_Regular(16);
    lb.text=[NSString stringWithFormat:@"%@(%@)",self.marketModel.customTag1,self.marketModel.name];
    lb.textColor=GXRGBColor(51, 51, 51);
    [vv addSubview:lb];
    

    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@3);
        make.height.equalTo(@20);

    }];
    
    
    UILabel *lb2=[[UILabel alloc]init];
    lb2.textAlignment=NSTextAlignmentCenter;
    lb2.font=GXFONT_PingFangSC_Regular(10.4);
    lb2.text=[NSString stringWithFormat:@"%@ %@",self.marketModel.status,self.marketModel.quoteTime];
    lb2.textColor=GXRGBColor(165, 165, 165);
    [vv addSubview:lb2];
    
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@25);
        make.height.equalTo(@20);
        
    }];
    
    self.navigationItem.titleView=vv;
    
    
}

-(void)timerInvalidate
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)taskCancel_head
{
    if(dataTask)
    {
        [dataTask cancel];
    }
}

-(void)taskCancel_margin
{
    if(dataTask_userMargin)
    {
        [dataTask_userMargin cancel];
    }
}

-(void)navButtonClick
{
    if(self.kLineChart.hidden==YES)
    {
        [self loadTimeChartWithActivityIndicator];
    }else
    {
        [self loadKLineChartDataWithInterVal:klineHttpInd];
    }
}

-(void)ccsChartTouch:(id)obj
{
    GXLog(@"%@",obj);
    [kbarView KSelectBarViewCloseMorebar];
}

#pragma mark - priceDetailHeaderDelegate
-(void)priceDetailHeaderDelegate_buyClick {
    [self PriceDetailTabbarBtnClick:1];
}
-(void)priceDetailHeaderDelegate_sellClick {
    [self PriceDetailTabbarBtnClick:0];
}

#pragma mark - 创建建仓视图
-(void)setInitOrderView
{
    //交易页面
    tradeView=[[PriceDetailTradeView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
    tradeView.delegate=(id)self;
    [tradeView setPriceShowView:self.marketModel];
    [self.navigationController.view addSubview:tradeView];
}

#pragma mark - 详情报价
- (void)headerRefreshing{
    
    if(dataTask)
    {
        return;
    }
    
    dataTask=[GXHttpTool POST:GXUrl_quotation parameters:@{@"code":self.marketModel.code} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            
            NSMutableArray *priceListArray=[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            if([priceListArray count]>0)
            {
                //更新基础报价的model
                self.marketModel=priceListArray[0];
                priceListArray=nil;
                
                //更新上面报价详情视图的数据
                [priceDetailV setPriceDetailView:self.marketModel];
                
                //根据开盘价变化导航颜色
//                if(!isCancel)
//                [self.navigationController.navigationBar setBarTintColor:self.marketModel.lastColor];
                
                //更新交易视图的model
                [tradeView setPriceShowView:self.marketModel];
                
                
                
                UILabel *lb=[[self.navigationItem.titleView subviews] lastObject];
                lb.text=[NSString stringWithFormat:@"%@ %@",self.marketModel.status,self.marketModel.quoteTime];
            }
        }
        
        dataTask=nil;
        
    } failure:^(NSError *error) {
        
        dataTask=nil;
    }];
    
}

#pragma mark - k线周期bar
-(void)PriceDetailSelectKBarViewDelegate:(NSInteger)deleIndex barTit:(NSString *)tit httpPostInd:(NSString *)ind
{
    GXLog(@"%ld,%@,%@",deleIndex,tit,ind);
    
    klineHttpInd=ind;
    
    if(deleIndex==0)
    {
        [self loadTimeChartWithActivityIndicator];
        self.kLineChart.hidden = YES;
        self.timeLineChart.hidden=NO;
    }else
    {
        [self loadKLineChartDataWithInterVal:ind];
        self.kLineChart.hidden = NO;
        self.timeLineChart.hidden=YES;
    }
}

- (void)loadTimeChartWithActivityIndicator{
    GXLog(@"请求分时图数据");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = self.marketModel.code;
    param[@"period"] = @"1";
    
    [GXHttpTool POSTCache:GXUrl_timeline parameters:param success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            NSArray *lineData = [CCSTimeLineData mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            if([lineData count]>0){
                [self.timeLineChart setTimeLineData:[lineData objectAtIndex:0]];
                [self.timeLineChart setNeedsDisplay];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//加载k线数据
- (void)loadKLineChartDataWithInterVal:(NSString *)interval {
    GXLog(@"请求K线图数据");
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"maxrecords"] = @"200";
    param[@"code"] = self.marketModel.code;
    param[@"level"] = interval;
    
    [GXHttpTool POSTCache:GXUrl_kline parameters:param success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            NSMutableArray *klineDataArray = [CCSKLineItemData mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            CCSKLineData *klineData = [[CCSKLineData alloc] init];
            klineData.data = klineDataArray;
            
            // 默认指标
            [self.kLineChart setIndex:self.SmaAverageModel.kLineChartIndexTopType kLineChartIndexBottomType:self.SmaAverageModel.kLineChartIndexBottomType smaParamArray:self.SmaAverageModel.paramArray];
            [self.kLineChart setKLineData:klineData interval:interval];
            [self.kLineChart reloadFrame];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (GXSmaAverageModel *)SmaAverageModel {
    if (!_SmaAverageModel) {
        _SmaAverageModel = [[GXSmaAverageModel alloc] init];
        _SmaAverageModel.kLineChartIndexTopType = MA;
        _SmaAverageModel.kLineChartIndexBottomType = MACD;
        _SmaAverageModel.paramArray = self.CCSSmaModelsArray;
    }
    return _SmaAverageModel;
}

- (NSMutableArray *)CCSSmaModelsArray {
    if (!_CCSSmaModelsArray) {
        _CCSSmaModelsArray = [NSMutableArray array];
        // 读取本地
        if ([GXFileTool isExistFileName:GXPriceMAsetControllerUserFilePath]) {
            NSArray *array = [GXFileTool readCCSSmaUnarchiverArrayByFileName:GXPriceMAsetControllerUserFilePath];
            _CCSSmaModelsArray = array.mutableCopy;
            // 创建默认数值
        } else {
            for (int i = 0; i < 3; i++) {
                CCSSMAParam *param = [[CCSSMAParam alloc] init];
                if (i == 2) {
                    param.period = 20;
                } else {
                    param.period = (i+1) * 5;
                }
                param.tag = i;
                [_CCSSmaModelsArray addObject:param];
            }
        }
    }
    return _CCSSmaModelsArray;
}
#pragma mark - tabbar（做空0 做多1 持仓2）
-(void)PriceDetailTabbarBtnClick:(NSInteger)barTouchIndex
{
    GXLog(@"%ld",barTouchIndex);
    
    if(self.fromTradeEnter)//从交易点进来
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromTradeEnterPriceDetailVC" object:[NSString stringWithFormat:@"%ld",barTouchIndex] userInfo:nil];
        
        return;
    }
    if(self.fromLimitEnter)
    {
        NSMutableArray *vcAr=[[NSMutableArray alloc]init];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if(![vc isKindOfClass: NSClassFromString(@"XHBLimitOrderDetailViewController")] && ![vc isKindOfClass: NSClassFromString(@"XHBLimitOrderViewController")])
            {
                [vcAr addObject:vc];
            }
        }
        self.navigationController.viewControllers=vcAr;
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromTradeEnterPriceDetailVC" object:[NSString stringWithFormat:@"%ld",barTouchIndex] userInfo:nil];
        
        return;
    }
    if(self.fromCloseEnter)
    {
        NSMutableArray *vcAr=[[NSMutableArray alloc]init];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if(![vc isKindOfClass: NSClassFromString(@"XHBOrderCloseViewController")])
            {
                [vcAr addObject:vc];
            }
        }
        self.navigationController.viewControllers=vcAr;
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromTradeEnterPriceDetailVC" object:[NSString stringWithFormat:@"%ld",barTouchIndex] userInfo:nil];
        
        return;
    }
    
    
    
    if(![GXUserInfoTool isLogin])
    {
        XHBLoginViewController*loginVC=[[XHBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if(barTouchIndex==2)
    {
        XHBTradeRootViewController *pos=[[XHBTradeRootViewController alloc]init];
        pos.TradeCode=self.marketModel.code;
        pos.twobarIndex=2;
        [self.navigationController pushViewController:pos animated:YES];
        
    }else
    {
        XHBTradeRootViewController *pos=[[XHBTradeRootViewController alloc]init];
        if(barTouchIndex==0)
        {
            pos.TradeDirection=1;
        }else
        {
            pos.TradeDirection=0;
        }
        pos.TradeCode=self.marketModel.code;
        [self.navigationController pushViewController:pos animated:YES];
        
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
