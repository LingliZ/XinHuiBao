//
//  LaunchAdvertisementView.m
//  XHBApp
//
//  Created by WangLinfang on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "LaunchAdvertisementView.h"


#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width

@implementation LaunchAdvertisementView
{
    NSTimer*countDownTimer;
}
-(instancetype)initWithWindow:(UIWindow *)window adType:(AdType)adType
{
    self=[super init];
    if(self)
    {
        _adTime=6;
        self.webView_adContent.delegate=self;
        countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [window makeKeyAndVisible];
        [window addSubview:self];
        [self loadDataForAdContent];
    }
    return self;
}
-(void)loadDataForAdContent
{
    [GXHttpTool POST:@"http://www.91pme.com/api/bannerlist/catid/112/limit/5" parameters:nil success:^(id responseObject) {
        NSArray*resultArr=(NSArray*)responseObject;
        if(resultArr.count)
        {
            NSDictionary*resulDic=resultArr[0];
            NSURL*url=[NSURL URLWithString:resulDic[@"clickurl"]];
            NSURLRequest*request=[NSURLRequest requestWithURL:url];
            [self.webView_adContent loadRequest:request];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)onTimer
{
    if(self.adTime==0)
    {
        [countDownTimer invalidate];
        countDownTimer=nil;
        [self startcloseAnimation];
    }
    else
    {
        [self.btn_close setTitle:[NSString stringWithFormat:@"%@|跳过",@(self.adTime--)] forState:UIControlStateNormal];
    }
}

#pragma mark - 开启关闭动画
-(void)startcloseAnimation
{
    
}



@end
