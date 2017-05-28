//
//  GXFirstViewController.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXFirstViewController.h"
#import "UIParameter.h"
#import "GXCalendarBaseModel.h"
#import "GXCalendarBaseModelCell.h"
#import "GXCalendarEventModelCell.h"
#import "GXCalendarDataModelCell.h"
#import "GXAdaptiveHeightTool.h"

@interface GXFirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *saveDataArray;

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation GXFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.saveDataArray = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self noFinanceClendar];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GXCalendarDataModelCell" bundle:nil] forCellReuseIdentifier:@"GXCalendarDataModel"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GXCalendarEventModelCell" bundle:nil] forCellReuseIdentifier:@"GXCalendarEventModel"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
//无财经数据和事件提示
-(void)noFinanceClendar{
    UIImageView *noDataView = [[UIImageView alloc]initWithFrame:CGRectMake((GXScreenWidth - 80) / 2, 80, 80, 80)];
    noDataView.image = [UIImage imageNamed:@"nodata_events"];
    UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth - 200) / 2, noDataView.frame.size.height + noDataView.frame.origin.y + 30, 200, 30)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = @"今天无财经数据和事件";
    noDataLabel.textColor = UIColorFromRGB(0x9B9B9B);
    noDataLabel.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE17);
    [self.view addSubview:noDataView];
    [self.view addSubview:noDataLabel];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];

}
//更新数据
- (void)refreshData{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataFromServer)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataFromServer)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

}
- (void)refreshDataFromServer{
    [self loadFinanceCalendarDataFromServer:self.type];
}
//加载数据
- (void)loadFinanceCalendarDataFromServer:(NSInteger)type{
    //    #define GXUrl_finance @"/finance" //date时期格式yyyyMMdd
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(type!=0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*type ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *the_date_str = [date_formatter stringFromDate:theDate];

    NSDictionary *parameter = @{@"date":the_date_str};
    
    [GXHttpTool POSTCache:GXUrl_finance parameters:parameter success:^(id responseObject) {
        
//        NSMutableArray *mutableArray = responseObject[@"value"];
//        if (mutableArray.count == 0) {
//            //[self.view showFailWithTitle:@"没有找到相应的日历或事件"];
//            self.tableView.hidden = YES;
//        }
        
        [self removeAllObjectsFromArray];
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                GXCalendarBaseModel *baseModel = [GXCalendarBaseModel modelWithDictionary:valueDict];
                [self.saveDataArray addObject:baseModel];
            }
            
        }
        [self.tableView reloadData];
        //[self showEmptyMsg:nil dataSourceCount:self.saveDataArray.count customImage:@"nodata_events"];

        [self.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
//        [self showNetError];
        if(self.saveDataArray.count == 0){
//            [self showErrorNetMsg:nil Handler:^{
//                [self refreshData];
//            }];
        }
    }];

}
- (void)removeAllObjectsFromArray{
    [self.saveDataArray removeAllObjects];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64 - PageBtn) style:UITableViewStylePlain];
    }return _tableView;
}

#pragma mark ----- UITableViewDelegate -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}
//cell设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXCalendarBaseModelCell *cell = [GXCalendarBaseModelCell cellWithTableView:tableView Model:self.saveDataArray[indexPath.row] IndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     GXCalendarBaseModel *model = self.saveDataArray[indexPath.row];
    return model.cellHeight > HeightScale_IOS6(78) ? model.cellHeight : HeightScale_IOS6(78);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
