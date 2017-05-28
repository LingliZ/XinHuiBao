//
//  GXCommentsViewController.m
//  GXApp
//
//  Created by GXJF on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCommentsViewController.h"
#import "UIParameter.h"
#import "GXHomeTableViewCell.h"
#import "GXCommentModel.h"
#import "GXXHBNewsArticleDetailController.h"
@interface GXCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *GXCommentTableView;
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,assign)NSInteger page;
@end

@implementation GXCommentsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.saveDataArray = [NSMutableArray new];
    self.GXCommentTableView.delegate = self;
    self.GXCommentTableView.dataSource = self;
    self.GXCommentTableView.showsVerticalScrollIndicator = NO;
    self.GXCommentTableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.view addSubview:self.GXCommentTableView];
    [self refreshData];
    [self.GXCommentTableView reloadData];
    [self.GXCommentTableView registerNib:[UINib nibWithNibName:@"GXHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"GXHomeTableViewCell"];
}
- (void)refreshData{
//    self.GXCommentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
//    self.GXCommentTableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.GXCommentTableView.mj_header beginRefreshing];
   
    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    self.GXCommentTableView.mj_header = header;
    [self.GXCommentTableView.mj_header beginRefreshing];

    
    
    self.GXCommentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}

- (void)refreshFirstData{
    self.page = 1;
    [self loadMoreDataFromServer:self.page];
}
- (void)refreshMoreData{
    self.page++;
    [self loadMoreDataFromServer:self.page];
}

- (void)loadMoreDataFromServer:(NSInteger)page{
//        NSDictionary *parmarter = @{@"catid"=self.type};
    NSString *strUrl = [NSString stringWithFormat:@"http://www.91pme.com/api/articlelist?catid=%@",self.type];
    
    [[AFHTTPSessionManager manager]POST:strUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeAllObjectsFromArray];
        [self parserDataWithNews:responseObject];
        
        [self.GXCommentTableView.mj_header endRefreshing];
        [self.GXCommentTableView.mj_footer endRefreshing];
        [self.GXCommentTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.GXCommentTableView.mj_header endRefreshing];
        [self.GXCommentTableView.mj_footer endRefreshing];
    }];
//    [GXHttpTool POSTCache:strUrl parameters:nil success:^(id responseObject) {
//        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
//            // NSLog(@"返回的数据是:%@",responseObject);
//            for (NSDictionary *valueDict in responseObject[@"value"]) {
//                GXCommentModel *model = [GXCommentModel new];
//                [model setValuesForKeysWithDictionary:valueDict];
//                [self.saveDataArray addObject:model];
//            }
//        }
//        [self.GXCommentTableView.mj_header endRefreshing];
//        [self.GXCommentTableView.mj_footer endRefreshing];
//        [self.GXCommentTableView reloadData];
//        
//    } failure:^(NSError *error) {
//        [self.GXCommentTableView.mj_header endRefreshing];
//        [self.GXCommentTableView.mj_footer endRefreshing];
//        if (self.saveDataArray.count == 0) {
//            self.GXCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            [self.GXCommentTableView reloadData];
////            [self showErrorNetMsg:nil Handler:^{
////                [self refreshData];
////            }];
//        }
//        
//    }];

}
- (void)removeAllObjectsFromArray{
    [self.saveDataArray removeAllObjects];
}
- (void)parserDataWithNews:(NSMutableArray *)responseObject {
    for (NSDictionary *valueDict in responseObject) {
        GXCommentModel *model = [GXCommentModel new];
        [model setValuesForKeysWithDictionary:valueDict];
        [self.saveDataArray addObject:model];
    }
}
#pragma mark ----- GXCommentTableView -----
-(UITableView *)GXCommentTableView{
    if (!_GXCommentTableView) {
        _GXCommentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT - PageBtn - 64) style:UITableViewStylePlain];
        //self.GXCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(self.isTmp)
        {
            _GXCommentTableView.frame=CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT  - 64);
        }
    }return _GXCommentTableView;
}
#pragma mark ----- UITableViewDelegate -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeTableViewCell" forIndexPath:indexPath];
    [self.GXCommentTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.GXCommentTableView setSeparatorColor:UIColorFromRGB(0xEEEEEE)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.saveDataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isDebug) {
        //NSLog(@"点击了国鑫评论控制器单元格%ld",indexPath.row);
    }
    [GXUserdefult setObject:self.type forKey:@"savePage"];
    [GXUserdefult synchronize];
    GXXHBNewsArticleDetailController *detailVC = [[GXXHBNewsArticleDetailController alloc]init];
    GXCommentModel *model = self.saveDataArray[indexPath.row];
    detailVC.recieveID = model.ID;
    //detailVC.shareImgUrl = model.imgurl;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
