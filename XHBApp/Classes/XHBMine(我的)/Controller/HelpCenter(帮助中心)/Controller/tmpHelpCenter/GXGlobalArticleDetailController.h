//
//  GXGlobalArticleDetailController.h
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface GXGlobalArticleDetailController : UIViewController
//文章ID
@property (nonatomic,strong)NSString *kindsOfIdentifier;
//分享图片url
@property (nonatomic,strong)NSString *shareImgUrl;

@property (nonatomic,strong)UIWebView *detailWebView;



@end
