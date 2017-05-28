//
//  AppDelegate.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GXTabBarController.h"
#import "XHBWelcomeViewController.h"
#import "XHBIndexViewController.h"
#import "TmpNavigationController.h"
#import "GXNavigationController.h"
#import "LaunchAdvertisementView.h"
#import "XHBRegisterViewController.h"
#import "GXGlobalArticleDetailController.h"
#import "GXXHBGlobalDetailController.h"
//#import "AppDelegate+AppService.h"
#import "JPUSHService.h"
//iOS10注册APNS所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate,EMChatManagerDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

