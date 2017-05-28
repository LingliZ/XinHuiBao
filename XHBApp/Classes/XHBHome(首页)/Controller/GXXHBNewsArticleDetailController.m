//
//  GXXHBNewsArticleDetailController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/24.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBNewsArticleDetailController.h"
#import "GXArticleDetailModel.h"
#import "GXAdaptiveHeightTool.h"
#import <WebKit/WebKit.h>
@interface GXXHBNewsArticleDetailController ()<WKUIDelegate,WKNavigationDelegate>

//WKWebView
@property (nonatomic,strong)WKWebView *articleDetailView;

@property (nonatomic,strong)GXArticleDetailModel *model;

@end

@implementation GXXHBNewsArticleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章详情";
    self.articleDetailView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    self.articleDetailView.navigationDelegate = self;
    //[self.cycleView loadRequest:[NSURLRequest requestWithURL:ayalystUrl]];
    [self loadArticleDataFromServer];
    [self.view addSubview:self.articleDetailView];
    // Do any additional setup after loading the view.
}
-(void)loadArticleDataFromServer{
    //NSDictionary *idDict = @{@"id":self.recieveID};
    NSString *articleUrl = [NSString stringWithFormat:@"http://www.91pme.com/api/articledetail?id=%@",self.recieveID];
    
    [[AFHTTPSessionManager manager]POST:articleUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.model = [GXArticleDetailModel new];
        [self.model setValuesForKeysWithDictionary:responseObject];
        NSString *dateStr = [GXAdaptiveHeightTool getDateStyle:self.model.created];
        //NSLog(@"改之前:%@\n改之后:%@",model.created,dateStr);
        NSString *htmlStr = [GXAdaptiveHeightTool htmlWithContent:self.model.introtext title:self.model.title adddate:dateStr author:self.model.author source:self.model.xreference];
        
        //self.describtionStr = model.metadesc;
        //self.describtionStr = [NSString stringWithFormat:@"%@ %@",self.model.metadesc,self.shareDetailUrl];
        [self.articleDetailView loadHTMLString:htmlStr baseURL:nil];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
