//
//  GXGlobalArticleDetailController.m
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXGlobalArticleDetailController.h"
#import "GXArticleDetailModel.h"
#import "GXAdaptiveHeightTool.h"
//#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "GXActionSheetView.h"
//#import "GXPhotoBrowseController.h"
//#import "HWFullImgViewController.h"

@interface GXGlobalArticleDetailController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIView *bgView;
    UIImageView *imgView;
}

@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *describtionStr;
@property (nonatomic,strong)GXArticleDetailModel *model;

//分享跳转的链接
@property (nonatomic,strong)NSString *shareDetailUrl;
//分享的内容摘要加跳转链接

//保存图片的数组
@property (nonatomic,strong)NSMutableArray *mUrlArray;

@end

static CGRect oldframe;

@implementation GXGlobalArticleDetailController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文章详情";
    //跳转链接
    self.shareDetailUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.kindsOfIdentifier];
    self.detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
    self.detailWebView.delegate = self;
    self.detailWebView.backgroundColor = UIColorFromRGB(0xF8F8F8);
//    self.detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.detailWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.detailWebView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadArticleDetailDataFromServer];
  
    });
//    //分享按钮
//    UIImage *shareImage = [[UIImage imageNamed:@"share_pic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage: shareImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareItemAction:)];
//    self.navigationItem.rightBarButtonItem = shareItem;
    
}

//先请求网络数据然后webView加载html
- (void)loadArticleDetailDataFromServer{
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self.view showLoadingWithTitle:@"文章正在加载,请稍后"];
    }
    NSDictionary *idDict = @{@"id":self.kindsOfIdentifier};
    [GXHttpTool POSTCache:GXUrl_articleDetail parameters:idDict success:^(id responseObject) {
        [self.view removeTipView];
        if ([(NSNumber *)responseObject[@"success"] intValue] == 1) {
            NSDictionary *valueDict = responseObject[@"value"];
            self.model = [GXArticleDetailModel new];
            [self.model setValuesForKeysWithDictionary:valueDict];
            NSString *dateStr = [GXAdaptiveHeightTool getDateStyle:self.model.created];
            //NSLog(@"改之前:%@\n改之后:%@",model.created,dateStr);
            NSString *htmlStr = [GXAdaptiveHeightTool htmlWithContent:self.model.introtext title:self.model.title adddate:dateStr author:self.model.author source:self.model.xreference];
            
            self.titleStr = self.model.title;
            
            //self.describtionStr = model.metadesc;
            self.describtionStr = [NSString stringWithFormat:@"%@ %@",self.model.metadesc,self.shareDetailUrl];
            [self.detailWebView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        if (self.model == nil) {
//            [self showErrorNetMsg:nil Handler:^{
//            }];
            [self loadArticleDetailDataFromServer];

        }
    }];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.view.userInteractionEnabled = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
        // 无论是本地图片还是网络图片都有效果
//        NSString *js=@"var script = document.createElement('script');"
//        "script.type = 'text/javascript';"
//        "script.text = \"function ResizeImages() { "
//        "var myimg,oldwidth;"
//        "var maxwidth = %f;"
//        "for(i=0;i <document.images.length;i++){"
//        "myimg = document.images[i];"
//        "if(myimg.width > maxwidth){"
//        "oldwidth = myimg.width;"
//        "myimg.width = %f;"
//        "}"
//        "}"
//        "}\";"
//        "document.getElementsByTagName('head')[0].appendChild(script);";
//        js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width - 15];
//        [webView stringByEvaluatingJavaScriptFromString:js];
//        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //"myimg.height = myimg.height * (maxwidth / oldwidth);"
    //更改字体大小,背景颜色
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
    //    //字体颜色
    //    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'yellow'"];
    //    //页面背景色
    //    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#EDA80B'"];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //这里是js，主要目的实现对url的获取
    static  NSString * const js1GetImages =
    @"function getImagesArray(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:js1GetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImagesArray()"];
    self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.mUrlArray .count >= 2) {
        [self.mUrlArray  removeLastObject];
    }
    self.view.userInteractionEnabled = YES;
    //NSLog(@"获取到的图片数组是:%@",self.mUrlArray);

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        //NSLog(@"点击的image url------%@", imageUrl);
        /*
        GXPhotoBrowseController *photoBrowseVC = [[GXPhotoBrowseController alloc]init];
        photoBrowseVC.imgUrlArray = self.mUrlArray;
        photoBrowseVC.imgUrl = imageUrl;
        photoBrowseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:photoBrowseVC animated:YES completion:nil];
        */
        
        return NO;
        //[self showBigImage:imageUrl];//创建视图并显示图片
    }
    return YES;
}
//
//#pragma mark 显示大图片
//-(void)showBigImage:(NSString *)imageUrl{
//    //创建KeyWindow
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    //创建灰色透明背景，使其背后内容不可操作
//    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,GXScreenWidth, GXScreenHeight)];
//    [bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
//    //创建创建ScrollView
//    UIScrollView *scrollowView = [[UIScrollView alloc]initWithFrame:oldframe];
//    scrollowView.delegate = self;
//    
//    //创建显示图像视图
//    imgView = [[UIImageView alloc] init];
//    imgView.tag = 1;
//    imgView.userInteractionEnabled = YES;
//    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    UIImage *image = imgView.image;
//    oldframe=[imgView convertRect:imgView.bounds toView:window];
//    //设置UIScrollView的滚动范围和图片的真实尺寸一致
//    scrollowView.contentSize = image.size;
//    //设置最大伸缩比例
//    scrollowView.maximumZoomScale=2.0;
//    //设置最小伸缩比例
//    scrollowView.minimumZoomScale=0.5;
//    //添加视图
//    [scrollowView addSubview:imgView];
//    [bgView addSubview:scrollowView];
//    [window addSubview:bgView];
//    //添加点击消失手势
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
//    [bgView addGestureRecognizer: tap];
//    //添加捏合手势
//    [imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
//    //动画
//    [UIView animateWithDuration:0.3 animations:^{
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
//            
//            scrollowView.frame =CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//            imgView.frame=CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//        }else{
//            
//            scrollowView.frame =CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//            imgView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//        }
//        bgView.alpha=1;
//        [bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return imgView;
//}
//-(void)hideImage:(UITapGestureRecognizer*)tap{
//    
//    UIView *backgroundView = tap.view;
//    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame = oldframe;
//        backgroundView.alpha = 0;
//    } completion:^(BOOL finished) {
//        //[bgView removeFromSuperview];
//        bgView = nil;
//        [backgroundView removeFromSuperview];
//        [imageView removeFromSuperview];
//    }];
//}
//
//- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
//{
//    //缩放:设置缩放比例
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
//}

@end
