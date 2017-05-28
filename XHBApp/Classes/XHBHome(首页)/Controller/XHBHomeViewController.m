//
//  XHBHomeViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//
#import "XHBHomeViewController.h"
#import "GXXHBHomePriceCell.h"
#import "GXXHBHomeFourBtnCell.h"
#import "GXXHBHomeAnalystCell.h"
#import "GXXHBHomeNewsCell.h"
#import "SDCycleScrollView.h"
#import "GXXHBHomeCycleModel.h"
#import "GXXHBBannerDetailController.h"
#import "ReusableHeaderView.h"
#import "GXXHBGlobalDetailController.h"
#import "FinanceClendarController.h"
#import "GXXHBHomeNewsModel.h"
#import "InformationController.h"
#import "GXXHBNewsArticleDetailController.h"
#import "FinanceEventsCell.h"
#import "GXFinanceDataModel.h"
#import "GXXHBNoticeListController.h"
#import "GXXHBSpecialActivityController.h"
#import "GXXHBHomeAboutUsController.h"
#import "PriceMarketModel.h"
#import "XHBPriceDetailViewController.h"
#import "GXCommentModel.h"
#import "XHB_Home_AlertToRegister.h"
#import "XHBRegisterViewController.h"
#import "XHB_Home_AlertToRegister.h"
#import "XHBRegisterViewController.h"
#import "GXXHBHomeCycleModel.h"

#define GXPersonSelectArrayNotificationName @"GXPersonSelectArrayNotificationName" // 行情自选通知名称


@interface XHBHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ReusableHeaderViewDelegate>
{
    GXXHBHomePriceCell *timerPriceCell;
}
//头部轮播
@property (nonatomic,strong)SDCycleScrollView *cycleView;
//存储轮播模型数组
@property (nonatomic,strong)NSMutableArray *cycleArray;
//保存图片数组
@property (nonatomic,strong)NSMutableArray *cycleImgArray;
//区头名字数组
@property (nonatomic,strong)NSMutableArray *headerTitles;
//2区区脚名字
@property (nonatomic,strong)NSArray *footerTitles;
//财经新闻数组
@property (nonatomic,strong)NSMutableArray *homeNewsArray;
@property (nonatomic,strong)NSMutableArray *homeTwoNewsArr;
//财经日历数组
@property (nonatomic,strong)NSMutableArray *calendarDataArray;//财经事件数组
//区脚label1
@property (nonatomic,strong)UILabel *footerLabel1;
@property (nonatomic,strong)NSMutableArray *NoticeDataArray;
//@property(nonatomic,copy)XHB_Home_AlertToRegister*view_alertToRegister;
@end

@implementation XHBHomeViewController
{
    XHB_Home_AlertToRegister*_view_alertToRegister;
}
-(void)viewWillAppear:(BOOL)animated
{
    if(timerPriceCell)
    {
        [timerPriceCell initData];
    }
    if([GXUserInfoTool isLogin])
    {
        _view_alertToRegister.hidden=YES;
        self.XHBTableView.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 55);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(timerPriceCell)
    {
        [timerPriceCell timerInv];
    }
}
-(void)isLogin
{
    if([GXUserInfoTool isLogin])
    {
        self.XHBTableView.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 55);
        self.view_alertToRegister.hidden=YES;
    }
    else
    {
        self.XHBTableView.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 55-52+9);
        self.view_alertToRegister.hidden=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Home_title;
//    [self.view insertSubview:self.view_alertAdvertisement atIndex:self.view.subviews.count];
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.XHBTableView.backgroundView.backgroundColor = UIColorFromRGB(0xF8F8F8);
//    self.view.backgroundColor = [UIColor redColor];
    self.XHBTableView.delegate =self;
    self.XHBTableView.dataSource = self;
    [self.view addSubview:self.XHBTableView];
//数组初始化
    self.cycleArray = [NSMutableArray new];
    self.cycleImgArray = [NSMutableArray new];
    self.homeNewsArray = [NSMutableArray new];
    self.calendarDataArray = [NSMutableArray new];
    self.NoticeDataArray = [NSMutableArray new];
//区头数组
    self.headerTitles = [NSMutableArray arrayWithObjects:@"",@"",@"金牌分析师",@"财经新闻",@"财经日历", nil ];
