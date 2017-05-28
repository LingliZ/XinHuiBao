//
//  AppDelegate.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AppDelegate.h"
#import "Growing.h"
#import <UMMobClick/MobClick.h>
#import "AppDelegate+AppService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //开屏广告
//    [self addLauchAdvertisementView];
    
    //注册环信推送appkey
    [GXPushTool registerSDKWithAppKey];
    //本地通知注册
    [GXPushTool registerForRemoteNotificationsWith:application];
    //添加环信并设置代理
    [[EaseMob sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    float version=[[[UIDevice currentDevice]systemVersion]floatValue];
    if(version>=8.0)
    {
        UIUserNotificationSettings*setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    //growIO
    [Growing startWithAccountId:GrowingAppKey];
    
    if(![GXUserdefult boolForKey:IsFirstLaunch])
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        [GXPushTool RegisterEaseMob];
        [GXUserdefult setBool:YES forKey:IsFirstLaunch];
        [GXUserdefult synchronize];
        XHBIndexViewController*indexVC=[[XHBIndexViewController alloc]init];
        TmpNavigationController*nav=[[TmpNavigationController alloc]initWithRootViewController:indexVC];
        self.window.rootViewController=nav;
    }
    else
    {
        GXTabBarController *tabbarVC = [[GXTabBarController alloc] init];
        self.window.rootViewController = tabbarVC;
    }
    
    
    // 同步请求防刷token
    if (![GXUserdefult objectForKey:GXAppDevice_token]) {
        [GXHttpTool registerDevice];
    }
    
    
    
    //友盟统计
    UMConfigInstance.appKey = UMSocialDataAppKey;
    UMConfigInstance.channelId = @"App Store";
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    /*
     极光推送
     */
    //1.初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc]init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound ;
    if([[UIDevice currentDevice].systemVersion floatValue] >=8.0)
    {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //初始化JPush
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    NSLog(@"%@",deviceTokenStr);
    /*
     [[EMClient sharedClient]bindDeviceToken:deviceToken];
     [[EMClient sharedClient]registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
     }];
     */
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    /*
     极光
     */
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}

#pragma mark--环信收到消息
-(void)didReceiveMessage:(EMMessage *)message
{
    
    
    NSString *alert = ((EMTextMessageBody*)[message.messageBodies objectAtIndex:0]).text;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2];
    UILocalNotification *notifacation = [[UILocalNotification alloc] init];
    
    if (notifacation) {
        //设置推送时间
        notifacation.fireDate = date;
        //设置时区
        notifacation.timeZone = [NSTimeZone defaultTimeZone];
        //推送声音
        notifacation.soundName = UILocalNotificationDefaultSoundName;
        notifacation.alertBody = alert;
        
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notifacation];
    }
/*
    //后台
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2];
        UILocalNotification *notifacation = [[UILocalNotification alloc] init];
        
        if (notifacation) {
            //设置推送时间
            notifacation.fireDate = date;
            //设置时区
            notifacation.timeZone = [NSTimeZone defaultTimeZone];
            //推送声音
            notifacation.soundName = UILocalNotificationDefaultSoundName;
            notifacation.alertBody = alert;
            
            UIApplication *app = [UIApplication sharedApplication];
            [app scheduleLocalNotification:notifacation];
            
        }
    }
     */
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    GXLog(@"%@",userInfo);
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber=0;
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes=UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        UIUserNotificationSettings*settings=[UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if([Growing handleUrl:url])
    {
        return YES;
    }
    return NO;
}

#pragma mark- JPUSHRegisterDelegate
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    //iOS10
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self dealWithJPushInfo:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法

}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //iOS7
    [self dealWithJPushInfo:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}
#pragma mark--推送消息处理
-(void)dealWithJPushInfo:(NSDictionary*)userInfo
{
    if([UIApplication sharedApplication].applicationIconBadgeNumber)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber--;
    }
    NSString*str_message=userInfo[@"exMessage"];
    if(str_message.length)
    {
        NSArray*arr_message=[str_message componentsSeparatedByString:@"|"];
        NSString*str_mark1=[arr_message firstObject];
        NSString*str_mark2=[arr_message lastObject];
        UIViewController*vc;
        if([str_mark1 isEqualToString:@"UserRegister"])
        {
            //注册
            if([GXUserInfoTool isLogin])
            {
                return;
            }
            vc=[[XHBRegisterViewController alloc]init];
        }
        if([str_mark1 isEqualToString:@"OpenAccount"])
        {
            //开户
            if([GXUserInfoTool isLogin])
            {
                return;
            }

            vc=[[XHBRegisterViewController alloc]init];
        }
        if([str_mark1 isEqualToString:@"Information"])
        {
            //文章
            GXGlobalArticleDetailController*detailVC=[[GXGlobalArticleDetailController alloc]init];
            detailVC.kindsOfIdentifier=str_mark2;
            vc=detailVC;
        }
        if([str_mark1 isEqualToString:@"Active"])
        {
            //活动
            if(![str_mark2 hasPrefix:@"http"])
            {
                str_mark2=[@"http://" stringByAppendingString:str_mark2];
            }
            GXXHBGlobalDetailController *safeVC = [[GXXHBGlobalDetailController alloc]init];
            safeVC.recieveUrl = str_mark2;
            safeVC.title = @"活动";
            vc=safeVC;
        }

        if([self.window.rootViewController isKindOfClass:[GXTabBarController class]])
        {
            GXTabBarController*tabBarC=(GXTabBarController*)self.window.rootViewController;
            UINavigationController*selectedNav=tabBarC.childViewControllers[tabBarC.selectedIndex];
            [selectedNav pushViewController:vc animated:YES];
        }

    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"123");
     [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"XHBApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
