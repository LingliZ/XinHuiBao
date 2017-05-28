//
//  FCChildBaseViewController.m
//  GXApp
//
//  Created by GXJF on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "FCChildBaseViewController.h"
#import "UIParameter.h"
#import "GXCalendarBaseModel.h"
#import "GXCalendarBaseModelCell.h"
#import "GXCalendarDataModelCell.h"
#import "GXCalendarEventModelCell.h"


@interface FCChildBaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *fcBaseTableView;

@end

@implementation FCChildBaseViewController
{
    NSString *indexTag;
}
-(void)createLabel:(NSString *)yourTitleStr{
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH / 2 - 80, FUll_VIEW_HEIGHT / 2 - 40 - 64 - PageBtn, 160, 80)];
    if (!isDebug) {
        NSLog(@"加载了控制器%@",yourTitleStr);
    }
    middleLabel.text = [NSString stringWithFormat:@"第%@个视图控制器",yourTitleStr];
    middleLabel.textColor =[UIColor blackColor];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:middleLabel];
}
-(void)createTableViewFromVC:(NSString *)yourTag{
    self.fcBaseTableView.delegate = self;
    self.fcBaseTableView.dataSource = self;
    [self.view addSubview:self.fcBaseTableView];
    indexTag = yourTag;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UITableView *)fcBaseTableView{
    if (!_fcBaseTableView) {
        _fcBaseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64 - PageBtn) style:UITableViewStylePlain];
    }return _fcBaseTableView;
}

#pragma mark ----- UITableViewDelegate -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"基类测试文字";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
