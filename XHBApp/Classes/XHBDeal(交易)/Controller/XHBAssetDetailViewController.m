//
//  XHBAssetDetailViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAssetDetailViewController.h"
#import "HistoryListFilterView.h"
#import "noDataShowView.h"
#import "XHBDealConst.h"
#import "AssetDetailListModel.h"
#import "AssetDetailTableViewCell.h"

@interface XHBAssetDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask;//请求任务
    
    noDataShowView *noDataView;
    UITableView *listmenu;
    NSMutableArray *assetListAr;
    
    HistoryListFilterView *historyFilterV;//筛选
    UIView *ListFilterHeaderV;//条件提示视图,头视图
    
    NSString *beginTime;
    NSString *endTime;
    NSInteger currentPage;
    NSInteger pageSize;
    
}
@end

@implementation XHBAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"转账明细";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:0 target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT) style:UITableViewStyleGrouped];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
    listmenu.separatorStyle=UITableViewCellSeparatorStyleNone;
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    
    
//    listmenu.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
//    listmenu.mj_header.automaticallyChangeAlpha = YES;
//    [listmenu.mj_header beginRefreshing];

    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    listmenu.mj_header = header;
    [listmenu.mj_header beginRefreshing];
    
    listmenu.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
    
    
    
    
    //头视图
    ListFilterHeaderV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 30)];
    ListFilterHeaderV.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbTit=[[UILabel alloc]init];
    lbTit.text=@"条件：";
    lbTit.textColor=GXGray_priceDetailTrade_TextColor;
    lbTit.font=GXFONT_PingFangSC_Regular(12);
    [lbTit sizeToFit];
    lbTit.frame=CGRectMake(15, 0, lbTit.bounds.size.width, CGRectGetHeight(ListFilterHeaderV.frame));
    [ListFilterHeaderV addSubview:lbTit];
    
    UILabel *lb_tip=[[UILabel alloc]initWithFrame:CGRectMake(lbTit.frame.origin.x+lbTit.frame.size.width, 0, 200, CGRectGetHeight(ListFilterHeaderV.frame))];
    lb_tip.text=@"近一周";
    lb_tip.font=GXFONT_PingFangSC_Regular(12);
    lb_tip.textColor=GXMainColor;
    [ListFilterHeaderV addSubview:lb_tip];
    
    UILabel *lb_totalLot=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth-100-20, 0, 100, CGRectGetHeight(ListFilterHeaderV.frame))];
    lb_totalLot.text=@"共--笔";
    lb_totalLot.font=GXFONT_PingFangSC_Regular(12);
    lb_totalLot.textColor=GXMainColor;
    lb_totalLot.textAlignment=NSTextAlignmentRight;
    [ListFilterHeaderV addSubview:lb_totalLot];
    
    listmenu.tableHeaderView=ListFilterHeaderV;
    
    
    
    //空值view
    noDataView=[[noDataShowView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, listmenu.frame.size.height)];
    [noDataView setTextTip:@"您暂无转账明细!"];
    noDataView.hidden=YES;
    [listmenu addSubview:noDataView];
    
    
    //筛选bar
    historyFilterV=[[HistoryListFilterView alloc]init];
    historyFilterV.delegate=(id)self;
    [self.view addSubview:historyFilterV];
    
    
    
    //初始化cell数据数组
    assetListAr=[[NSMutableArray alloc]init];
    
    
    //初始化选择周期,默认7天
    beginTime=[GXInstance getnNetworkDate:-6];
    endTime=[GXInstance getnNetworkDate:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    [listmenu.mj_header endRefreshing];
    [listmenu.mj_footer endRefreshing];
}

-(void)rightButton
{
    [historyFilterV setSelectTimeViewShow];
}

-(void)headerRefreshing{
    
    currentPage=1;
    pageSize=10;
    
    [self getList];
}

