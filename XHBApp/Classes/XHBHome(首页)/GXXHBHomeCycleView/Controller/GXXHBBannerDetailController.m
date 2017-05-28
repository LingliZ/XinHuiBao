//
//  GXXHBBannerDetailController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBBannerDetailController.h"
#import <WebKit/WebKit.h>


@interface GXXHBBannerDetailController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
//WKWebView
@property (nonatomic,strong)WKWebView *cycleView;


@end

@implementation GXXHBBannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor cyanColor];
    self.cycleView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight )];
    self.cycleView.navigationDelegate = self;
    if (self.cycleDetailModel.clickurl) {
        [self.cycleView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.cycleDetailModel.clickurl]]];
    }else{
        
    }

    [self.view addSubview:self.cycleView];
//    NSLog(@"传过来的modle是:%@",self.cycleDetailModel.name);
//    NSLog(@"传过来的数组是:%@",self.cycleArray);
    // Do any additional setup after loading the view.
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
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
