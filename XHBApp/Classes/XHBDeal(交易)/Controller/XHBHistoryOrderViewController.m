//
//  XHBHistoryOrderViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBHistoryOrderViewController.h"
#import "HistoryListFilterView.h"
#import "noDataShowView.h"
#import "XHBDealConst.h"
#import "HistoryListTableViewCell.h"
#import "XHBTradePositionModel.h"
#import "XHBHistoryDetailViewController.h"

@interface XHBHistoryOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask;//请求任务
    
    noDataShowView *noDataView;
    UITableView *listmenu;
    NSMutableArray *historyListAr;
    
    HistoryListFilterView *historyFilterV;//筛选
    UIView *ListFilterHeaderV;//条件提示视图,头视图
    
    NSString *starttime;
    NSString *endtime;
    NSInteger offset;
    NSInteger length;
    
}
@end

@implementation XHBHistoryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"交易历史";

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:0 target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT) style:UITableViewStyleGrouped];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];

    
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
    lb_totalLot.text=@"共--手";
    lb_totalLot.font=GXFONT_PingFangSC_Regular(12);
    lb_totalLot.textColor=GXMainColor;
    lb_totalLot.textAlignment=NSTextAlignmentRight;
    [ListFilterHeaderV addSubview:lb_totalLot];

    listmenu.tableHeaderView=ListFilterHeaderV;
    
    
    
    //空值view
    noDataView=[[noDataShowView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, listmenu.frame.size.height)];
    [noDataView setTextTip:@"您暂无历史仓单!"];
    noDataView.hidden=YES;
    [listmenu addSubview:noDataView];

   
    //筛选bar
    historyFilterV=[[HistoryListFilterView alloc]init];
    historyFilterV.delegate=(id)self;
    [self.view addSubview:historyFilterV];
    
    
    //初始化历史cell数据数组
    historyListAr=[[NSMutableArray alloc]init];
    
    
    //初始化选择周期,默认7天
    starttime=[GXInstance getnNetworkDate:-6];
    endtime=[GXInstance getnNetworkDate:1];
    
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
    
    offset=0;
    length=10;
 
    [self getHistoryList];
}

-(void)refreshMoreData
{
    offset+=length;
    
    if([historyListAr count]==0)
    {
        offset=0;
    }
    [self getHistoryList];
}
//请求历史列表数据
-(void)getHistoryList
{
    NSDictionary *par=@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"starttime":starttime,@"endtime":endtime,@"offset":[NSString stringWithFormat:@"%ld",offset],@"len":[NSString stringWithFormat:@"%ld",length]};
    
    dataTask= [GXHttpTool Get:GXUrl_appmt4historyorder parameters:par success:^(id responseObject) {
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
        
        if(offset==0)
        {
            [historyListAr removeAllObjects];
        }
        
        if(!responseObject[@"value"])
        {
            [self tableviewNOData];
        }
        else if([responseObject[@"value"] count]==0)
        {
            [self tableviewNOData];
        }
        else
        {
            NSMutableArray *ar=[XHBTradePositionModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            for (int i=0; i<[ar count]; i++) {
                
                XHBTradePositionModel *model=ar[i];
    
                
                //更新筛选bar上的手数总计
                if(i==[ar count]-1)
                {
                    UILabel *totalLot=[[ListFilterHeaderV subviews] lastObject];
                    totalLot.text=[NSString stringWithFormat:@"共%@手",model.TotalLots];
                }
                
                
                BOOL isNewDic=YES;
                
                for (NSMutableDictionary *dic in historyListAr) {
                    if([model.openTime_noHMM isEqualToString:[dic objectForKey:@"time"]])
                    {
                        [[dic objectForKey:@"data"]addObject:model];
                        
                        isNewDic=NO;
                    }
                }
                
                if(isNewDic)
                {
                    NSMutableArray *newar=[[NSMutableArray alloc]init];
                    [newar addObject:model];
                    
                    NSMutableDictionary *newdic=[[NSMutableDictionary alloc]init];
                    
                    [newdic setObject:newar forKey:@"data"];
                    [newdic setObject:model.openTime_noHMM forKey:@"time"];
                    
                    UIView *titv=[self setTableViewTitV:model.openTime_noHMM];
                    [newdic setObject:titv forKey:@"titView"];
                    
                    [historyListAr addObject:newdic];
                    
                    titv=nil;
                    newdic=nil;
                    newar=nil;
                }
                
            }
            ar=nil;
            
            GXLog(@"%@",historyListAr);
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
    
    if([historyListAr count]==0)
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

-(UIView *)setTableViewTitV:(NSString *)text
{
    UIView *table_titView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 44)];
    table_titView.backgroundColor=listmenu.backgroundColor;
    
    UILabel *lbtime=[[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth-103)/2.0, (44-20)/2.0, 103, 20)];
    lbtime.layer.masksToBounds=YES;
    lbtime.layer.cornerRadius=4;
    lbtime.backgroundColor=GXGray_HistoryListTimeBackgColor;
    lbtime.textColor=[UIColor whiteColor];
    lbtime.textAlignment=NSTextAlignmentCenter;
    lbtime.font=GXFONT_PingFangSC_Regular(12);
    lbtime.text=text;
    [table_titView addSubview:lbtime];
    
    return table_titView;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return historyListAr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return historyList_tableView_cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[historyListAr objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryListTableViewCell *cell = [HistoryListTableViewCell cellWithTableView:tableView];
    cell.hModel = historyListAr[indexPath.section][@"data"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    XHBTradePositionModel *model=[[historyListAr objectAtIndex:indexPath.section] objectForKey:@"data"][indexPath.row];
    
    if([model.cmd intValue]==0||[model.cmd intValue]==1||[model.cmd intValue]==2||[model.cmd intValue]==3||[model.cmd intValue]==4||[model.cmd intValue]==5)
    {
        XHBHistoryDetailViewController *h=[[XHBHistoryDetailViewController alloc]init];
        h.historyModel=model;
        [self.navigationController pushViewController:h animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  [[historyListAr objectAtIndex:section] objectForKey:@"titView"];
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
    
    starttime=sTime;
    endtime=[self changeTime:eTime];
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
