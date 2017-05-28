//
//  GXXHBAboutUsChildController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBAboutUsChildController.h"
#import <WebKit/WebKit.h>

@interface GXXHBAboutUsChildController ()<WKUIDelegate,WKNavigationDelegate>
//WKWebView
@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;


@end

@implementation GXXHBAboutUsChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 104)];
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?rand=%ld",self.type,random()]]]];
    [self.view addSubview:self.wkWebView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    // 进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    self.progressView.tintColor = GXGreen_priceBackgColor;
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"] ||
        [navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]
        ) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
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