//区脚数组
    self.footerTitles = @[@"",@"",@"公告",@"",@""];
    [self XhbCycleView];
    [self refreshCycleViewData];
    //[self.XHBTableView registerClass:[GXXHBHomePriceCell class] forCellReuseIdentifier:@"GXXHBHomePriceCell"];
    [self.XHBTableView registerClass:[GXXHBHomeFourBtnCell class] forCellReuseIdentifier:@"GXXHBHomeFourBtnCell"];
    [self.XHBTableView registerClass:[GXXHBHomeAnalystCell class] forCellReuseIdentifier:@"GXXHBHomeAnalystCell"];
    [self.XHBTableView registerNib:[UINib nibWithNibName:@"GXXHBHomeNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXXHBHomeNewsCell"];
//    [self.XHBTableView registerClass:[GXXHBHomeNewsCell class] forCellReuseIdentifier:@"GXXHBHomeNewsCell"];
    [self.XHBTableView registerNib:[UINib nibWithNibName:@"FinanceEventsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FinanceEventsCell"];
    //[self.XHBTableView registerClass:[GXXHBHomeCalendarCell class] forCellReuseIdentifier:@"GXXHBHomeCalendarCell"];
    //[self.view addSubview:self.view_alertToRegister];
    
    [self.view addSubview:self.view_alertAdvertisement];
    
    _view_alertToRegister =[[[NSBundle mainBundle]loadNibNamed:@"XHB_Home_AlertToRegister" owner:self options:nil]lastObject];
    _view_alertToRegister.frame=CGRectMake(0, GXScreenHeight - 55-52-64+5, GXScreenWidth, 52);
    _view_alertToRegister.delegate=(id)self;
    [self.view addSubview:_view_alertToRegister];
    [self isLogin];

}
#pragma mark--XHB_Home_AlertToRegistDelegate
-(void)goToRegist
{
    XHBRegisterViewController*registerVC=[[XHBRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)closeView_AlertToRegister
{
    self.XHBTableView.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 55);
}
//懒加载
#pragma mark--底部tableView
-(UITableView *)XHBTableView{
    if (!_XHBTableView) {
        _XHBTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 55) style:UITableViewStyleGrouped];
        _XHBTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _XHBTableView.sectionFooterHeight = 0.1;
        _XHBTableView.sectionHeaderHeight = 0.1;
    }
    return _XHBTableView;
}
#pragma mark--弹屏广告
-(XHBAlertAdvertisementView*)view_alertAdvertisement
{
    if(_view_alertAdvertisement==nil)
    {
        _view_alertAdvertisement=[[[NSBundle mainBundle]loadNibNamed:@"XHBAlertAdvertisementView" owner:self options:nil]lastObject];
        _view_alertAdvertisement.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64-60);
        __weak typeof (self)weakSelf=self;
        _view_alertAdvertisement.turn=^(NSString*urlString,NSString*name){
            
            GXXHBGlobalDetailController *safeVC = [[GXXHBGlobalDetailController alloc]init];
            safeVC.recieveUrl = urlString;
            safeVC.title = name;
            [weakSelf.navigationController pushViewController:safeVC animated:YES];
        };
    }
    return _view_alertAdvertisement;
}
#pragma mark--头部轮播图
- (void)XhbCycleView{
    
    self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, GXScreenWidth, ( GXScreenWidth * 0.3333)) delegate:self placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    //self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //self.cycleView.titlesGroup = self.cycleNameArray;
    self.cycleView.currentPageDotImage = [UIImage imageNamed:@"cycle_now"];
    self.cycleView.pageDotImage = [UIImage imageNamed:@"cycle_other"];
    self.cycleView.delegate = self;
    self.cycleView.autoScrollTimeInterval = 4.0;
    
    self.XHBTableView.tableHeaderView = self.cycleView;
    [self.XHBTableView addSubview:self.cycleView];
    
    __weak typeof(self) weakSelf = self;
    self.cycleView.clickItemOperationBlock = ^(NSInteger index) {
//        GXXHBBannerDetailController *bannerDetailVC = [[GXXHBBannerDetailController alloc]init];
//        bannerDetailVC.cycleDetailModel = weakSelf.cycleArray[index];
//        bannerDetailVC.cycleArray = weakSelf.cycleArray;
//        [weakSelf.navigationController pushViewController:bannerDetailVC animated:YES];

        GXXHBHomeCycleModel *model=weakSelf.cycleArray[index];
        
        GXXHBGlobalDetailController *safeVC = [[GXXHBGlobalDetailController alloc]init];
        safeVC.recieveUrl = [NSString stringWithFormat:@"%@?rand=%ld",model.clickurl,random()];
        safeVC.title = model.name;
        [weakSelf.navigationController pushViewController:safeVC animated:YES];
        
        NSLog(@"已点击轮播图第%ld",index);
    };
}
#pragma mark--下拉刷新
- (void)refreshCycleViewData {
//    self.XHBTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCycleViewDataFromServer)];
//    self.XHBTableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.XHBTableView.mj_header beginRefreshing];
    
    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(loadCycleViewDataFromServer)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    self.XHBTableView.mj_header = header;
    [self.XHBTableView.mj_header beginRefreshing];
}
#pragma mark--请求轮播数组
-(void)loadCycleViewDataFromServer{
    //请求轮播数据
    //NSDictionary *parameDict = @{@"catid":@"89",@"limit":@"5"};
    [[AFHTTPSessionManager manager]POST:@"http://www.91pme.com/api/bannerlist/catid/89/limit/5" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"返回的数据是:%@",responseObject);
        [self removeCycleViewDataFromArray];
        [self parserCycleViewDataWithCycleView:responseObject];
        self.cycleView.imageURLStringsGroup = self.cycleImgArray.mutableCopy;
        [self.XHBTableView reloadData];
        [self.XHBTableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.XHBTableView.mj_header endRefreshing];

    }];
    
