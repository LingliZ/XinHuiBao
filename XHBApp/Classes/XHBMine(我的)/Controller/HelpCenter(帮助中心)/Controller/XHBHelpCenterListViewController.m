//
//  XHBHelpCenterListViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBHelpCenterListViewController.h"

@interface XHBHelpCenterListViewController ()

@end

@implementation XHBHelpCenterListViewController
{
    UITableView*_tableView;
    NSMutableArray*arr_dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self downloadData];
}
-(void)createUI
{
    arr_dataSource=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
#pragma mark--   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*cellName=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    XHBHelpListModel*model=arr_dataSource[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
   // cell.textLabel.text=[NSString stringWithFormat:@"你好----%ld",indexPath.row];
    cell.textLabel.text=model.title;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WidthScale_IOS6(52);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBHelpListModel*model=arr_dataSource[indexPath.row];
    GXLog(@"------->id为：%@",model.id);
    XHBHelpCenterDetailViewController*detailVC=[[XHBHelpCenterDetailViewController alloc]init];
    detailVC.model=model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)downloadData
{
    [_tableView showLoadingWithTitle:@"正在加载……"];
    NSString*url=[NSString stringWithFormat:@"%@?catid=%@",XHBUrl_ArticleList,self.catid];
    [GXHttpTool POST:url parameters:nil success:^(id responseObject) {
        [_tableView removeTipView];
        if([(NSArray*)responseObject count])
        {
            NSDictionary*dic=responseObject[0];
            NSString*title=dic[@"title"];
            GXLog(@"-----请求成功");
            arr_dataSource=[[NSMutableArray alloc]init];
           arr_dataSource= [XHBHelpListModel mj_objectArrayWithKeyValuesArray:responseObject];
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [_tableView removeTipView];
        [_tableView showFailWithTitle:@"加载失败，请检查网络状况"];
        
    }];
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
