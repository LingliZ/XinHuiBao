//
//  XHBThirdTarget.h
//  XHBApp
//
//  Created by WangLinfang on 17/4/8.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#ifndef XHBThirdTarget_h
#define XHBThirdTarget_h

//判断是否是原来的target
#ifdef XHBApp
//1.注册的时候增加channel字段=anqu
//2.logo
//3.名称改变为“鑫汇贵金属”
//4.友盟的替换 anqu@91pme.com abc123
//5.Gio wangmiao@91guoxin.com  abc123
//6.极光推送 anqu_91pme /abc123
#define Home_title @"鑫汇宝"
#define about_headImage @"logo"
#define about_version @"V1.1.2"
#define about_name @"鑫汇宝·贵金属"
#define Regist_Channel @"iOS"
#define GrowingAppKey @"b4326f4bcc1eec58"
#define UMSocialDataAppKey @"586c53c6f29d985325000491"
#define JPUSHAppKey @"30cc67a9ac69903aa7f88ffc"

#endif

//判断是否是鑫汇贵金属的target
#ifdef XHGJS
#define Home_title @"鑫汇贵金属"
#define about_headImage @"logo-xhgjs"
#define about_version @"V1.0"
#define about_name @"鑫汇·贵金属"
#define Regist_Channel @"anqu"
#define GrowingAppKey @"b4326f4bcc1eec58"
#define UMSocialDataAppKey @"58e7016804e20526190000c7"
#define JPUSHAppKey @"5d8b84efb3c63c30bcc9eddc"

#endif

//判断是否是金银操盘的target
#ifdef JYCP

#define Home_title @"金银操盘"
#define about_headImage @"logo-jycp"
#define about_version @"V1.0"
#define about_name @"金银操盘"
#define Regist_Channel @"yousen"
#define GrowingAppKey @"b4326f4bcc1eec58"
#define UMSocialDataAppKey @"58f6bb3d7666134d7c001e2c"
#define JPUSHAppKey @"8f00b2cb4e48c3b750562040"


#endif

#endif /* XHBThirdTarget_h */
