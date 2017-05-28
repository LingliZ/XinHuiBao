//
//  XHBPositionMoreViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBPositionMoreViewController.h"
#import "PositionHeadeView.h"
#import "XHBDealConst.h"
#import "XHBTraderUserMaginModel.h"
#import "PositionListTableViewCell.h"
#import "noDataShowView.h"
#import "XHBOrderCloseViewController.h"
#import "XHBHistoryOrderViewController.h"
#import "XHBInGoldViewController.h"
#import "XHBUserAssetViewController.h"
#import "XHBTradePositionModel.h"
#import "XHBLimitOrderViewController.h"


#define IntervalRefesh 2

@interface XHBPositionMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask_PositionList;
    NSURLSessionDataTask *dataTask_PriceList;//请求任务
    
    noDataShowView *noDataView;
    UITableView *listmenu;
    NSMutableArray *positionListArray;
    NSTimer *timer;
    PositionHeadeView *posiHeadView;
    
    UIButton *boomBarButton1;
    UIButton *boomBarButton2;
}
@end

@implementation XHBPositionMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-50-40)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
   
    
    [self setBoomBarView];
    
    posiHeadView = [[PositionHeadeView alloc] initWithFrame:CGRectZero];
    posiHeadView.delegate=(id)self;
    //初始化model
    XHBTraderUserMaginModel *model=[[XHBTraderUserMaginModel alloc]init];
    model.marginFree=@"0.00";
    model.equity=@"0.00";
    model.FL=@"0.00";
    model.marginLevel=@"0.00";
    [posiHeadView setUserTradeDetailModel:model];
    
    
    
    noDataView=[[noDataShowView alloc]initWithFrame:CGRectMake(0, posiHeadView.frame.size.height, GXScreenWidth, listmenu.frame.size.height-posiHeadView.frame.size.height)];
    [noDataView setTextTip:@"您暂无商品持仓!"];
    noDataView.hidden=YES;
    [listmenu addSubview:noDataView];
    
}

-(void)setBoomBarView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, listmenu.frame.origin.y+listmenu.frame.size.height, GXScreenWidth, 50)];
    view.backgroundColor=GXColor(242, 243, 243, 0.96);
    [self.view addSubview:view];
    
    boomBarButton1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth/2.0, 50)];
    boomBarButton1.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [boomBarButton1 addTarget:self action:@selector(boomBarButton1) forControlEvents:UIControlEventTouchUpInside];
    [boomBarButton1 setTitle:@"当前挂单" forState:UIControlStateNormal];
    [boomBarButton1 setTitleColor:GXRGBColor(90, 90, 90) forState:UIControlStateNormal];
    [view addSubview:boomBarButton1];
    
    boomBarButton2=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 0, GXScreenWidth/2.0, 50)];
    boomBarButton2.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [boomBarButton2 addTarget:self action:@selector(boomBarButton2) forControlEvents:UIControlEventTouchUpInside];
    [boomBarButton2 setTitle:@"交易历史" forState:UIControlStateNormal];
    [boomBarButton2 setTitleColor:GXRGBColor(90, 90, 90) forState:UIControlStateNormal];
    [view addSubview:boomBarButton2];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 14, 0.5, 22)];
    line.backgroundColor=GXColor(219, 219, 219, 1);
    [view addSubview:line];
    
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 0.5)];
    line2.backgroundColor=GXColor(232, 232, 232, 1);
    [view addSubview:line2];
}

-(void)boomBarButton1
{
    XHBLimitOrderViewController *l=[[XHBLimitOrderViewController alloc]init];
    [self.navigationController pushViewController:l animated:YES];
}

-(void)boomBarButton2
{
    XHBHistoryOrderViewController *h=[[XHBHistoryOrderViewController alloc]init];
    [self.navigationController pushViewController:h animated:YES];
}

-(void)historyPosition
{
    XHBHistoryOrderViewController *his=[[XHBHistoryOrderViewController alloc]init];
    [self.navigationController pushViewController:his animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMarginReresh" object:nil userInfo:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self timerInvalidate];
    [self taskCancel];
}

-(void)timerInvalidate
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)taskCancel
{
    
    [dataTask_PositionList cancel];
    
    [dataTask_PriceList cancel];
}

-(void)updateUserMagin
{
    //更新资金模型
    [posiHeadView setUserTradeDetailModel:GXInstance.trade_userMarginModel];
    
    //加载持仓数据
    [self positionListRereshing];
    
    
    XHBTraderUserMaginModel *model=posiHeadView.marginModel;
    [boomBarButton1 setTitle:[NSString stringWithFormat:@"当前挂单(%ld)",[model.limitOrderCount integerValue]] forState:UIControlStateNormal];
}

