//
//  GXUserInfoTool.m
//  GXApp
//
//  Created by WangLinfang on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXUserInfoTool.h"


@implementation GXUserInfoTool
+(BOOL)isLogin
{
    return [GXUserdefult boolForKey:ISLOGIN];
}
+(void)loginSuccess
{
    [GXUserdefult setBool:YES forKey:ISLOGIN];
    [GXUserdefult synchronize];
}
+(void)saveAppSessionId:(NSString *)appSessionId
{
    [GXUserdefult setObject:appSessionId forKey:AppSessionId];
    [GXUserdefult synchronize];
}
+(NSString*)getAppSessionId
{
    return [GXUserdefult objectForKey:AppSessionId];
}

+(NSString*)getUserSeesionTocken {
    return [GXUserdefult objectForKey:UserSeesionTocken];
}

+(void)loginOut
{
    NSMutableArray*keyArr=[[NSMutableArray alloc]initWithObjects:ISLOGIN,PhoneNumber,AppSessionId,LoginAccount,UserReallyName,UserIDCardNum,UserSeesionTocken,UserBankCardStatus, IsSkip,UserReallNameStatus,LoginAccountLevel,nil];
    for(NSString*key in keyArr)
    {
        [GXUserdefult setObject:nil forKey:key];
        [GXUserdefult removeObjectForKey:key];
    }
    [GXUserdefult synchronize];
    
     [Growing setCS1Value:nil forKey:@"user_id"];
    // 注销环信登录
    [self loginOutFromEaseMob];
}
/**
 *退出环信
 */
+(void)loginOutFromEaseMob
{
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
    }

}


/**
 *  保存用户姓名
 *
 *  @param userName 用户姓名
 */
+(void)saveUserReallyName:(NSString*)userName;
{
    [GXUserdefult setObject:userName forKey:UserReallyName];
    [GXUserdefult synchronize];
}
/**
 *  获取用户姓名
 *
 *  @return 用户姓名
 */
+(NSString*)getUserReallyName
{
    return [GXUserdefult objectForKey:UserReallyName];
}
/**
 *  获取用户昵称
 *
 *  @return 用户昵称
 */
+(NSString*)getUserNickName {
    NSString *nickName = [GXUserdefult objectForKey:userNickName];
    if (nickName) {
        return  nickName;
    } else {
        return  @"";
    }
}
/**
 *  保存用户头像
 *
 *  @param imageName 用户头像
 */
+(void)saveUserHeadImage:(NSString*)imageName {
    [GXUserdefult setObject:imageName forKey:userHeadImage];
    [GXUserdefult synchronize];
}


/**
 *  获取用户头像
 *
 *  @return 用户头像
 */
+(NSString*)getUserHeadImageName {
    NSString *headImage = [GXUserdefult objectForKey:userHeadImage];
    if (headImage) {
        return headImage;
    }
    
    return UserDefineHeadImage;
}

/**
 *保存用户实名认证状态
 */
+(void)saveIdentifyStatusWithStatus:(NSNumber*)status
{
    [GXUserdefult setObject:status forKey:UserReallNameStatus];
    [GXUserdefult synchronize];
}
/**
 *获取用户实名认证状态
 */
+(NSNumber*)getIdentifyStatus
{
    return [GXUserdefult objectForKey:UserReallNameStatus];
}
/**
 *保存用户银行卡状态
 */
+(void)saveUserBankCardStatus:(NSNumber*)bankCardStatus
{
    [GXUserdefult setInteger:bankCardStatus.intValue forKey:UserBankCardStatus];
    [GXUserdefult synchronize];
}
/**
 *获取用户银行卡状态
 */
+(NSNumber*)getUserBankCardStatus
{
    return [GXUserdefult objectForKey:UserBankCardStatus];
}
/**
 *保存用户银行卡号
 */
+(void)saveUserCardNumber:(NSString*)cardNumber
{
    [GXUserdefult setObject:cardNumber forKey:UserCardNumber];
    [GXUserdefult synchronize];
}
/**
 *获取用户银行卡号
 */
+(NSString*)getUserCardNumber
{
    return [GXUserdefult objectForKey:UserCardNumber];
}
/**
 *保存用户银行名字
 */
+(void)saveUserBankName:(NSString*)bankName
{
    [GXUserdefult setObject:bankName forKey:UserBankName];
    [GXUserdefult synchronize];
}
/**
 *获取用户银行名字
 */
+(NSString*)getUserBankName
{
    return [GXUserdefult objectForKey:UserBankName];
}

