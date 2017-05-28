//
//  GXXHBAboutUsBaseController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBAboutUsBaseController.h"
#import "UIParameter.h"
@interface GXXHBAboutUsBaseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *childBaseTableView;

@end

@implementation GXXHBAboutUsBaseController{
    NSString *indexTag;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ----- Public Method -----
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
    self.childBaseTableView.delegate = self;
    self.childBaseTableView.dataSource = self;
    [self.view addSubview:self.childBaseTableView];
    indexTag = yourTag;
}


#pragma mark ----- childBaseTableView -----
- (UITableView *)childBaseTableView{
    if (!_childBaseTableView) {
        _childBaseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT - 49) style:UITableViewStylePlain];
        self.childBaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }return _childBaseTableView;
}
#pragma mark ----- UITableViewDelegate -----
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isDebug) {
        NSLog(@"点击了控制器%@单元格的%li",indexTag,indexPath.row);
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
