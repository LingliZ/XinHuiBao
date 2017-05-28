//
//  XHBAccountDetailViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/24.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAccountDetailViewController.h"

@interface XHBAccountDetailViewController ()

@end

@implementation XHBAccountDetailViewController
{
    UIWebView*webView;
    NSURL*url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"账户介绍";
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    webView.delegate=self;
    if(![GXUserInfoTool isLogin])
    {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/account_intro/account_intro.html#1"]];
    }
    else
    {
        if([self.acconutLevel isEqualToString:@"迷你账户"])
        {
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/account_intro/account_intro.html#1"]];
        }
        if([self.acconutLevel isEqualToString:@"标准账户"])
        {
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/account_intro/account_intro.html#2"]];
        }
        if([self.acconutLevel isEqualToString:@"高端账户"])
        {
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.91pme.com/zhuanti/app/account_intro/account_intro.html#3"]];
        }
    }
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    GXLog(@"-----开始加载-------");
    [self.view showLoadingWithTitle:@"正在加载……"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    GXLog(@"-----加载完成-------");
    [self.view removeTipView];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    GXLog(@"-----加载失败-------");
    [self.view removeTipView];
    [self.view showFailWithTitle:@"加载失败，请稍后重试"];
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