#pragma mark--请求首页财经新闻数据
    //NSDictionary *newsDict = @{@"catid":@"10"};
    [[AFHTTPSessionManager manager]POST:@"http://www.91pme.com/api/articlelist?catid=10" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeNewsDataFromArray];
        [self parserNewsDataWithCycleView:responseObject];
        
        self.homeTwoNewsArr = [self.homeNewsArray subarrayWithRange:NSMakeRange(0, 2)].mutableCopy;
        
        [self.XHBTableView reloadData];
        [self.XHBTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.XHBTableView.mj_header endRefreshing];
        
    }];
    //
#pragma mark--请求财经日历数据
    [GXHttpTool POSTCache:GXUrl_index parameters:nil success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            [self removeCalendarDataFromArray];
            [self parmarterCalendarDataWith:responseObject];
            [self.XHBTableView reloadData];
            [self.XHBTableView.mj_header endRefreshing];
        }else{
            //[self showComomError:responseObject];
            [self.XHBTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        //[self showNetError];
        [self.XHBTableView.mj_header endRefreshing];
    }];
    
#pragma mark--请求区脚label数据
    NSString *strUrl = [NSString stringWithFormat:@"http://www.91pme.com/api/articlelist?catid=%d",2];
    
    [[AFHTTPSessionManager manager]POST:strUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeNoticeDataFromArray];
        //[self parserNoticeDataWithNews:responseObject];
//        self.footerLabel1.text = responseObject[0][@"title"];
//        self.NoticeDataArray = responseObject;
        for (NSDictionary *resDict in responseObject) {
            GXCommentModel *model = [GXCommentModel new];
            [model setValuesForKeysWithDictionary:resDict];
            [self.NoticeDataArray addObject:model];
        }
        [self.XHBTableView.mj_header endRefreshing];
        [self.XHBTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.XHBTableView.mj_header endRefreshing];
    }];

}
-(XHB_Home_AlertToRegister*)view_alertToRegister
{
    if(_view_alertToRegister==nil)
    {
        _view_alertToRegister=[[[NSBundle mainBundle]loadNibNamed:@"XHB_Home_AlertToRegister" owner:self options:nil]lastObject];
        _view_alertToRegister.frame=CGRectMake(0, GXScreenHeight - 55-52, GXScreenWidth, 52);
       // _view_alertToRegister.delegate=self;
    }
    return _view_alertToRegister;
}

#pragma mark--移除轮播数组数据
-(void)removeCycleViewDataFromArray{
    [self.cycleImgArray removeAllObjects];
    [self.cycleArray removeAllObjects];
}

#pragma mark--移除财经新闻数组数据
-(void)removeNewsDataFromArray{
    [self.homeNewsArray removeAllObjects];
    [self.homeTwoNewsArr removeAllObjects];
}

