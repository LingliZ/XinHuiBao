//
//  XHBDealViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBDealViewController.h"
#import "PriceHeaderView.h"
#import "PriceMarketModel.h"
#import "PriceMarketTableViewCell.h"
#import "XHBDealConst.h"
#import "XHBPriceDetailViewController.h"


#define IntervalRefesh 2


@interface XHBDealViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask;//请求任务;
    NSTimer *timer;
    UITableView *listmenu; // 行情一级列表
    NSMutableArray *priceListArray; // 行情一级数据
    PriceHeaderView *priceHeaderView;
    
}

@end

@implementation XHBDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    [self.view addSubview:listmenu];
    
    
    UILabel *tiplb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 30)];
    tiplb.text=@"行情信息2秒钟刷新一次，下拉可手动刷新";
    tiplb.textAlignment=NSTextAlignmentCenter;
    tiplb.textColor=GXGray_priceNameColor;
    tiplb.font=GXFONT_PingFangSC_Regular(12);
    listmenu.tableFooterView=tiplb;


    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    listmenu.mj_header = header;
    [header beginRefreshing];
    
    
    
    priceHeaderView = [[PriceHeaderView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![listmenu.mj_header isRefreshing])
    {
        [self headerRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }

    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    if([listmenu.mj_header isRefreshing])
       [listmenu.mj_header endRefreshing];
}

-(void)headerRefreshing
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    [self getList];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:IntervalRefesh target:self selector:@selector(getList) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//请求数据
-(void)getList
{
    if(dataTask)
    {
        return;
    }
    dataTask= [GXHttpTool POST:GXUrl_quotation parameters:@{@"code":@"llg,lls,$dxy,hf_cl"} success:^(id responseObject) {
        [self dataTaskSuccess:responseObject];
    } failure:^(NSError *error) {if(error.code!=-999){
        [self dataTaskError];
        }
    }];
}

-(void)dataTaskError
{
    if([priceListArray count]==0)
    {
        [self.view addNOWifiViewWithFrame:listmenu.frame refreshTarget:self refreshButton:@selector(aa)];
        
        if(timer)
        {
            [timer invalidate];
            timer = nil;
        }
    }
    
    
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
    
}
-(void)aa
{
    [self.view removeNOWifiView];
    
    [listmenu.mj_header beginRefreshing];
}

-(void)dataTaskSuccess:(id)responseObject
{
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
    {
        GXLog(@"%@",[responseObject mj_JSONString]);
        
        if(priceListArray)
        {
            [priceListArray removeAllObjects];
            priceListArray=nil;
        }
        priceListArray=[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        
        [listmenu reloadData];
    }
    
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
    
    
    [self.view removeNOWifiView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return priceList_tableView_cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return priceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceMarketTableViewCell *cell = [PriceMarketTableViewCell cellWithTableView:tableView];
    cell.marketModel = priceListArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceMarketModel *marketModel = priceListArray[indexPath.row];
    
    XHBPriceDetailViewController *priceDetailVC = [[XHBPriceDetailViewController alloc] init];
    priceDetailVC.marketModel = marketModel;
    [self.navigationController pushViewController:priceDetailVC animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  priceHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return priceHeaderView.frame.size.height;
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
