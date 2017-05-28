//
//  XHBOrderCloseViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBHistoryDetailViewController.h"
#import "XHBTradePositionModel.h"
#import "GXTabbar.h"

@interface XHBHistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *listmenu;
    UIView *ProductView;
    UIView *ContentView;
    UIView *ButtonView;
}
@end

@implementation XHBHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    self.title=@"交易详情";
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)];
    listmenu.delegate=self;
    listmenu.dataSource=self;
    listmenu.separatorStyle=UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=[UIColor clearColor];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    
    [self setProductView];
    [self setContentView];
    [self setButtonView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
   
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        return ProductView.frame.size.height;
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
        [cell.contentView addSubview:ProductView];
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
-(void)setProductView
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 39)];
    vv.backgroundColor=[UIColor clearColor];
    ProductView=vv;
    
    //标签1
    UILabel *lb_tag1=[[UILabel alloc]init];
    lb_tag1.font = GXFONT_PingFangSC_Regular(14);
    lb_tag1.textColor = [UIColor whiteColor];
    lb_tag1.textAlignment=NSTextAlignmentCenter;
    lb_tag1.layer.masksToBounds=YES;
    lb_tag1.layer.cornerRadius=2;
    [vv addSubview:lb_tag1];

    lb_tag1.text = [NSString stringWithFormat:@"%@",self.historyModel.historyList_tag];
    lb_tag1.backgroundColor=self.historyModel.historyList_tagBg;
    
    CGSize s=[lb_tag1.text boundingWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) FontSize:14];
    lb_tag1.frame=CGRectMake(15, 10, s.width+6, 19);
    
    lb_tag1.hidden=NO;
    if(self.historyModel.historyList_tag.length==0)
    {
        lb_tag1.hidden=YES;
    }
    
    //标签2
    UILabel *lb_tag2=[[UILabel alloc]init];
    lb_tag2.font = GXFONT_PingFangSC_Regular(14);
    lb_tag2.textColor = [UIColor whiteColor];
    lb_tag2.textAlignment=NSTextAlignmentCenter;
    lb_tag2.layer.masksToBounds=YES;
    lb_tag2.layer.cornerRadius=2;
    [vv addSubview:lb_tag2];
    lb_tag2.text = [NSString stringWithFormat:@"%@",self.historyModel.cmd_str];
    lb_tag2.backgroundColor=self.historyModel.cmd_BackgColor;
    
    s=[lb_tag2.text boundingWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) FontSize:14];
    
    lb_tag2.frame=CGRectMake(lb_tag1.frame.origin.x+lb_tag1.frame.size.width+6, 10, s.width+6, 19);
    if(self.historyModel.historyList_tag.length==0)
    {
        lb_tag2.frame=CGRectMake(15, 10, s.width+6, 19);
    }
    
    
    
    //名字
    UILabel *lb_name=[[UILabel alloc]init];
    lb_name.font = GXFONT_PingFangSC_Regular(16);
    lb_name.textColor = GXBlack_priceNameColor;
    [vv addSubview:lb_name];
    lb_name.text = [NSString stringWithFormat:@"%@",self.historyModel.hisName];
    [lb_name sizeToFit];
    lb_name.frame=CGRectMake(lb_tag2.frame.origin.x+lb_tag2.frame.size.width+10, 0, lb_name.frame.size.width, 39);
    
}

-(void)setContentView
{
    if(ContentView)
    {
        [ContentView removeFromSuperview];
        ContentView=nil;
    }
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 55*6)];
    vv.backgroundColor=[UIColor whiteColor];
    ContentView=vv;
    
   
    NSArray *valueAr=@[self.historyModel.openTime,self.historyModel.closeTime,self.historyModel.ticket,self.historyModel.openPrice,self.historyModel.closePrice,self.historyModel.volume,self.historyModel.swapsCommission_str,self.historyModel.sl_str,self.historyModel.tp_str,self.historyModel.commission,@"已撤单",@"--"];
    
    NSArray *ar=@[@"挂单时间",@"撤单时间",@"订单号",@"挂单价格",@"撤单价格",@"交易手数",@"交易金额",@"止损价格",@"止盈价格",@"手续费",@"挂单状态",@"实际盈亏"];
    if([self.historyModel.cmd integerValue]==0||[self.historyModel.cmd integerValue]==1)
    {
        ar=@[@"建仓时间",@"成交时间",@"订单号",@"建仓价格",@"平仓价格",@"交易手数",@"交易金额",@"止损价格",@"止盈价格",@"手续费",@"挂单状态",@"实际盈亏"];
        valueAr=@[self.historyModel.openTime,self.historyModel.closeTime,self.historyModel.ticket,self.historyModel.openPrice,self.historyModel.closePrice,self.historyModel.volume,self.historyModel.swapsCommission_str,self.historyModel.sl_str,self.historyModel.tp_str,self.historyModel.commission,@"--",self.historyModel.OrderProfit_noCommission_att];
    }
    
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
        lb2.textAlignment=NSTextAlignmentCenter;
        lb2.font=GXFONT_PingFangSC_Regular(14);
        lb2.textColor=GXColor(51, 51, 51, 1);
        [childV addSubview:lb2];
        
        if([valueAr[i] isKindOfClass:[NSMutableAttributedString class]])
        {
            lb2.attributedText=valueAr[i];
        }else
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
    [btn1 setTitle:@"继续交易" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(jixu) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:btn1];
    
}

-(void)jixu
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIWindow *www=[UIApplication sharedApplication].keyWindow;
//        
//        GXTabBarController *tabbarc=(GXTabBarController *)www.rootViewController;
//        
//        GXTabbar *tabbar= tabbarc.gxTabBar;
//        
//        [tabbar setSelectedIndex:1];
//        [tabbarc setSelectedIndex:1];
//    });
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
   
    NSMutableArray *vcAr=[[NSMutableArray alloc]init];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if(![vc isKindOfClass: NSClassFromString(@"XHBHistoryOrderViewController")])
        {
            [vcAr addObject:vc];
        }
    }
    self.navigationController.viewControllers=vcAr;
    [self.navigationController popViewControllerAnimated:YES];
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
