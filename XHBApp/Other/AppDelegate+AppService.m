//
//  AppDelegate+AppService.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/22.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AppDelegate+AppService.h"

@implementation AppDelegate (AppService)
-(void)addLauchAdvertisementView
{
    LaunchAdvertisementView*view_advertise=[[LaunchAdvertisementView alloc]initWithWindow:self.window adType:1];
}
- (void)configurationLaunchUserOption {
}

- (void)registerUmeng {
}


- (void) registerEaseMob {
    
    [GXPushTool RegisterEaseMob];
}


+ (void)updateAppBadgeNumber {
  //  [((GXAppDelegate*)[UIApplication sharedApplication].delegate) setMessage];
}


/**
 *   清除在线客服提醒数目
 */
+ (void)removeOnlineBadges {
    
    // 清除小红点
    NSInteger count = [GXUserInfoTool getCutomerNum];
    if (count > 0) {
        [GXUserInfoTool clearCutomerNum];
        [[NSNotificationCenter defaultCenter] postNotificationName:GXOnlineServiceCountNotificationName object:nil];
    }
    
    
}


/**
 *   增加界面红点
 */
+ (void)showBadgeOnItemIndex:(int)index {
    GXTabBarController *controller = (GXTabBarController*)[self activityViewController];
   // [controller.gxTabBar showBadgeOnItemIndex:index];
}

/**
 *   清除界面红点
 */
+ (void)hideBadgeOnItemIndex:(int)index {
    GXTabBarController *controller = (GXTabBarController*)[self activityViewController];
  //  [controller.gxTabBar hideBadgeOnItemIndex:index];
}



+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

@end
