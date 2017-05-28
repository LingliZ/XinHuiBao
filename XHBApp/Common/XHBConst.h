//
//  XHBConst.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#ifndef XHBConst_h
#define XHBConst_h

#define GXAppDevice_token @"GXAppDevice_token" // device_token
#define ISLOGIN @"isLogin" //用于设置用户登录状态
#define AppSessionId @"AppSessionId"//登录成功后获取到
#define UserSeesionTocken @"UserSeesionTocken"//登录成功后获取到seesionToken
#define IsReceiveMessage @"isReceiveMessage" //是否接收消息
#define IsFirstRun @"isFirstRun" //程序是否是首次运行
#define IsFirstLaunch @"IsFirstLaunch"
#define IsFromIndex @"IsFromIndex"//是否由引导页跳转而来（针对登录和注册相关的页面）

#define CustomerID @"customerId"//开户时获取到
#define PhoneNumber @"phoneNumber"//用户手机号
#define HeadImage @"headImage"//头像存储字段
#define NickNames @"nickName" //昵称
#define userNickName @"userNickName" //用户昵称
#define userHeadImage @"userHeadImage" // 用户头像url
#define UserDefineHeadImage @"mine_head" // 用户默认头像
#define onlineCutemerHeadImage @"onlineCutemer" // 默认客服头像
#define LoginAccount @"loginAccounts"//登录账号
#define LoginAccountLevel @"LoginAccountLevel"//实盘账号等级
#define UserReallyName @"userReallyName" //用户真实姓名
#define UserIDCardNum @"userIDCardNum" //用户身份证号
#define UserReallNameStatus @"UserReallNameStatus" //实名认证状态
#define UserBankCardStatus @"UserBankCardStatus" //用户银行卡状态
#define UserCardNumber @"UserCardNumber" //用户银行卡号
#define UserBankName @"UserBankName"//开户银行
#define IsSkip @"IsSkipVertyAfterRgisterSuccess" //注册成功后是否跳过
#define ViewControllerForReturn @"ViewControllerForReturn"  //验证完毕后需要返回的页面
#define XHBServicePhoneNum @"4001209212"//客服电话

#define Check_Name_Qualified @"check_name_qualified" //姓名格式符合
#define Check_Password_Qualified @"check_password_qualified" //密码格式符合
#define Check_NickName_Qualified @"check_nickname_qualified" //昵称格式符合

#define GXPriceMAsetControllerUserFilePath @"GXPriceMAsetControllerUserFilePathThree" // MA设置控制器的偏好设置key值
#define GXPriceMAsetControllerIsApplyToAllKey @"GXPriceMAsetControllerIsApplyToAllKey"   // MA设置控制器是否应用到所有均线key值

/*
 appdelegate相关
 */
#define GXOnlineServiceCountNotificationName @"GXOnlineServiceCountNotificationName" //在线客服提示数量
#define GXMineCountNotificationName @"GXMineCountNotificationName" //我的界面提示红点
#define GXHomeCountNotificationName @"GXHomeCountNotificationName" //主界面右上角通知

/*
 环信相关客服
 */
#define EaseMobAccount @"EaseMobAccount"//环信账号
#define EaseMobPassword @"EaseMobPassword"//环信登录密码

#define kMesssageExtWeChat @"weichat"
#define kMesssageExtWeChat_ctrlType @"ctrlType"
#define kMesssageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMesssageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMesssageExtWeChat_ctrlType_transferToKfHint  @"TransferToKfHint"
#define kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer @"hasTransfer"
#define kMesssageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMesssageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMesssageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMesssageExtWeChat_ctrlArgs_detail @"detail"
#define kMesssageExtWeChat_ctrlArgs_summary @"summary"
#define kMesssageExtWeChat_ctrlArgs_label @"label"

/*
 推送相关
 */
#define GXAppDevice_token @"GXAppDevice_token" // device_token
#define PriceAlarm @"GXPriceAlarm.plist"
#define priceAlarmNumber @"priceAlarmNumber" //报价提醒个数
#define replyNumber @"replyNumber" //顾问回复个数
#define suggestNumber @"suggestNumber" //即使建议个数
#define GXMessageNumber @"GXMessageNumber" //国鑫消息个数
#define cutomerNumber @"cutomerNumber" //客服消息个数


#define Color_btn_next_normal @"FF9754"//“下一步”按钮正常状态下的颜色
#define Color_btn_next_Highled @""//“下一步”按钮高亮状态下的颜色
#define Color_btn_next_enabled @"FECAA8"//“下一步”按钮禁用状态下的颜色

#define Color_lineView @"F4F5F5"//横线的颜色

#define UserLastTradeContract @"UserLastTradeContract"//用户最后一次下单交易的手数

#endif /* XHBConst_h */
