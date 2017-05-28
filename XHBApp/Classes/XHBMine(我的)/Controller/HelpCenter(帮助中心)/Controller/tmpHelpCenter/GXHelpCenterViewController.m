//
//  GXHelpCenterViewController.m
//  GXApp
//
//  Created by WangLinfang on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXHelpCenterViewController.h"
#import "GXArticleTypeListModel.h"
#import "GXHelperCatalogModel.h"
#import "GXMechanismPointModel.h"
#import "GXHelpCenterCatalogView.h"
#import "GXGlobalArticleDetailController.h"
@interface GXHelpCenterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *listTableView;// 帮助中心一级列表
@property (nonatomic, strong) NSMutableArray *helpTypeArray;// 行情一级数据

@end

@implementation GXHelpCenterViewController


- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.sectionFooterHeight = 10.0;
    }
    return _listTableView;
}



-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.translucent=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self loadData];
    //[MobClick event:@"help_center"];
    
    
}
-(void)createUI
{
    self.navigationItem.title=@"帮助中心";
    [self.view addSubview:[self listTableView]];
    self.view.backgroundColor=GXRGBColor(245, 246, 244);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.helpTypeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return HeightScale_IOS6(57);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [((GXHelperCatalogModel*)[self.helpTypeArray objectAtIndex:section]).helpList count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

  GXHelpCenterCatalogView *view = [[GXHelpCenterCatalogView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.bounds.size.width, HeightScale_IOS6(53))];
  [view setModel:((GXHelperCatalogModel*)[self.helpTypeArray objectAtIndex:section])];
    if(section==0)
    {
        view.imageView.image=[UIImage imageNamed:@"mine_open_an_account"];
        //view.imageView.frame=CGRectMake(10, 10, 20, 20);
    }
    if(section==1)
    {
        view.imageView.image=[UIImage imageNamed:@"mine_back_contract"];
        //view.imageView.frame=CGRectMake(10, 10, 32, 20);
    }
    if(section==2)
    {
        view.imageView.image=[UIImage imageNamed:@"mine_transaction"];
        //view.imageView.frame=CGRectMake(10, 10, 22, 20);
    }
    //view.title.frame=CGRectMake(CGRectGetMaxX(view.imageView.frame)+10, 0, GXScreenWidth-60, 40);
  return view;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray* helpList=((GXHelperCatalogModel*)[self.helpTypeArray objectAtIndex:indexPath.section]).helpList;
                       
    NSDictionary* helpDic=[helpList objectAtIndex:indexPath.row];
    
    GXMechanismPointModel* help= [GXMechanismPointModel mj_objectWithKeyValues:helpDic];
  
    cell.textLabel.text=help.title;
    cell.textLabel.font=[UIFont systemFontOfSize:WidthScale_IOS6(14)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSArray* helpList=((GXHelperCatalogModel*)[self.helpTypeArray objectAtIndex:indexPath.section]).helpList;
    
    NSDictionary* helpDic=[helpList objectAtIndex:indexPath.row];
    
    GXMechanismPointModel* help= [GXMechanismPointModel mj_objectWithKeyValues:helpDic];
    help.ID=[helpDic objectForKey:@"id"];
    GXGlobalArticleDetailController *detailVC = [[GXGlobalArticleDetailController alloc]init];
    detailVC.kindsOfIdentifier = help.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((GXHelperCatalogModel*)[self.helpTypeArray objectAtIndex:section]).title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    return HeightScale_IOS6(53);
}


-(void) loadData{

    [self.listTableView showLoadingWithTitle:@"文章正在加载,请稍等"];
    [GXHttpTool POSTCache:GXUrl_helpList parameters:nil  success:^(id responseObject) {
        [self.listTableView removeTipView];
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            self.helpTypeArray = [GXHelperCatalogModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            [self.listTableView reloadData];
        }else{
           // [self showComomError:responseObject];
        
        }
        
        
    } failure:^(NSError *error) {
        [self.listTableView removeTipView];
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