+(void)savePhoneNum:(NSString *)phoneNum
{
    [GXUserdefult setObject:phoneNum forKey:PhoneNumber];
    [GXUserdefult synchronize];
}
+(NSString*)getPhoneNum
{
    return [GXUserdefult objectForKey:PhoneNumber];
}

/**
 *  保存登录账号
 *
 *  @param loginAccount 登录账号
 */
+(void)saveLoginAccount:(NSString*)loginAccount
{
    [GXUserdefult setObject:loginAccount forKey:LoginAccount];
    [GXUserdefult synchronize];
}
/**
 *  获取登录账号
 *
 *  @return 登录账号
 */
+(NSString*)getLoginAccount
{
    return [GXUserdefult objectForKey:LoginAccount];
}
/**
 *  保存登录账号级别
 *
 *  @param level 登录账号级别
 */
+(void)saveLoginAccountLevelWithLevel:(NSString*)level
{
    [GXUserdefult setObject:level forKey:LoginAccountLevel];
    [GXUserdefult synchronize];
}
/**
 *  获取登录账号级别
 *
 *  @return 登录账号级别
 */
+(NSString*)getLoginAccountLevel
{
    return [GXUserdefult objectForKey:LoginAccountLevel];
}

/**
 *  保存用户身份证号码
 *
 *  @param idCardNum 身份证号码
 */
+(void)saveUserIDCardNum:(NSString*)idCardNum
{
    [GXUserdefult setObject:idCardNum forKey:UserIDCardNum];
    [GXUserdefult synchronize];
}
/**
 *  获取用户身份证号码
 *
 *  @return 身份证号码
 */
+(NSString*)getIDCardNum
{
    return [GXUserdefult objectForKey:UserIDCardNum];
}
/**
 *  是否联网
 *
 *  @return 结果
 */
+(BOOL)isConnectToNetwork
{
//同步
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
//    struct sockaddr_in6 address;
//    bzero(&address, sizeof(address));
//    address.sin6_len = sizeof(address);
//    address.sin6_family = AF_INET6;
//#else
//    struct sockaddr_in address;
//    bzero(&address, sizeof(address));
//    address.sin_len = sizeof(address);
//    address.sin_family = AF_INET;
//#endif
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&address);
//
//    SCNetworkReachabilityFlags flags;
//    if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
//        BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
//        return isReachable;
//    }
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    return [[AFNetworkReachabilityManager sharedManager]isReachable];
    
 //   return NO;
}
/**
 *  是否接收消息
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveMessage
{
    if(![GXUserdefult boolForKey:IsFirstRun])
    {
        [GXUserdefult setBool:YES forKey:IsFirstRun];
        [GXUserdefult setBool:YES forKey:IsReceiveMessage];
        [GXUserdefult synchronize];
    }
    return [GXUserdefult boolForKey:IsReceiveMessage];
}

/**
 *  根据用户身份证号码获取用户的年龄
 *
 *  @param id_CardNum 身份证号码
 *
 *  @return 用户年龄
 */
+(NSString*)getUserAgeWithID_CardNum:(NSString*)id_CardNum
{
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self birthdayStrFromIdentityCard:id_CardNum]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",-age];
}
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    if([numberStr length]==18)
    {
            //**截取前14位
            NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        
            //**检测前14位否全都是数字;
            const char *str = [fontNumer UTF8String];
            const char *p = str;
            while (*p!='\0') {
                if(!(*p>='0'&&*p<='9'))
                    isAllNumber = NO;
                p++;
            }
            if(!isAllNumber)
                return result;
        
            year = [numberStr substringWithRange:NSMakeRange(6, 4)];
            month = [numberStr substringWithRange:NSMakeRange(10, 2)];
            day = [numberStr substringWithRange:NSMakeRange(12,2)];
        
            [result appendString:year];
            [result appendString:@"-"];
            [result appendString:month];
            [result appendString:@"-"];
            [result appendString:day];
            return result;

    }
    else
    {
        //**截取前12位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];
        
        //**检测前12位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        if(!isAllNumber)
            return result;
        
        
        year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(6, 2)]];
        month = [numberStr substringWithRange:NSMakeRange(8, 2)];
        day = [numberStr substringWithRange:NSMakeRange(10,2)];
        
        
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    
    return @"";
    
}


/**
 *  是否第一次启动
 *
 */
+ (BOOL)isAppFirstLanuch {
    if (![GXUserdefult boolForKey:@"isAppFirstLanuch"]) {
        [GXUserdefult setBool:YES forKey:@"isAppFirstLanuch"];
        [GXUserdefult synchronize];
        return YES;
    } else {
        return NO;
    }
}

