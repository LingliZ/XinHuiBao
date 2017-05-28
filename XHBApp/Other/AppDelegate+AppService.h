//
//  AppDelegate+AppService.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/22.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)<UIAlertViewDelegate>
#pragma mark--添加开屏广告
///**
// *  添加开屏广告
// */
//-(void)addLauchAdvertisementView;
/**
 *  基本配置
 */
- (void)configurationLaunchUserOption;

/**
 *  友盟注册
 */
- (void)registerUmeng;


/**
 *   注册环信
 */
- (void)registerEaseMob;


/**
 *   更新提醒数量
 */
+ (void)updateAppBadgeNumber;

/**
 *   清除在线客服提醒数目
 */
+ (void)removeOnlineBadges;

/**
 *   清除我的界面红点
 */
+ (void)removeMineBadges;


+ (void)showBadgeOnItemIndex:(int)index;

/**
 *   清除我的界面红点
 */
+ (void)hideBadgeOnItemIndex:(int)index;

/**
 *   当前控制器
 */
+ (UIViewController *)activityViewController;

@end
