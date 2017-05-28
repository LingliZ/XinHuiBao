//
//  XHBAboutViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAboutViewController.h"
#import "XHBGovernmentWebViewController.h"
#import "XHBWelcomeViewController.h"
@interface XHBAboutViewController ()

@end

@implementation XHBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"关于";
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    self.img_logo.image=[UIImage imageNamed:about_headImage];
    self.label_name.text=about_name;
    self.label_version.text=about_version;
}
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //官网
        XHBGovernmentWebViewController*govVC=[[XHBGovernmentWebViewController alloc]init];
        [self.navigationController pushViewController:govVC animated:YES];
    }
    if(sender.tag==1)
    {
        //客服电话
        [UIButton callPhoneWithPhoneNum:XHBServicePhoneNum atView:self.view];
    }
    if(sender.tag==2)
    {
        //欢迎页
        XHBWelcomeViewController*welcomeVC=[[XHBWelcomeViewController alloc]init];
        welcomeVC.isFromAbout=YES;
        [self.navigationController pushViewController:welcomeVC animated:YES];
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
