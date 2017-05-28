//
//  LaunchAdvertisementView.h
//  XHBApp
//
//  Created by WangLinfang on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    LogoAdType=0,//带logo的广告
    FullScreenAdtype=1,//全屏的广告
}AdType;
@interface LaunchAdvertisementView : UIView<UIWebViewDelegate>
@property(nonatomic,assign)NSInteger adTime;//广告时长
@property (weak, nonatomic) IBOutlet UIWebView *webView_adContent;
@property (weak, nonatomic) IBOutlet UIButton *btn_close;
-(instancetype)initWithWindow:(UIWindow*)window adType:(AdType)adType;
@end