-(void)refreshMoreData
{
    currentPage+=1;
    
    if([assetListAr count]==0)
    {
        currentPage=1;
    }
    [self getList];
}
//请求列表数据
-(void)getList
{
    NSDictionary *par=@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"beginTime":beginTime,@"endTime":endTime,@"currentPage":[NSString stringWithFormat:@"%ld",currentPage],@"pageSize":[NSString stringWithFormat:@"%ld",pageSize]};
    
    dataTask= [GXHttpTool Get:GXUrl_getfinancedetail parameters:par success:^(id responseObject) {
        [self dataTaskSuccess:responseObject];
    } failure:^(NSError *error) {if(error.code!=-999){
        [self dataTaskError];
    }
    }];
}

-(void)dataTaskError
{
    dataTask=nil;
    
    [listmenu.mj_header endRefreshing];
    [listmenu.mj_footer endRefreshing];
}

-(void)dataTaskSuccess:(id)responseObject
{
    dataTask=nil;
    
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
    {
        GXLog(@"%@",[responseObject mj_JSONString]);
        
        if(currentPage==1)
        {
            [assetListAr removeAllObjects];
        }
        
        if(!responseObject[@"value"])
        {
            [self tableviewNOData];
        }
        else if([responseObject[@"value"] count]==0)
        {
            [self tableviewNOData];
        }
        else if([responseObject[@"value"][@"resultList"] count]==0)
        {
            [self tableviewNOData];
        }else
        {
            NSMutableArray *ar=[AssetDetailListModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"][@"resultList"]];
            
            for (int i=0; i<[ar count]; i++) {
                
                AssetDetailListModel *model=ar[i];
                
                model.total=[NSString stringWithFormat:@"%@",responseObject[@"value"][@"total"]];
                //更新筛选bar上的手数总计
                if(i==[ar count]-1)
                {
                    UILabel *totalLot=[[ListFilterHeaderV subviews] lastObject];
                    totalLot.text=[NSString stringWithFormat:@"共%@笔",model.total];
                }
                
               [assetListAr addObject:model];
            }
            ar=nil;

            GXLog(@"%@",assetListAr);
            [listmenu reloadData];
            
            [listmenu.mj_header endRefreshing];
            [listmenu.mj_footer endRefreshing];
            
            noDataView.hidden=YES;
        }
    }
}

-(void)tableviewNOData
{
    [listmenu.mj_header endRefreshing];
    
    if([assetListAr count]==0)
    {
        [listmenu.mj_footer endRefreshing];
        noDataView.hidden=NO;
    }
    else
    {
        [listmenu.mj_footer endRefreshingWithNoMoreData];
    }
    
    [listmenu reloadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return assetListAr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 114;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    AssetDetailTableViewCell *cell = (AssetDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AssetDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        cell.lb_operationtype.layer.masksToBounds=YES;
        cell.lb_operationtype.layer.cornerRadius=2;
        
    }
    AssetDetailListModel *model=assetListAr[indexPath.section];
    cell.lb_drawnumberid.text=model.drawnumberid;
    cell.lb_operationtype.text=model.operationtype_text;
    cell.lb_operationtype.backgroundColor=model.operationtype_color;
    cell.lb_bankname.text=model.bankname;
    cell.lb_amountnum.attributedText=model.amountnum_att;
    model.amountnum_att=nil;
    cell.lb_tradetime.text=model.tradetime;
    cell.lb_status.text=model.status_text;
    cell.lb_status.textColor=model.status_color;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)HistoryListFilterViewDelegate_tit:(NSString *)tit startTime:(NSString *)sTime endTime:(NSString *)eTime
{
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    UILabel *totalLot=[[ListFilterHeaderV subviews] objectAtIndex:1];
    totalLot.text=tit;
    
    beginTime=sTime;
    endTime=[self changeTime:eTime];
    if(listmenu.mj_header.state==MJRefreshStateRefreshing)
    {
        [self headerRefreshing];
    }else
    {
        [listmenu.mj_header beginRefreshing];
    }
    
}
-(NSString *)changeTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
                                  
    NSDate* date = [formatter dateFromString:time];
    
    NSInteger timel=(long)[date timeIntervalSince1970]+3600*24;
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timel];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
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
