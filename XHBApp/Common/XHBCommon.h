//
//  XHBCommon.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#ifndef XHBCommon_h
#define XHBCommon_h

#define GXUserdefult [NSUserDefaults standardUserDefaults] // 偏好设置
#define GXAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //当前App版本

//16进制颜色宏
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 颜色
#define GXColor(r,g,b,p) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(p)]
#define GXRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 导航栏背景颜色
#define GXNavigationBarBackColor [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000]
// 导航栏
#define GXNavigationBarTitleColor  [UIColor whiteColor]



//屏幕宽高
#define GXScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define GXScreenWidth ([UIScreen mainScreen].bounds.size.width)
//获取状态栏的高度
#define STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
//获取navbar的高度
#define NAVBAR_HEIGHT 44
//获取tabbar的高度
#define TABBAR_HEIGHT 49

//基于6适配其他尺寸
#define HeightScale_IOS6(height) ((height/667.0) * GXScreenHeight)
#define WidthScale_IOS6(width) ((width/375.0) * GXScreenWidth)

//基于6适配其他尺寸
#define HeightScale_IOS6(height) ((height/667.0) * GXScreenHeight)
#define WidthScale_IOS6(width) ((width/375.0) * GXScreenWidth)
#define WidthLandScale_IOS6(width) ((width/375.0) * GXScreenHeight)
#define HeightLandScale_IOS6(height) ((height/667.0) * GXScreenWidth)
// 主window
#define GXKeyWindow [UIApplication sharedApplication].keyWindow

// 手机型号
#define SCREEN_MAX_LENGTH (MAX(GXScreenWidth, GXScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(Screen_width, Screen_height))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_6_OR_LESS (IS_IPHONE_6 || IS_IPHONE_6P)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//字体SIZE
#define GXHomeFontFit10 (IS_IPHONE_6 ? 10:(IS_IPHONE_6P ? 12:8))

#define GXHomeFontFit12 (IS_IPHONE_6 ? 12:(IS_IPHONE_6P ? 14:10))

#define GXHomeFontFit14 (IS_IPHONE_6 ? 14:(IS_IPHONE_6P ? 16:12))




//黄色主色调
#define GXMainColor [UIColor colorWithRed:1 green:151.0/255 blue:84.0/255 alpha:1]
// 淡灰线 #EEEEEE
#define GXLightLineColor [UIColor colorWithWhite:0.933 alpha:1.000]
//字体绿色 #55C554
#define GXGreenColor [UIColor colorWithRed:0.333 green:0.773 blue:0.329 alpha:1.000]
//字体红色 #F15B6F
#define GXRedColor [UIColor colorWithRed:0.945 green:0.357 blue:0.435 alpha:1.000]
//字体灰色 #9B9B9B
#define GXGrayColor [UIColor colorWithWhite:0.608 alpha:1.000]
// 灰色线 #CCCCCC
#define GXLineColor [UIColor colorWithWhite:0.894 alpha:1.000]
//白色背景颜色
#define GXPriceBackGroundColor [UIColor colorWithWhite:0.973 alpha:1.000]
//字体黑色 #4A4A4A
#define GXBlackColor [UIColor colorWithWhite:0.290 alpha:1.000]
//字体黑色 #000000
#define GXBlackTextColor [UIColor blackColor]
//字体橘黄色 #FF971C
#define GXOrangeColor [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000]
// 白色
#define GXWhiteColor [UIColor whiteColor]



