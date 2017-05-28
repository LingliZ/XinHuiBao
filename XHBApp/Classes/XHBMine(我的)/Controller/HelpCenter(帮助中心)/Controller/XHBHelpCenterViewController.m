//
//  XHBHelpCenterViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/16.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBHelpCenterViewController.h"
#import "XHBHelpCenterListViewController.h"

@interface XHBHelpCenterViewController ()

@end

@implementation XHBHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"帮助中心";
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    [self.view_commonQuestion mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(WidthScale_IOS6(52)));
        
    }];
}

- (IBAction)btnClick:(UIButton *)sender {
    XHBHelpCenterListViewController*listVC=[[XHBHelpCenterListViewController alloc]init];
    if(sender.tag==33)
    {
        //常见问题
        listVC.title=@"常见问题";
    }
    if(sender.tag==65)
    {
        //交易问题
        listVC.title=@"交易问题";
    }
    if(sender.tag==66)
    {
        //账户问题
        listVC.title=@"账户问题";
    }
    if(sender.tag==67)
    {
        //软件问题
        listVC.title=@"软件问题";
    }
    if(sender.tag==68)
    {
        //其他问题
        listVC.title=@"其他问题";
    }
    listVC.catid=[NSString stringWithFormat:@"%ld",sender.tag];
    [self.navigationController pushViewController:listVC animated:YES];

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