// 保存环信账号
+ (void)saveEaseMobAccount:(NSString *)account Password:(NSString *)password {
    [GXUserdefult setObject:account forKey:EaseMobAccount];
    [GXUserdefult setObject:password forKey:EaseMobPassword];
    [GXUserdefult synchronize];
}


+ (NSDictionary *)getEaseMobAccoutAndPassword {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[EaseMobAccount] = [GXUserdefult objectForKey:EaseMobAccount];
    dict[EaseMobPassword] = [GXUserdefult objectForKey:EaseMobPassword];
    
    return dict;
}

+(void)saveUserLastTradeContract:(NSString *)contract
{
    [GXUserdefult setObject:contract forKey:UserLastTradeContract];
    [GXUserdefult synchronize];
}

+(NSString *)getUserLastTradeContract
{
    NSString *c=[GXUserdefult objectForKey:UserLastTradeContract];
    if(c && [c floatValue]>0)
    {
        return c;
    }else
    {
        [GXUserdefult setObject:@"0.01" forKey:UserLastTradeContract];
        return @"0.01";
    }
}

/*
 *获取客服提醒数
 */
+ (NSInteger)getCutomerNum {
    return [[GXUserdefult objectForKey:cutomerNumber] integerValue];
}

/*
 *清除客服提醒数
 */
+ (void)clearCutomerNum {
    [GXUserdefult setObject:[NSNumber numberWithInteger:0] forKey:cutomerNumber];
    [GXUserdefult synchronize];
    
    
    
}

/**
 *点击实名认证相关后的跳转
 *@param viewController 视图控制器
 */
+(void)turnAboutVertyNameForViewController:(UIViewController*)viewController
{
    [GXUserdefult setBool:YES forKey:IsSkip];
    int  IDCardStatus=[[self getIdentifyStatus]intValue];
   // int bankCardStatus=[[self getUserBankCardStatus]intValue];
    if(IDCardStatus==0||IDCardStatus==3)
    {
        //实名认证
        XHBRealNameVertyViewController*reallNameVC=[[XHBRealNameVertyViewController alloc]init];
        [viewController.navigationController pushViewController:reallNameVC animated:YES];
        return;
    }
    if(IDCardStatus==2)
    {
        //跳转到用户信息详情界面
        XHBuserIdentityInfoViewController*infoVC=[[XHBuserIdentityInfoViewController alloc]init];
        [viewController.navigationController pushViewController:infoVC animated:YES];
        return;
    }
}
/**
 *点击银行卡相关后的跳转
 *@param viewController 视图控制器
 */
+(void)turnAboutBankCardForViewController:(UIViewController*)viewController
{
    [GXUserdefult setBool:YES forKey:IsSkip];
    int  IDCardStatus=[[self getIdentifyStatus]intValue];
    int bankCardStatus=[[self getUserBankCardStatus]intValue];

    if(IDCardStatus==0||IDCardStatus==3)
    {
        //实名认证
        if(bankCardStatus==1||bankCardStatus==2)
        {
            //已完成绑卡
            if([viewController isKindOfClass:[XHBInOrOutGoldViewController class]])
            {
                XHBRealNameVertyViewController*reallNameVC=[[XHBRealNameVertyViewController alloc]init];
                [viewController.navigationController pushViewController:reallNameVC animated:YES];
            }
        }
        else{
            XHBRealNameVertyViewController*reallNameVC=[[XHBRealNameVertyViewController alloc]init];
            [viewController.navigationController pushViewController:reallNameVC animated:YES];
        }
        return;
    }
    if((IDCardStatus==1||IDCardStatus==2)&&(bankCardStatus==0||bankCardStatus==3))
    {
        //添加银行卡
        XHBAddBankCardViewController*addBankVC=[[XHBAddBankCardViewController alloc]init];
        [viewController.navigationController pushViewController:addBankVC animated:YES];
        return;
    }
    
    //需增加“判断视图控制器的种类”
    if((IDCardStatus==1||IDCardStatus==2)&&(bankCardStatus==1||bankCardStatus==2))
    {
        if([viewController isKindOfClass:[XHBInOrOutGoldViewController class]])
        {
            if(bankCardStatus==1)
            {
                GXAlertView *al=[[GXAlertView alloc]initWithTitle:@"提示" message:@"您的信息已提交成功，请您耐心等待，审核通过后可进行出金操作" delegate:viewController cancelButtonTitle:@"致电客户" otherButtonTitles:@"取消",nil];
                [al show];
                return;
            }
            //跳转到入金界面
            XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
            ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_withdrawapp,[GXUserInfoTool getAppSessionId],random()];
            ingold.homeTit=@"出金";
            [viewController.navigationController pushViewController:ingold animated:YES];
        }
    }
}



@end
