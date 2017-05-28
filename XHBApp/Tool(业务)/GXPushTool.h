//
//  GXPushTool.h
//  GXApp
//
//  Created by futang yang on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//  推送工具

#import <Foundation/Foundation.h>
#import <EaseMobSDK/EaseMob.h>


@protocol EMChatManagerDelegate;

@interface GXPushTool : NSObject


/**
 *  通过Appkey注册环信
 */
+ (void)registerSDKWithAppKey;

/**
 *  登录到环信
 *
 *  @param Username 账户
 *  @param password 密码
 */
+ (void)LoginEaseMobWith:(NSString *)Username password:(NSString *)password;

/**
 *  注册本地通知
 *
 */

+ (void)registerForRemoteNotificationsWith:(UIApplication *)application;


/**
 *  注册环信
 *
 */
+ (void)RegisterEaseMob;


@end
