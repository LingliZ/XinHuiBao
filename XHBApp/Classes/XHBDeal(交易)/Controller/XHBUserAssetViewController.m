//
//  XHBUserAssetViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBUserAssetViewController.h"
#import "AssetEquityView.h"
#import "AssetTableViewCell.h"
#import "XHBInOrOutGoldViewController.h"
#import "XHBInGoldViewController.h"

@interface XHBUserAssetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSURLSessionDataTask *dataTask_UserMargin;
    BOOL isCancel;
    AssetEquityView *equityV;
    UITableView *listmenu;
}
@end

#define height_inGoldBtn 47

@implementation XHBUserAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"资产详情";

    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-height_inGoldBtn) style:UITableViewStylePlain];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];

    
    equityV=[[AssetEquityView alloc]init];
 
    
    UIButton *btnInGold=[[UIButton alloc]initWithFrame:CGRectMake(0, listmenu.frame.size.height, GXScreenWidth, height_inGoldBtn)];
    btnInGold.backgroundColor=GXMainColor;
    [btnInGold setTitle:@"入金/出金" forState:UIControlStateNormal];
    [btnInGold setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnInGold.titleLabel.font=GXFONT_PingFangSC_Regular(18);
    [btnInGold addTarget:self action:@selector(inGoldBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInGold];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view showLoadingWithTitle:@"正在刷新"];
    
    isCancel=NO;
    
    [self headerRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self taskCancel];
    
    [equityV cancelTimer];
}

-(void)inGoldBtn
{
    XHBInOrOutGoldViewController *inoutgold=[[XHBInOrOutGoldViewController alloc]init];
    [self.navigationController pushViewController:inoutgold animated:YES];
}

-(void)taskCancel
{
    isCancel=YES;
    
    [dataTask_UserMargin cancel];
}

-(void)headerRefreshing
{
    //如果请求任务存在，就等待直到超时
    if(dataTask_UserMargin)
    {
        return;
    }
    
    dataTask_UserMargin=[GXHttpTool Get:GXUrl_appqtaccount parameters:@{@"AppSessionId":[GXUserInfoTool getAppSessionId]} success:^(id responseObject){
        
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            GXLog(@"%@",[responseObject mj_JSONString]);
            
            //更新资金模型
            XHBTraderUserMaginModel *model=[XHBTraderUserMaginModel mj_objectWithKeyValues:[responseObject[GXValue] firstObject]];
            [equityV setUserMargin:model];
            
            [self.view removeTipView];
            
            [listmenu reloadData];
            
        }else
        {
            [self.view removeTipView];
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        dataTask_UserMargin=nil;
        
    } failure:^(NSError *error) {
        
        dataTask_UserMargin=nil;
        
        [self.view removeTipView];
        
        if(!isCancel)
        {
            [self.view showFailWithTitle:@"加载失败"];
        }
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        return equityV.frame.size.height;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
        return 1;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        static NSString *Identifier = @"assetEquityV";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        
        [cell addSubview:equityV];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        if(indexPath.row==0 || indexPath.row==1 || indexPath.row==2)
        {
            static NSString *CellIdentifier = @"assetCell1";
            AssetTableViewCell *cell = (AssetTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AssetTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.delegate=(id)self;
            }
            
            cell.btn_question.tag=indexPath.row;
            
            if(indexPath.row==0)
            {
                cell.lb_Tit1.text=@"浮动盈亏";
                
                cell.view_right2_lb.text=equityV.usrModel.FL;
                if([equityV.usrModel.FL floatValue]>0)
                {
                    cell.view_right2_lb.textColor=GXRed_priceBackgColor;
                }else if ([equityV.usrModel.FL floatValue]<0)
                {
                    cell.view_right2_lb.textColor=GXGreen_priceBackgColor;
                }else
                {
                    cell.view_right2_lb.textColor=GXBlack_priceNameColor;
                }
            }else if (indexPath.row==1)
            {
                cell.lb_Tit1.text=@"余额";
                
                cell.view_right2_lb.text=equityV.usrModel.balance;
                cell.view_right2_lb.textColor=GXBlack_priceNameColor;
            }else if (indexPath.row==2)
            {
                cell.lb_Tit1.text=@"信用额";
            
                cell.view_right2_lb.text=equityV.usrModel.credit;
                cell.view_right2_lb.textColor=GXBlack_priceNameColor;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }else
        {
            static NSString *CellIdentifier = @"assetCell2";
            AssetTableViewCell *cell = (AssetTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AssetTableViewCell" owner:self options:nil] objectAtIndex:1];
                cell.delegate=(id)self;
            }
            
            cell.btn_question.tag=indexPath.row;
            
            cell.lb_Tit1.text=@"风险率";
            cell.lb_Tit2.text=equityV.usrModel.marginLevel_str;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==3)
    {
        XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
        ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
        ingold.homeTit=@"入金";
        [self.navigationController pushViewController:ingold animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section==0)
    {
        return 10;
    }
    return 0;
}

-(void)assetCellDelegateBtnClick:(UIButton *)sender
{
    UIButton *btn=sender;
    GXLog(@"%ld",btn.tag);
    
    if(btn.tag==0)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"浮动盈亏" message:@"交易品种行情变动造成的当前持仓的盈亏情况" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [al show];
    }
    else if (btn.tag==1)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"余额" message:@"账户总额(不包括当前持仓商品订单盈亏)" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [al show];
    }else if (btn.tag==2)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"信用额" message:@"客户参与活动或者得到奖励赠金的总和" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [al show];
    }else if (btn.tag==3)
    {
        GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"风险率" message:@"净值/占用预付款*100%\n当风险率低于50%,我们会通过邮件和短信方式提醒客户在交易时段期间内，账户净值小于等于已用预付款的20%，会对持仓商品进行强制平仓" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [al show];
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
