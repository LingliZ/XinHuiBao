//
//  XHBSettingViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBSettingViewController.h"
#import "XHBAccountSecuriySetViewController.h"
#import "XHBFeedBackViewController.h"
#import "XHBAboutViewController.h"
#import "XHBLoginViewController.h"
@interface XHBSettingViewController ()

@end

@implementation XHBSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    SDImageCache*tmpSD=[SDImageCache sharedImageCache];
    NSInteger cacheSize=[tmpSD getSize];
    self.label_cache.text=@"0M";
    if(cacheSize>0)
    {
        self.label_cache.text=[NSString stringWithFormat:@"%.2fM",cacheSize/1024.0/1024.0];
    }
    [self isLogin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [GXUserInfoTool loginOut];
    [self createUI];
}
-(void)createUI
{
    self.title=@"系统设置";
    [UIView setBorForView:self.btn_logout withWidth:0 andColor:nil andCorner:5];
    [self.btn_logout setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    [self.view_accountSecuritySet mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@(WidthScale_IOS6(52)));
    }];
}

#pragma mark--判断是否登录
-(void)isLogin
{
    if([GXUserInfoTool isLogin])
    {
        self.btn_logout.hidden=NO;
    }
    else
    {
        self.btn_logout.hidden=YES;
    }

}
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //账户安全设置
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*loginVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        XHBAccountSecuriySetViewController*accountSetVC=[[XHBAccountSecuriySetViewController alloc]init];
        [self.navigationController pushViewController:accountSetVC animated:YES];
    }
    if(sender.tag==1)
    {
        //清理缓存
        [self clearCache];
    }
    if(sender.tag==2)
    {
        //给我评分
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/xin-hui-bao-gui-jin-shu/id1181736840?l=zh&ls=1&mt=8"]];
    }
    if(sender.tag==3)
    {
        //意见反馈
        XHBFeedBackViewController*feedBackVC=[[XHBFeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
    if(sender.tag==4)
    {
        //关于
        XHBAboutViewController *aboutVC=[[XHBAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    if(sender.tag==5)
    {
        //版本更新
    }
}
-(void)clearCache
{
    SDImageCache*sd=[SDImageCache sharedImageCache];
    NSInteger num=[sd getDiskCount];
    NSInteger size=[sd getSize];
    if(size ==0)
    {
        [self.view showFailWithTitle:@"已是最佳状态，无需清理"];
    }
    else
    {
        [self.view showLoadingWithTitle:@"正在清理缓存"];
        [sd cleanDiskWithCompletionBlock:^{
            [self.view removeTipView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view showSuccessWithTitle:@"清理完毕"];
                [sd clearDisk];
                NSInteger sizeTmp=[sd getSize];
                self.label_cache.text=[NSString stringWithFormat:@"%ldM",sizeTmp/1024/1024];
            });
        }];
    }
}

#pragma mark--退出登录
- (IBAction)btnClick_logout:(UIButton *)sender {
    __weak XHBSettingViewController*weakSelf=self;
    UIActionSheet*actSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出登录", nil];
    actSheet.tag=100;
    [actSheet showInView:self.view];
}
#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==100)
    {
        //退出登录
        if(buttonIndex==0)
        {
            [GXUserInfoTool loginOut];
            [GXPushTool RegisterEaseMob];//注册环信账号
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if(buttonIndex==1)
        {
            
        }
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