#pragma mark--移除财经日历数据
-(void)removeCalendarDataFromArray{
    [self.calendarDataArray removeAllObjects];
}

#pragma mark--移除区脚标题
-(void)removeNoticeDataFromArray{
    [self.NoticeDataArray removeAllObjects];
}

#pragma mark--解析轮播数据
- (void)parserCycleViewDataWithCycleView:(NSMutableArray *)responseObject {
    for (NSDictionary *responseDict in responseObject) {
        GXXHBHomeCycleModel *cycleModel = [GXXHBHomeCycleModel new];
        [cycleModel setValuesForKeysWithDictionary:responseDict];
        [self.cycleImgArray addObject:responseDict[@"imgurl"]];
        [self.cycleArray addObject:cycleModel];
    }
}

#pragma mark--解析财经新闻数据
- (void)parserNewsDataWithCycleView:(NSMutableArray *)responseObject{
    for (NSDictionary *resDict in responseObject) {
        GXXHBHomeNewsModel *newsModel = [GXXHBHomeNewsModel new];
        [newsModel setValuesForKeysWithDictionary:resDict];
        [self.homeNewsArray addObject:newsModel];
    }
    
}

#pragma mark--解析财经日历数据
- (void)parmarterCalendarDataWith:(NSDictionary *)responseObject{
    NSDictionary *valueDict = responseObject[@"value"];
    for (NSDictionary *financeDict in valueDict[@"financeDatas"]) {
        GXFinanceDataModel *model = [GXFinanceDataModel new];
        [model setValuesForKeysWithDictionary:financeDict];
        [self.calendarDataArray addObject:model];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
#pragma mark--分析师
            return 0;
            break;
        case 3:
            return self.homeTwoNewsArr.count;
            break;
        case 4:
            return self.calendarDataArray.count;
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        static NSString *cellName = @"cell";
        GXXHBHomePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
//        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GXPersonSelectArrayNotificationName object:nil] subscribeNext:^(id x) {
//            [cell userCustomCellReloadData];
//        }];
        
        if (cell == nil) {
            cell = [[GXXHBHomePriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            tableView.separatorStyle = UITableViewCellSelectionStyleNone;
            [cell initData];
            
            timerPriceCell=cell;
            //self.userPriceListArray = cell.priceListArray;
            
            @weakify(self);
            
            [cell.SignalCellClick subscribeNext:^(PriceMarketModel *model) {
                @strongify(self);
                XHBPriceDetailViewController *priceVC = [[XHBPriceDetailViewController alloc]init];
                priceVC.marketModel = model;

                [self.navigationController pushViewController:priceVC animated:YES];
                
                
            }];
        }
        //_cell=cell;
        return cell;

    }else if (indexPath.section == 1){
#pragma mark--关于我们、安全保障、优惠活动、交易规则
        GXXHBHomeFourBtnCell *fourBtnCell = [tableView dequeueReusableCellWithIdentifier:@"GXXHBHomeFourBtnCell"];
        fourBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [fourBtnCell setBtnClick:^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    GXXHBHomeAboutUsController *aboutUsVC = [[GXXHBHomeAboutUsController alloc]init];
                    [self.navigationController pushViewController:aboutUsVC animated:YES];
                    
                }
                    break;
                case 1:
                {
                    GXXHBGlobalDetailController *safeVC = [[GXXHBGlobalDetailController alloc]init];
                    safeVC.recieveUrl = [NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/deal/fin_security.html?rand=%ld",random()];
                    safeVC.title = @"安全保障";
                    [self.navigationController pushViewController:safeVC animated:YES];
                }
                    break;
                case 2:
                {
                    GXXHBSpecialActivityController *specialVC = [[GXXHBSpecialActivityController alloc]init];
                    
                    [self.navigationController pushViewController:specialVC animated:YES];
                }
                    break;
                case 3:
                {
                    GXXHBGlobalDetailController *safeVC = [[GXXHBGlobalDetailController alloc]init];
                    safeVC.recieveUrl = [NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/deal/trade_index.html?rand=%ld",random()];
                    safeVC.title = @"交易规则";
                    [self.navigationController pushViewController:safeVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
        
        return fourBtnCell;
    }else if (indexPath.section == 2){
#pragma mark--分析师
        GXXHBHomeAnalystCell *analystCell = [tableView dequeueReusableCellWithIdentifier:@"GXXHBHomeAnalystCell"];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [analystCell.contentView addSubview:lineView];
        analystCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [analystCell setAnalystBtnBlock:^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    /*
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 2;
                    analystVC.title = @"沈志宏";
                    [self.navigationController pushViewController:analystVC animated:YES];
                    */
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 5;
                    analystVC.title = @"张建彬";
                    [self.navigationController pushViewController:analystVC animated:YES];
                }
                    break;
                case 1:
                {
                    /*
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 5;
                    analystVC.title = @"张建彬";
                    [self.navigationController pushViewController:analystVC animated:YES];
                     */
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 7;
                    analystVC.title = @"刘猛";
                    [self.navigationController pushViewController:analystVC animated:YES];
                }break;
                case 2:
                {
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 7;
                    analystVC.title = @"刘猛";
                    [self.navigationController pushViewController:analystVC animated:YES];
                }break;
                case 3:
                {
                    GXXHBGlobalDetailController *analystVC = [[GXXHBGlobalDetailController alloc]init];
                    analystVC.analystID = 4;
                    analystVC.title = @"朱炜";
                    [self.navigationController pushViewController:analystVC animated:YES];
                }break;
                default:
                    break;
            }
        }];
        return analystCell;
    }else if (indexPath.section == 3){
#pragma mark--财经新闻
        GXXHBHomeNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"GXXHBHomeNewsCell" forIndexPath:indexPath];
        newsCell.model = self.homeTwoNewsArr[indexPath.row];
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return newsCell;
    }else{
#pragma mark--财经日历
        FinanceEventsCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:@"FinanceEventsCell"];

        if (indexPath.row == 0) {
            //分割线
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(61, calendarCell.contentView.frame.size.height - 0.5, calendarCell.contentView.frame.size.width - 55, 0.5)];
            lineView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
            //[calendarCell.contentView addSubview:lineView2];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(WidthScale_IOS6(37), calendarCell.contentView.frame.size.height - 18, 0.5, 18)];
            lineView.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [calendarCell.contentView addSubview:lineView];
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, calendarCell.contentView.frame.size.width, 0.5)];
            lineView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [calendarCell.contentView addSubview:lineView1];
        }
        if (indexPath.row == 1) {
            //分割线
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(61, calendarCell.contentView.frame.size.height - 0.5, calendarCell.contentView.frame.size.width - 55, 0.5)];
            lineView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
            //[calendarCell.contentView addSubview:lineView2];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(WidthScale_IOS6(37), calendarCell.contentView.frame.size.height - 18, 0.5, 18)];
            lineView.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [calendarCell.contentView addSubview:lineView];
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(WidthScale_IOS6(37), 0, 0.5, 15)];
            lineView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [calendarCell.contentView addSubview:lineView1];
            
        }
        if (indexPath.row == 2) {
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(WidthScale_IOS6(37), 0, 0.5, 15)];
            lineView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [calendarCell.contentView addSubview:lineView1];
            calendarCell.view_Line.hidden=YES;
        }
        calendarCell.model = self.calendarDataArray[indexPath.row];
        self.XHBTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        calendarCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return calendarCell;
    }
}