//请求持仓
-(void)positionListRereshing
{
    dataTask_PositionList= [GXHttpTool Get:GXUrl_appqueryopenorder parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId],@"offset":@"0",@"len":@"100"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            if(positionListArray)
            {
                [positionListArray removeAllObjects];
                positionListArray=nil;
            }
            
            posiHeadView.lb_titTableview.text=@"    当前持仓(0)";

            
            if(!responseObject[@"value"])
            {
                noDataView.hidden=NO;
                [self.view removeTipView];
            }
            else if([responseObject[@"value"] count]==0)
            {
                noDataView.hidden=NO;
                [self.view removeTipView];
            }
            else
            {
                positionListArray=[XHBTradePositionModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
                [listmenu reloadData];
                
                
                posiHeadView.lb_titTableview.text=[NSString stringWithFormat:@"    当前持仓(%d)",(int)[positionListArray count]];
                
                
                noDataView.hidden=YES;
                
                //更新头
                [self updateHeaderInfo];
               
                //加载行情数据
                [self priceListRereshing];
                
                //刷行情
                [self timerInvalidate];
                timer = [NSTimer scheduledTimerWithTimeInterval:IntervalRefesh target:self selector:@selector(priceListRereshing) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
        }
        
        
        dataTask_PositionList=nil;
        
    } failure:^(NSError *error) {
        
        
        dataTask_PositionList=nil;
        
        [self.view removeTipView];
        
    
    }];
}

//请求行情
-(void)priceListRereshing
{
    if(dataTask_PriceList)
    {
        return;
    }
    
    NSString *codeStr=@"";
    
    for (int i=0; i<[positionListArray count]; i++) {
        XHBTradePositionModel *model=positionListArray[i];
        codeStr=[codeStr stringByAppendingString:model.symbolCode];
        if(i<[positionListArray count]-1)
        {
            codeStr=[codeStr stringByAppendingString:@","];
        }
    }
    
    dataTask_PriceList =[GXHttpTool POST:GXUrl_quotation parameters:@{@"code":codeStr} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            NSArray *ar=responseObject[@"value"];
            
            //因为是根据持仓列表里所以的code请求的，所以要判断返回的数量和请求的数量是否相等
            if([ar count]==[positionListArray count])
            {
                //更新buy 和 sell，在执行reload 就会计算每一行的浮动盈亏
                for (int i=0; i<[positionListArray count]; i++) {
                    XHBTradePositionModel *model=positionListArray[i];
                    
                    if([model.cmd integerValue]==0)
                    {
                        model.closePrice=ar[i][@"buy"];
                    }else
                    {
                        model.closePrice=ar[i][@"sell"];
                    }
                }

                [self updateHeaderInfo];
                
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

-(void)updateHeaderInfo
{
    //计算总浮动盈亏、净值、可用预付款、预付款比率
    //净值=结余+浮动盈亏 + 信用额
    //可用预付款=净值-预付款
    //预付款比率=净值/预付款
    
    CGFloat Totle_profit=0;
    for (int i=0; i<[positionListArray count]; i++) {
        XHBTradePositionModel *model=positionListArray[i];
        Totle_profit+=[model.FL floatValue] ;
    }
    //查资金模型
    XHBTraderUserMaginModel *model=posiHeadView.marginModel;
    
    CGFloat Equity=[model.balance floatValue] +Totle_profit + [model.credit floatValue] ;
    
    CGFloat freeMargin=Equity-[model.margin floatValue];
    
    CGFloat Risk=Equity*100.0/[model.margin floatValue];
    
    //更新model
    model.FL=[NSString stringWithFormat:@"%.2f",Totle_profit];
    model.equity=[NSString stringWithFormat:@"%.2f",Equity];
    model.marginFree=[NSString stringWithFormat:@"%.2f",freeMargin];
    model.marginLevel=[NSString stringWithFormat:@"%.2f",Risk];
    [posiHeadView setUserTradeDetailModel:model];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return positionList_tableView_cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return positionListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PositionListTableViewCell *cell = [PositionListTableViewCell cellWithTableView:tableView];
    cell.pModel = positionListArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    XHBOrderCloseViewController *close=[[XHBOrderCloseViewController alloc]init];
    close.PositionModel=positionListArray[indexPath.row];
    [self.navigationController pushViewController:close animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  posiHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return posiHeadView.frame.size.height;
}

#pragma mark - positionHeadViewDelegate
-(void)positionHeaViewClick
{
    XHBUserAssetViewController *ass=[[XHBUserAssetViewController alloc]init];
    [self.navigationController pushViewController:ass animated:YES];
}

-(void)positionHeaViewInGold
{
    XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
    ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
    ingold.homeTit=@"入金";
    [self.navigationController pushViewController:ingold animated:YES];
}

-(void)positionHeaViewQuestion
{
    GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"预付款比例" message:@"净值/占用预付款*100%\n当预付款比例低于50%,我们会通过邮件和短信方式提醒客户在交易时段期间内，账户净值小于等于已用预付款的20%，会对持仓商品进行强制平仓" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [al show];
    
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
