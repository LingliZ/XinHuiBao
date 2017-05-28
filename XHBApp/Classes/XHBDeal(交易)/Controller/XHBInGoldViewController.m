//
//  XHBInGoldViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBInGoldViewController.h"
#import <WebKit/WebKit.h>

@interface XHBInGoldViewController ()<UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;

@end

@implementation XHBInGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=self.homeTit;
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    progressView.tintColor = GXGreen_priceBackgColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_homeUrl]];
    [wkWebView loadRequest:request];
    self.wkWebView = wkWebView;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - wkWebView代理


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
