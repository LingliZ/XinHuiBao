//
//  GXXHBGlobalDetailController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/22.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBGlobalDetailController.h"
#import <WebKit/WebKit.h>
#import "UIBarButtonItem+item.h"
#import "XHBInGoldViewController.h"
#import "XHBLoginViewController.h"
#import "XHBRegisterViewController.h"
#import "XHBHelpCenterViewController.h"

@interface GXXHBGlobalDetailController ()<WKUIDelegate,WKNavigationDelegate>
{
    UIButton *backBtn;
}
//WKWebView
@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;


@end

@implementation GXXHBGlobalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *analystStr = [NSString stringWithFormat:@"http://www.91pme.com/zhuanti/live/analysts_info.html?rand=%ld#",random()];
    NSString *analystUlrStr = [analystStr stringByAppendingFormat:@"%ld",self.analystID];
    NSURL *ayalystUrl = [NSURL URLWithString:analystUlrStr];
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)];
    self.wkWebView.navigationDelegate = self;
    if (self.recieveUrl) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.recieveUrl]]];
    }else{
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:ayalystUrl]];
    }
    
    [self.view addSubview:self.wkWebView];
    
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    self.progressView.tintColor = GXGreen_priceBackgColor;
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(backBtn)
    {
        [backBtn removeFromSuperview];
        backBtn=nil;
    }
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 增加点击区域
    [backBtn setEnlargeEdgeWithTop:0 right:WidthScale_IOS6(90) bottom:0 left:0];
    backBtn.frame=CGRectMake(2, 0, NAVBAR_HEIGHT, NAVBAR_HEIGHT-1);
    
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar addSubview:backBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [backBtn removeFromSuperview];
    backBtn=nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

-(void)backBtnClick
{
    if([self.wkWebView canGoBack])
    {
        [self.wkWebView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"] ||
        [navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]
        )
    {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([navigationAction.request.URL.absoluteString containsString:@"xhb_openaccount://"])
    {
        if([GXUserInfoTool isLogin])
        {
            XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
            ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
            ingold.homeTit=@"入金";
            [self.navigationController pushViewController:ingold animated:YES];
            
        }else
        {
            XHBRegisterViewController*registerVC=[[XHBRegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }

        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if ([navigationAction.request.URL.absoluteString containsString:@"xhb_fundin://"])
    {
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
            return;
        }
        
        XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
        ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
        ingold.homeTit=@"入金";
        [self.navigationController pushViewController:ingold animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([navigationAction.request.URL.absoluteString containsString:@"xhb_openProblem://"])
    {
        XHBHelpCenterViewController*helpVC=[[XHBHelpCenterViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([navigationAction.request.URL.absoluteString containsString:@"xhb_onlineService://"])
    {
        //在线客服
        GXTabBarController*currentTab=(GXTabBarController*)self.navigationController.tabBarController;
        [currentTab.gxTabBar setSelectedIndex:3];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.wkWebView.estimatedProgress;
    }
    
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
        
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.loadCount --;
    NSLog(@"%@",error);
}


-(void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