#pragma mark--行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HeightScale_IOS6(100);
    }else if (indexPath.section == 1){
        return HeightScale_IOS6(90);
    }else if (indexPath.section == 2){
//        return HeightScale_IOS6(220);
        return HeightScale_IOS6(120);
    }else if (indexPath.section == 3){
       // return HeightScale_IOS6(100);
        return GXScreenWidth>375?HeightScale_IOS6(100):100;
    }else{
        //return HeightScale_IOS6(70);
        return  GXScreenWidth>375?HeightScale_IOS6(70):70;
    }
}

#pragma mark--区头名字
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==1)
    {
        UIView*seperatView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 8)];
        seperatView .backgroundColor=UIColorFromRGB(0xF8F8F8);
        return seperatView;
    }
    if (section == 2) {
#pragma mark--分析师
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        UIView*seperatView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 8)];
        seperatView .backgroundColor=UIColorFromRGB(0xF8F8F8);
        [headView addSubview:seperatView];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 100, 40)];
        titleLabel.text = @"金牌分析师";
        titleLabel.textColor = [UIColor getColor:@"333333"];
        titleLabel.font = GXFONT_PingFangSC_Regular(16);
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth / 2, 8, GXScreenWidth / 2 - 15, 40)];
        detailLabel.text = @"最强战队带您做单";
        detailLabel.textColor = [UIColor getColor:@"A5A5A5"];
        detailLabel.font = GXFONT_PingFangSC_Regular(14);
        detailLabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:detailLabel];
        [headView addSubview:titleLabel];
        return headView;
    }else if(section > 1){
        ReusableHeaderView *headerView = [ReusableHeaderView headerViewWihtTableView:tableView];
        headerView.title = self.headerTitles[section];
        headerView.moreBtn.tag = section;
        headerView.delegate = self;
        if(section==3)
        {
            UIView *lineViewFroSection3=[[UIView alloc]initWithFrame:CGRectMake(0, 49, GXScreenWidth, 1)];
            lineViewFroSection3.backgroundColor=UIColorFromRGB(0xEEEEEE);
            [headerView addSubview:lineViewFroSection3];
        }
        return headerView;

    }else{
        return nil;
    }
}