#define GXRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/*****************************交易页面（行情列表和行情详细页，交易视图）******************************************/
//线灰色(行情tableview)
#define GXGrayLineColor [UIColor colorWithRed:242.0/255 green:243.0/255 blue:243.0/255 alpha:1.000]
//字体灰色(行情标题)
#define GXGray_priceTitleColor [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.000]
//字体黑色(行情name)
#define GXBlack_priceNameColor [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.000]
//字体黑色2（行情bar）
#define GXBlack_priceDetailBarTextColor [UIColor colorWithRed:95.0/255 green:95.0/255 blue:95.0/255 alpha:1.000]
//字体灰色(行情name)
#define GXGray_priceNameColor [UIColor colorWithRed:196.0/255 green:196.0/255 blue:196.0/255 alpha:1.000]
//行情背景红色
#define GXRed_priceBackgColor [UIColor colorWithRed:245.0/255 green:98.0/255 blue:98.0/255 alpha:1.000]
//行情背景绿色
#define GXGreen_priceBackgColor [UIColor colorWithRed:0/255 green:184.0/255 blue:118.0/255 alpha:1.000]
//行情详细页报价框颜色
#define GXWhite_priceDetailBackg_boardColor [UIColor colorWithRed:242.0f/255 green:243.0/255 blue:243.0/255 alpha:0.28]
//行情详细交易页面手数文本框用的灰色
#define GXGray_priceDetailTrade_TextFieldBackgColor [UIColor colorWithRed:245.0f/255 green:245.0/255 blue:245.0/255 alpha:1]
//行情详细交易页面文本灰色字体
#define GXGray_priceDetailTrade_TextColor [UIColor colorWithRed:175.0f/255 green:175.0f/255 blue:175.0f/255 alpha:1]
//行情详细交易页面文本灰色字体
#define GXGray_PositionTrade_TextColor [UIColor colorWithRed:124.0f/255 green:124.0f/255 blue:124.0f/255 alpha:1]
//历史仓单时间背景
#define GXGray_HistoryListTimeBackgColor [UIColor colorWithRed:183.0f/255 green:185.0f/255 blue:196.0f/255 alpha:1]
//历史仓单条件背景蓝条
#define GXBlue_HistoryListFilterBackgColor [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]






//字体SIZE
#define GXFONT_PingFangSC_Light(s) (IS_OS_9_OR_LATER ? GXFONTPingFangSC_Light(s):GXFONTHelvetica_light(s))

#define GXFONT_PingFangSC_Regular(s) (IS_OS_9_OR_LATER ? GXFONTPingFangSC_Regular(s):GXFONTHelvetica_regular(s))

#define GXFONT_PingFangSC_Medium(s) (IS_OS_9_OR_LATER ? GXFONTPingFangSC_Medium(s):GXFONTHelvetica_medium(s))



//字体Size
#define PriceListCellFont16 (IS_IPHONE_5_OR_LESS ? 14:16)
#define PriceListCellFont14 (IS_IPHONE_5_OR_LESS ? 12:14)



// For text, messages, etc
#define GXFONT_SIZE10    10
#define GXFONT_SIZE12    12
#define GXFONT_SIZE14    14
#define GXFONT_SIZE15    15
#define GXFONT_SIZE17    17
#define GXFONT_SIZE18    18
#define GXFONT_SIZE20    20
#define GXFONT_SIZE24    24
#define GXDEFAULTFONT_SIZE    17



//字体样式
//pangfang-light
#define GXFONTPingFangSC_Light(s) [UIFont fontWithName:@"PingFangSC-Light" size:s]
#define GXFONTHelvetica_light(s) [UIFont fontWithName:@"Helvetica-Light" size:s]
//ping-regular
#define GXFONTPingFangSC_Regular(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
#define GXFONTHelvetica_regular(s) [UIFont fontWithName:@"Helvetica" size:s]
//ping-medium
#define GXFONTPingFangSC_Medium(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s]
#define GXFONTHelvetica_medium(s) [UIFont fontWithName:@"Helvetica" size:s]
//helvetica-light
#define GXFONT_Helvetica(s) [UIFont fontWithName:@"Helvetica" size:s]

#define GXFONT_Helvetica_Light(s) [UIFont fontWithName:@"Helvetica-Light" size:s]



// 手机系统版本
#define iOS8ORLESS ([UIDevice currentDevice].systemVersion.floatValue <= 8.0)
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

/**
 *  利用十六进制颜色绘制图片
 *
 *  @param hex 十六进制颜色
 *
 *  @return 绘制成的图片
 */
#define ImageFromHex(hex) [UIImage getImageWithHexColor:hex]
/**
 *监听编辑状态来调整按钮的状态
 */
#define AddObserver_EditingState_changeBtnState [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editClick) name:UITextFieldTextDidChangeNotification object:nil];
// GXLog打印
#ifdef DEBUG
# define GXLog(fmt, ...); NSLog((fmt @"   ------函数名:%s," "行号:%d"), ##__VA_ARGS__, __FUNCTION__, __LINE__);
# define XHBPushCertificate @"develope"
#else
# define GXLog(...);
# define XHBPushCertificate @"production"
#endif



#endif /* XHBCommon_h */
