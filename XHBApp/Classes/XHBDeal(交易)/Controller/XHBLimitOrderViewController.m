//
//  XHBHistoryOrderViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBLimitOrderViewController.h"
#import "noDataShowView.h"
#import "XHBTradePositionModel.h"
#import "XHBOrderLimitTableViewCell.h"
#import "XHBLimitOrderDetailViewController.h"
@interface XHBLimitOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask;//请求任务
    
    noDataShowView *noDataView;
    UITableView *listmenu;
    NSMutableArray *ListAr;
    
    NSInteger offset;
    NSInteger length;
    
    NSTimer *timer;
    NSURLSessionTask *dataTask_PriceList;
    
}
@end

@implementation XHBLimitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"当前挂单";
    
    
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
    
    listmenu.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
    
    
    
    
    //空值view
    noDataView=[[noDataShowView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, listmenu.frame.size.height)];
    [noDataView setTextTip:@"您暂无挂单!"];
    noDataView.hidden=YES;
    [listmenu addSubview:noDataView];
    
    

    
    //初始化历史cell数据数组
    ListAr=[[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [listmenu.mj_header beginRefreshing];
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
    
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
}

-(void)headerRefreshing{
    
    offset=0;
    length=10;
    
    [self getHistoryList];
}

-(void)refreshMoreData
{
    offset+=length;
    
    if([ListAr count]==0)
    {
        offset=0;
    }
    [self getHistoryList];
}
//请求历史列表数据
-(void)getHistoryList
{
    
    dataTask= [GXHttpTool Get:GXUrl_appquerylimitorder parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"offset":[NSString stringWithFormat:@"%ld",offset],@"len":[NSString stringWithFormat:@"%ld",length]} success:^(id responseObject) {
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
            [ListAr removeAllObjects];
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
                
                
                
                BOOL isNewDic=YES;
                
                for (NSMutableDictionary *dic in ListAr) {
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
                    
                    [ListAr addObject:newdic];
                    
                    titv=nil;
                    newdic=nil;
                    newar=nil;
                }
                
            }
            ar=nil;
            
            GXLog(@"%@",ListAr);
            [listmenu reloadData];
            
            [listmenu.mj_header endRefreshing];
            [listmenu.mj_footer endRefreshing];
            
            noDataView.hidden=YES;
            
            
            //加载行情数据
            [self priceListRereshing];
            
            //刷行情
            if(timer)
            {
                [timer invalidate];
                timer=nil;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(priceListRereshing) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

        }
    }
}


//请求行情
-(void)priceListRereshing
{
    if(dataTask_PriceList)
    {
        return;
    }
    
    NSString *codeStr=@"";
    NSMutableArray *modelAr=[[NSMutableArray alloc]init];
    
    for (int j=0; j<[ListAr count]; j++) {
        NSDictionary *dic=ListAr[j];
        for (int i=0; i<[dic[@"data"] count]; i++) {
            XHBTradePositionModel *model=dic[@"data"][i];
            codeStr=[codeStr stringByAppendingString:model.symbolCode];
            if(i<[dic[@"data"] count]-1)
            {
                codeStr=[codeStr stringByAppendingString:@","];
            }
            [modelAr addObject:model];
        }
    }
    
    
    
    dataTask_PriceList =[GXHttpTool POST:GXUrl_quotation parameters:@{@"code":codeStr} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            NSArray *ar=responseObject[@"value"];
            
            if([ar count]==[modelAr count])
            {
                for (int i=0; i<[modelAr count]; i++) {
                    XHBTradePositionModel *model=modelAr[i];
                    
                    if([model.cmd integerValue]==2||[model.cmd integerValue]==4)
                    {
                        model.closePrice=ar[i][@"sell"];
                    }else
                    {
                        model.closePrice=ar[i][@"buy"];
                    }
                }
            }
            
            [listmenu reloadData];
        }
        
        dataTask_PriceList=nil;
        
        [self.view removeTipView];
        
    } failure:^(NSError *error) {
        
        dataTask_PriceList=nil;
        
        [self.view removeTipView];
        
    }];
    
}

-(void)tableviewNOData
{
    [listmenu.mj_header endRefreshing];
    
    if([ListAr count]==0)
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
    UIView *table_titView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 33)];
    table_titView.backgroundColor=listmenu.backgroundColor;
    
    UILabel *lbtime=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 33)];
    lbtime.layer.masksToBounds=YES;
    lbtime.layer.cornerRadius=4;
    lbtime.textColor=GXRGBColor(165, 165, 165);
    lbtime.textAlignment=NSTextAlignmentLeft;
    lbtime.font=GXFONT_PingFangSC_Regular(12);
    lbtime.text=text;
    [table_titView addSubview:lbtime];
    
    return table_titView;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return ListAr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[ListAr objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHBOrderLimitTableViewCell *cell = [XHBOrderLimitTableViewCell cellWithTableView:tableView];
    cell.pModel = ListAr[indexPath.section][@"data"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHBTradePositionModel *model=[[ListAr objectAtIndex:indexPath.section] objectForKey:@"data"][indexPath.row];

    XHBLimitOrderDetailViewController *h=[[XHBLimitOrderDetailViewController alloc]init];
    h.PositionModel=model;
    [self.navigationController pushViewController:h animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  [[ListAr objectAtIndex:section] objectForKey:@"titView"];
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
