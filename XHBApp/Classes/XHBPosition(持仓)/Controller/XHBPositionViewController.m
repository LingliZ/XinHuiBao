//
//  XHBPositionViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBPositionViewController.h"
#import "XHBLiveCastViewController.h"
#import <WebKit/WebKit.h>
#import "UIBarButtonItem+item.h"

@interface XHBPositionViewController ()<WKNavigationDelegate>
{
    WKWebView *wkw;
    UIProgressView *progressView;
    UIView *rootview;
}
@end

@implementation XHBPositionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets=NO;
    rootview=[[UIView alloc]init];
    rootview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:rootview];
    
    wkw = [[WKWebView alloc] init];
    [rootview addSubview:wkw];
    wkw.navigationDelegate = self;
    
    
    // 进度条
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    progressView.tintColor = GXGreen_priceBackgColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self leftButtonClick];
    
    [wkw addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [wkw removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)leftButtonClick
{
    [progressView setProgress:0 animated:NO];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.91pme.com/zhuanti/live/live_index.html"]];
    [wkw loadRequest:request];
    
}

#pragma mark - WKNavigationDelegate

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == wkw && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (newprogress == 1) {
            progressView.hidden = YES;
            [progressView setProgress:0 animated:NO];
        }else {
            progressView.hidden = NO;
            [progressView setProgress:newprogress animated:YES];
        }
    }
}

//在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler{

    [self setCloseNavBtn];
    
    NSString *nameStr = [[webView.URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    if (![nameStr containsString:@"liveCast"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        
        if([nameStr containsString:@"analysts_info"])
        {
            [self setNavBtn];
        }
        
    }else{
        decisionHandler(WKNavigationResponsePolicyCancel);
    
        XHBLiveCastViewController *liveVC = [[XHBLiveCastViewController alloc] init];
        [self.navigationController pushViewController:liveVC animated:true];
    }
}

-(void)setNavBtn
{
    UIBarButtonItem *leftButton = [UIBarButtonItem MyBarButtonItem:[UIImage imageNamed:@"navigationbar_back"] helited:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(leftButtonClick) forcontroEvent:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    self.tabBarController.tabBar.hidden=YES;
    
    rootview.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT);
    wkw.frame=CGRectMake(0, 0, rootview.frame.size.width, rootview.frame.size.height);
}
-(void)setCloseNavBtn
{
    self.navigationItem.leftBarButtonItem=nil;
    
    self.tabBarController.tabBar.hidden=NO;
    
    rootview.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT);
    wkw.frame=CGRectMake(0, 0, rootview.frame.size.width, rootview.frame.size.height);
}

@end
