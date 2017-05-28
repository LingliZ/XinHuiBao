//
//  GXPushTool.m
//  GXApp
//
//  Created by futang yang on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPushTool.h"


//#define EaseMobAppKey @"155-255#guoxinapp0104" //国鑫测试
//#define EaseMobAppKey @"91jin#91jinappv2" //国鑫正式
#define EaseMobAppKey @"155-255#xinhuibao" //鑫汇宝测试



@interface GXPushTool () <EMChatManagerDelegate>

@end


@implementation GXPushTool

+ (void)registerSDKWithAppKey {
    /*
     3.x
    EMOptions*options=[EMOptions optionsWithAppkey:EaseMobAppKey];
    options.apnsCertName=@"guoxin";
    [[EMClient sharedClient]initializeSDKWithOptions:options];
     */
    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMobAppKey apnsCertName:@"production2"];
}


+ (void)registerForRemoteNotificationsWith:(UIApplication *)application {
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
}

+ (void)LoginEaseMobWith:(NSString *)Username password:(NSString *)password {

    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
            
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:Username
                                                                password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                    if (loginInfo && !error) {
                                                                        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                                                                        options.displayStyle=ePushNotificationDisplayStyle_messageSummary;
                                                                        
                                                                        [[EaseMob sharedInstance].chatManager updatePushOptions:options error:nil];
                                                                        [[EaseMob sharedInstance].chatManager setApnsNickname:@"国鑫"];
                                                                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                        // 登录成功
                                                                        GXLog(@"登录环信成功");
                                                                    }
                                                                    
                                                                } onQueue:nil];
        } onQueue:nil];
        
        
    } else {
        
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:Username
                                                                password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                    if (loginInfo && !error)
                                                                    {
                                                                        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                                                                        options.displayStyle=ePushNotificationDisplayStyle_messageSummary;
        
                                                                        [[EaseMob sharedInstance].chatManager updatePushOptions:options error:nil];
                                                                        [[EaseMob sharedInstance].chatManager setApnsNickname:@"鑫汇宝贵金属"];
                                                                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                        // 登录成功
                                                                        GXLog(@"登录环信成功");
                                                                    }
                                                                } onQueue:nil];
        
    }

}





+ (NSString *)getTimeNow {
    NSString *date = nil;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}



+ (void)RegisterEaseMob {
    
    
    NSString *account = [self getTimeNow];
    NSString *password = @"abc123";
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        
        if (!error) {
            
            GXLog(@"注册成功");
            
            // 保存账号
            [GXUserInfoTool saveEaseMobAccount:account Password:password];
            
            // 登录环信
            [self LoginEaseMobWith:account password:password];
            
        }
    } onQueue:nil];
    
}



+ (void)LogoutEaseMob {
    
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
    }
}



@end
