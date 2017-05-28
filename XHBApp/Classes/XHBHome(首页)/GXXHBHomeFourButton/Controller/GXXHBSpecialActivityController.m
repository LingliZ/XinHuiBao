//
//  GXXHBSpecialActivityController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBSpecialActivityController.h"
#import "GXXHBSpecialActivityCell.h"
#import "GXXHBHomeCycleModel.h"
#import "GXXHBGlobalDetailController.h"
@interface GXXHBSpecialActivityController ()
@property (nonatomic,strong)NSMutableArray *saveDataArray;


@end

@implementation GXXHBSpecialActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠活动";
    self.saveDataArray = [NSMutableArray new];
    
    [self loadDataFromServer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"GXXHBSpecialActivityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXXHBSpecialActivityCell"];
    
}
//加载列表
-(void)loadDataFromServer{
    [[AFHTTPSessionManager manager]POST:@"http://www.91pme.com/api/bannerlist/catid/89/limit/10" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"返回的数据是:%@",responseObject);
        [self removeCycleViewDataFromArray];
        [self parserCycleViewDataWithCycleView:responseObject];

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        
    }];

}
-(void)removeCycleViewDataFromArray{
    [self.saveDataArray removeAllObjects];
}
- (void)parserCycleViewDataWithCycleView:(NSMutableArray *)responseObject {
    for (NSDictionary *responseDict in responseObject) {
        GXXHBHomeCycleModel *cycleModel = [GXXHBHomeCycleModel new];
        [cycleModel setValuesForKeysWithDictionary:responseDict];
        [self.saveDataArray addObject:cycleModel];
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
    GXXHBSpecialActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXXHBSpecialActivityCell" forIndexPath:indexPath];
    GXXHBHomeCycleModel *model = self.saveDataArray[indexPath.row];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXXHBHomeCycleModel *model = self.saveDataArray[indexPath.row];
    GXXHBGlobalDetailController *globalVC = [[GXXHBGlobalDetailController alloc]init];
    globalVC.recieveUrl = model.clickurl;
    globalVC.title=model.name;
    [self.navigationController pushViewController:globalVC animated:YES];
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
