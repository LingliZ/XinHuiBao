//
//  GXXHBNoticeListController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/24.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBNoticeListController.h"
#import "GXHomeTableViewCell.h"
#import "GXCommentModel.h"
#import "GXXHBNewsArticleDetailController.h"
@interface GXXHBNoticeListController ()
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,assign)NSInteger page;

@end

@implementation GXXHBNoticeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告列表";
    self.saveDataArray = [NSMutableArray new];
    
    [self refreshData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //注册cell
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"GXHomeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeTableViewCell"];
}
- (void)refreshData{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];

    MJRefreshGifHeader *header =[XHBMJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
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
    NSString *strUrl = [NSString stringWithFormat:@"http://www.91pme.com/api/articlelist?catid=%d",2];
    
    [[AFHTTPSessionManager manager]POST:strUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeAllObjectsFromArray];
        [self parserDataWithNews:responseObject];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.saveDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.saveDataArray[indexPath.row];
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXXHBNewsArticleDetailController *detailVC = [[GXXHBNewsArticleDetailController alloc]init];
    GXCommentModel *model = self.saveDataArray[indexPath.row];
    detailVC.recieveID = model.ID;
    //detailVC.shareImgUrl = model.imgurl;
    [self.navigationController pushViewController:detailVC animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
