//
//  GXUserInfoTool.h
//  GXApp
//
//  Created by WangLinfang on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBRealNameVertyViewController.h"
#import "XHBAddBankCardViewController.h"
#import "XHBuserIdentityInfoViewController.h"
#import "XHBInGoldViewController.h"
#import "XHBInOrOutGoldViewController.h"
@interface GXUserInfoTool : NSObject



#pragma mark--是否已登录
/**
*  返回当前是否已登录
*
*  @return 登录状态
*/
+(BOOL)isLogin;
#pragma mark--登录成功
/**
 *  登录成功
 */
+(void)loginSuccess;
#pragma mark--保存用户AppSessionId
/**
 *   登录后保存用户AppSessionId
 *
 *  @param appSessionId appSessionId
 */
+(void)saveAppSessionId:(NSString *)appSessionId;
#pragma mark--获取用户AppSessionId
/**
 获取用户AppSessionId
 */
+(NSString*)getAppSessionId;
#pragma 获取用户SeesionTocken
/**
 获取用户SeesionTocken
 */
+(NSString*)getUserSeesionTocken;
#pragma mark--退出登录
/**
 退出登录
 */
+(void)loginOut;
#pragma mark--退出环信
/**
 *退出环信
 */
+(void)loginOutFromEaseMob;
#pragma mark--保存用户姓名
/**
 *  保存用户姓名
 *
 *  @param userName 用户姓名
 */
+(void)saveUserReallyName:(NSString*)userName;
#pragma mark--获取用户姓名
/**
 *  获取用户姓名
 *
 *  @return 用户姓名
 */
+(NSString*)getUserReallyName;
#pragma mark--获取用户昵称
/**
 *  获取用户昵称
 *
 *  @return 用户昵称
 */
+(NSString*)getUserNickName;
#pragma mark--保存用户头像
/**
 *  保存用户头像
 *
 *  @param imageName 用户头像
 */
+(void)saveUserHeadImage:(NSString*)imageName;
#pragma mark--获取用户头像
/**
 *  获取用户头像
 *
 *  @return 用户头像
 */
+(NSString*)getUserHeadImageName;
#pragma mark--保存用户实名认证状态
/**
 *保存用户实名认证状态
 */
+(void)saveIdentifyStatusWithStatus:(NSNumber*)status;
#pragma mark--获取用户实名认证状态
/**
 *获取用户实名认证状态
 */
+(NSNumber*)getIdentifyStatus;
#pragma mark--保存用户银行卡状态
/**
 *保存用户银行卡状态
 */
+(void)saveUserBankCardStatus:(NSNumber*)bankCardStatus;
#pragma mark--获取用户银行卡状态
/**
 *获取用户银行卡状态
 */
+(NSNumber*)getUserBankCardStatus;
#pragma mark--保存用户银行卡号
/**
 *保存用户银行卡号
 */
+(void)saveUserCardNumber:(NSString*)cardNumber;
#pragma mark--获取用户银行卡号
/**
 *获取用户银行卡号
 */
+(NSString*)getUserCardNumber;
#pragma mark--保存用户银行名字
/**
 *保存用户银行名字
 */
+(void)saveUserBankName:(NSString*)bankName;
#pragma mark--获取用户银行名字
/**
 *获取用户银行名字
 */
+(NSString*)getUserBankName;
#pragma mark--保存用户手机号
/**
 保存用户手机号
 */
+(void)savePhoneNum:(NSString*)phoneNum;
#pragma mark--获取用户手机号
/**
 获取用户手机号
 */
+(NSString*)getPhoneNum;
#pragma mark--保存登录账号
/**
 *  保存登录账号
 *
 *  @param loginAccount 登录账号
 */
+(void)saveLoginAccount:(NSString*)loginAccount;
#pragma mark--获取登录账号
/**
 *  获取登录账号
 *
 *  @return 登录账号
 */
+(NSString*)getLoginAccount;
#pragma mark--保存登录账号级别
/**
 *  保存登录账号级别
 *
 *  @param level 登录账号级别
 */
