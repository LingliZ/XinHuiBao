//
//  XHBHelpCenterDetailViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBHelpCenterDetailViewController.h"

@interface XHBHelpCenterDetailViewController ()

@end

@implementation XHBHelpCenterDetailViewController
{
    XHBHelpDetailModel*detailModel;
    UIWebView*webView_content;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self downloadData];
}
-(void)createUI
{
    self.title=self.model.title;
    webView_content=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    [self.view addSubview:webView_content];
}
-(void)downloadData
{
    [webView_content showLoadingWithTitle:@"正在加载……"];
    NSString*url=[NSString stringWithFormat:@"%@?id=%@",XHBUrl_ArticleDetail,self.model.id];
    [GXHttpTool POST:url parameters:nil success:^(id responseObject) {
        [webView_content removeTipView];
    
        if(responseObject)
        {
           detailModel=(XHBHelpDetailModel*) [XHBHelpDetailModel mj_objectWithKeyValues:responseObject];
            [self loadContent];
        }
    } failure:^(NSError *error) {
        [webView_content removeTipView];
        [webView_content showFailWithTitle:@"加载失败，请检查网络设置"];
        
    }];
}
-(void)loadContent
{
    NSString*htmlStr=[GXAdaptiveHeightTool htmlWithContent:detailModel.introtext title:@"" adddate:detailModel.created author:detailModel.author source:@""];
    [webView_content loadHTMLString:htmlStr baseURL:nil];
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
