//
//  XHBUrl.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#ifndef XHBUrl_h
#define XHBUrl_h

#define imageBaseUrl @"https://image.91guoxin.com/cloud"
#define baseUrl @"https://app.91guoxin.com" // 服务器
#define baseUrl_com @"http://www.91pme.com"
//#define baseUrl_mine @"http://3g.xhb.bj"//  【测试】 注册，登录，发送验证码,交易，获取头像
#define baseUrl_mine @"https://mm.91pme.com"//  【正式】 注册，登录，发送验证码,交易，获取头像
//#define baseUrl_mine @"http://192.168.99.252:10800" //【LWork】
//#define homeCycleBaseUrl @"http://www.91pme.com"
//http://www.91pme.com/api/bannerlist/catid/3/limit/5

//#define EaseMobCusterKey @"u1423191635866"     //正式的客服key
//#define EaseMobCusterKey @"yangji"             //测试的客服key
//admin
#define EaseMobCusterKey @"admin"             //鑫汇宝测试的客服key

#define GXUrl_DeviceRegister [NSString stringWithFormat:@"%@/device/register",baseUrl] //设备注册

//行情
#define GXUrl_marketInfo    [NSString stringWithFormat:@"%@/market/query/marketInfo",baseUrl]   // 列表：platform=ios
#define GXUrl_timeline      [NSString stringWithFormat:@"%@/market/query/timeline",baseUrl]         //分时线：code=xagusd&period=1
#define GXUrl_kLineType     [NSString stringWithFormat:@"%@/market/query/kLineType",baseUrl]       //K线级别
#define GXUrl_kline         [NSString stringWithFormat:@"%@/market/query/kline",baseUrl]               //K线图 maxrecords=200&code=xagusd&level=1
#define GXUrl_quotation     [NSString stringWithFormat:@"%@/market/query/quotation",baseUrl]       //产品报价 交易所报价 code=xagusd excode=tjpme
#define GXUrl_istradetime   [NSString stringWithFormat:@"%@/market/query/is-trade-time",baseUrl]    //查是否是交易中 ?code=llg  get请求



//交易
#define GXUrl_tradingaccount [NSString stringWithFormat:@"%@/app/tradingaccount",baseUrl_mine]//查询账户资金
#define GXUrl_openorder [NSString stringWithFormat:@"%@/app/openorder",baseUrl_mine]//查询持仓
#define GXUrl_openorderinsert [NSString stringWithFormat:@"%@/app/openorderinsert",baseUrl_mine]//建仓
#define GXUrl_closeorderinsert [NSString stringWithFormat:@"%@/app/closeorderinsert",baseUrl_mine]//平仓
#define GXUrl_historyorder [NSString stringWithFormat:@"%@/app/historyorder",baseUrl_mine]//历史
#define GXUrl_tradingaccount [NSString stringWithFormat:@"%@/app/tradingaccount",baseUrl_mine]//查询账户资金
#define GXUrl_depositapp [NSString stringWithFormat:@"%@/depositapp",baseUrl_mine]//入金
#define GXUrl_withdrawapp [NSString stringWithFormat:@"%@/withdrawapp",baseUrl_mine]//出金
#define GXUrl_getfinancedetail [NSString stringWithFormat:@"%@/depositapp/getfinancedetail",baseUrl_mine]//支付记录

#define GXUrl_appqtaccount [NSString stringWithFormat:@"%@/app/qtaccount",baseUrl_mine]//查资金
#define GXUrl_appqueryopenorder [NSString stringWithFormat:@"%@/app/queryopenorder",baseUrl_mine]//查持仓
#define GXUrl_appquerylimitorder [NSString stringWithFormat:@"%@/app/querylimitorder",baseUrl_mine]//查挂单
#define GXUrl_appmt4historyorder [NSString stringWithFormat:@"%@/app/mt4historyorder",baseUrl_mine]//查历史
#define GXUrl_appmt4order [NSString stringWithFormat:@"%@/app/mt4order",baseUrl_mine]//下单
#define GXUrl_appordercancel [NSString stringWithFormat:@"%@/app/ordercancel",baseUrl_mine]//撤单
#define GXUrl_apporderclose [NSString stringWithFormat:@"%@/app/orderclose",baseUrl_mine]//平仓
#define GXUrl_appordermodify [NSString stringWithFormat:@"%@/app/ordermodify",baseUrl_mine]//修改止损止盈


//会员中心
#define XHBUrl_sendVertyNum   [NSString stringWithFormat:@"%@/app/sendmobilevalid",baseUrl_mine] //发送验证码   mobile(手机号)
#define XHBUrl_vertyVertyNum   [NSString stringWithFormat:@"%@/app/checkmobilevalid",baseUrl_mine] //验证验证码 mobile(手机号)，valid （验证码）
#define XHBUrl_register     [NSString stringWithFormat:@"%@/app/shipan",baseUrl_mine]         //注册 	mobile,  valid , password  最长12位
#define XHBUrl_login     [NSString stringWithFormat:@"%@/app/login",baseUrl_mine]             //登录  	spnumber(实盘账号) ， password
//app/sendmobile
#define XHBUrl_sendVertyNum_forgetPassword [NSString stringWithFormat:@"%@/app/sendmobile",baseUrl_mine] //发送重置密码的验证码 mobile=
#define XHBUrl_forgetPassword [NSString stringWithFormat:@"%@/app/resetpassword",baseUrl_mine] //重置密码 mobile，valid，password
#define XHBUrl_changePassword [NSString stringWithFormat:@"%@/app/updatepassword",baseUrl_mine] //修改密码 AppSessionId, oldpassword, newpassword
#define XHBUrl_getUserInfo [NSString stringWithFormat:@"%@/app/getuserinfo",baseUrl_mine] //获取用户信息  AppSessionId
#define XHBUrl_tradeAccount [NSString stringWithFormat:@"%@/app/qtaccount",baseUrl_mine] //查询账户资金 AppSessionId
#define XHBUrl_uploadImage [NSString stringWithFormat:@"%@/app/upload",baseUrl_mine] //上传图片 AppSessionId=，type=（idcard_front 身份证正面，idcard_behind 身份证反面 ，bankcard 银行卡正面），file=（要上传的数据）
#define XHBUrl_vertyUserIdentify  [NSString stringWithFormat:@"%@/app/updateuserinfo",baseUrl_mine] //实名认证/绑定银行卡  AppSessionId，realName，idCardNum/bankCardNum
//@"/help-list"
#define GXUrl_helpList   [NSString stringWithFormat:@"%@/help-list",baseUrl]//帮助中心
//@"/article-detail"
#define GXUrl_articleDetail    [NSString stringWithFormat:@"%@/article-detail",baseUrl] //文章详情：id=12345
#define GXUrl_HomeCycle    [NSString stringWithFormat:@"%@/api/bannerlist/",homeCycleBaseUrl]
#define GXUrl_finance [NSString stringWithFormat:@"%@/finance",baseUrl]
#define GXUrl_index [NSString stringWithFormat:@"%@/index",baseUrl]

#define XHBUrl_ArticleList [NSString stringWithFormat:@"%@/api/articlelist",baseUrl_com]// 文章（帮助中心）列表  catid=
#define XHBUrl_ArticleDetail  [NSString stringWithFormat:@"%@/api/articledetail",baseUrl_com]// 文章/问题详情  id=
#define XHBUrl_FeedBack [NSString stringWithFormat:@"%@/app/feedback",baseUrl_mine] //意见反馈  msg（必填） AppSessionId（可为空）
#endif /* XHBUrl_h */