+(void)saveLoginAccountLevelWithLevel:(NSString*)level;
#pragma mark--获取登录账号级别
/**
 *  获取登录账号级别
 *
 *  @return 登录账号级别
 */
+(NSString*)getLoginAccountLevel;
#pragma mark--保存用户身份证号码
/**
 *  保存用户身份证号码
 *
 *  @param idCardNum 身份证号码
 */
+(void)saveUserIDCardNum:(NSString*)idCardNum;
#pragma mark-- 获取用户身份证号码
/**
 *  获取用户身份证号码
 *
 *  @return 身份证号码
 */
+(NSString*)getIDCardNum;
#pragma mark--是否联网
/**
 *  是否联网
 *
 *  @return 结果
 */

+(BOOL)isConnectToNetwork;
#pragma mark--是否接收消息
/**
 *  是否接收消息
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveMessage;
#pragma mark--根据用户身份证号码获取用户的年龄
/**
 *  根据用户身份证号码获取用户的年龄
 *
 *  @param id_CardNum 身份证号码
 *
 *  @return 用户年龄
 */
+(NSString*)getUserAgeWithID_CardNum:(NSString*)id_CardNum;

#pragma mark-获取默认的自选行情
/**
 *  获取默认的自选行情
 */
+ (NSString *)getDefaultPersonSelectPriceCode;
#pragma mark--是否是第一次启动
/**
 *  是否是第一次启动
 */
+ (BOOL)isAppFirstLanuch;
#pragma mark--保存环信账号密码
/*
 * 保存环信账号密码
 */
+ (void)saveEaseMobAccount:(NSString *)account Password:(NSString *)password;
#pragma mark--获取环信账号密码
/*
 * 获取环信账号密码
 */
+ (NSDictionary *)getEaseMobAccoutAndPassword;
#pragma mark--获取报价提醒列表
/**
 *  获取报价提醒列表
 */
+ (NSMutableArray *)getPriceAlarmArray;
#pragma mark--增加客服回复数
/**
 增加客服回复数
 */
+ (void)addCutomerNum;

#pragma mark--获取客服提醒数
/*
 *获取客服提醒数
 */
+ (NSInteger)getCutomerNum;
+ (void)clearCutomerNum;
#pragma mark--保存报价提醒列表
/**
 *  保存报价提醒列表
 */
+ (void)savePriceAlarmArray:(NSMutableArray *) array;
#pragma mark--增加报价数
/*
 *增加报价数
 */
+(void)addAlarmNum;
#pragma mark--增加建议数
/**
 增加建议数
 */
+(void)addSuggestNum;
#pragma mark--增加回复数
/**
增加回复数
 */
+(void)addReplyNum;
#pragma mark--获取消息提醒数
/*
 *获取消息提醒数
 */
+(int)getAlarmNum;
#pragma mark--获取建议数
/**
 获取建议数
 */
+(int)getSuggestNum;
#pragma mark--获取回复个数
/**
 获取回复个数
 */
+(int)getReplyNum;

+(void)clearAlarmNum;


+(void)clearSuggestNum;


+(void)clearReplyNum;

+(void)addGXMessageNum;

+(void)clearGXMessageNum;

+(int)getGXMessageNum;
#pragma mark--获取用户最后一次下单手数
+(NSString *)getUserLastTradeContract;//获取用户最后一次下单手数
#pragma mark--报存用户最后一次下单手数
+(void)saveUserLastTradeContract:(NSString *)contract;//报存用户最后一次下单手数
#pragma mark--点击实名认证相关后的跳转
/**
 *点击实名认证相关后的跳转
 *@param viewController 视图控制器
 */
+(void)turnAboutVertyNameForViewController:(UIViewController*)viewController;
#pragma mark--点击银行卡相关后的跳转
/**
 *点击银行卡相关后的跳转
 *@param viewController 视图控制器
 */
+(void)turnAboutBankCardForViewController:(UIViewController*)viewController;
@end
