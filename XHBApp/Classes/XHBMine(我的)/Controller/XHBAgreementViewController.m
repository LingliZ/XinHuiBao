//
//  XHBAgreementViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/30.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAgreementViewController.h"

@interface XHBAgreementViewController ()

@end

@implementation XHBAgreementViewController
{
    UIWebView*_webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    NSURL*url=[NSURL URLWithString:self.urlStr];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
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
