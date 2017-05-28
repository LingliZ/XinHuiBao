//
//  XHBGovernmentWebViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBGovernmentWebViewController.h"
#import <WebKit/WebKit.h>
@interface XHBGovernmentWebViewController ()<WKNavigationDelegate>

@end

@implementation XHBGovernmentWebViewController
{
    WKWebView*webView;
    NSURL*url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  createUI];
}
-(void)createUI
{
    self.title=@"官网";
    webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    webView.navigationDelegate=self;
    url=[NSURL URLWithString:@"http://www.91pme.com"];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
#pragma mark--WKWebViewNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    GXLog(@"-----开始加载-------");
    [self.view showLoadingWithTitle:@"正在加载……"];
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    GXLog(@"-----加载完成-------");
    [self.view removeTipView];

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    GXLog(@"-----加载失败-------");
    [self.view removeTipView];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if([navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]||[navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"])
    {
        [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