#pragma  mark--区头代理
-(void)headerViewDidClickMoreBtn:(NSInteger)tag{
    if (tag ==3) {
        [GXUserdefult removeObjectForKey:@"savePage"];
        [GXUserdefult synchronize];
        InformationController *informationVC = [[InformationController alloc]init];
        
        [self.navigationController pushViewController:informationVC animated:YES];

    }else if (tag ==4){
        FinanceClendarController *financeClendarVC = [[FinanceClendarController alloc]init];
        
        [self.navigationController pushViewController:financeClendarVC animated:YES];
    }
}

#pragma mark--区脚名字
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
#pragma mark--公告
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 50)];
        footerView.backgroundColor = [UIColor whiteColor];
        UIView *sepraterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 8)];
        sepraterView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        UILabel *footerLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, HeightScale_IOS6(40))];
        
        footerLable.text = @"公告";
        footerLable.textAlignment = NSTextAlignmentLeft;
        footerLable.font = GXFONT_PingFangSC_Regular(16);
        footerLable.textColor = [UIColor getColor:@"333333"];
        self.footerLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth / 2, 10,  GXScreenWidth / 2 - 30, HeightScale_IOS6(40))];
        //self.footerLabel1.text = @"第一天开始,特朗普的候选资格等等";
        GXCommentModel *model = self.NoticeDataArray.firstObject;
        self.footerLabel1.text = model.title;
        self.footerLabel1.textColor = [UIColor getColor:@"A5A5A5"];
        self.footerLabel1.font = GXFONT_PingFangSC_Regular(14);
        UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        footerBtn.frame = CGRectMake(65, 10, GXScreenWidth - 80, HeightScale_IOS6(40));

        [footerBtn setImage:[UIImage imageNamed:@"homepage_arrowhead_right"] forState:UIControlStateNormal];
        footerBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE12);
        footerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [footerBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.footerLabel1];
        [footerView addSubview:sepraterView];
        [footerView addSubview:footerLable];
        [footerView addSubview:footerBtn];
        return footerView;
    }else{
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 0)];
        return footerView;
    }
}

#pragma mark--区脚点击事件
-(void)footerBtnClick:(UIButton *)button{
    GXXHBNoticeListController *noticeVC = [[GXXHBNoticeListController alloc]init];
    
    [self.navigationController pushViewController:noticeVC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        GXXHBHomeNewsModel *model = self.homeTwoNewsArr[indexPath.row];
        GXXHBNewsArticleDetailController *articleVC = [[GXXHBNewsArticleDetailController alloc]init];
        articleVC.recieveID = model.ID;
        [self.navigationController pushViewController:articleVC animated:YES];
    }
    if (indexPath.section == 4) {
        FinanceClendarController *financeClendarVC = [[FinanceClendarController alloc]init];
        
        [self.navigationController pushViewController:financeClendarVC animated:YES];
    }
}

#pragma mark--区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
#pragma mark--分析师
        return 0;
    }
    if (section > 1) {
        //return HeightScale_IOS6(50);
        return 50;
    }else if(section == 1){
        return 8;
    }else{
        return 0;
    }
}

#pragma mark--区脚高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 50;
    }else{
        return 0;
    }
}




@end
