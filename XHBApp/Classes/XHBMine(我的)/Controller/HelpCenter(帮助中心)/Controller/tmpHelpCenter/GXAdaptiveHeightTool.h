//
//  GXAdaptiveHeightTool.h
//  GXApp
//
//  Created by GXJF on 16/7/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAdaptiveHeightTool : NSObject
//创建类方法计算lable的高度
+ (CGFloat)lableHeightWithText:(NSString *)text font:(UIFont *)font Width:(CGFloat)width;
//根据字符串计算lable的宽度
+ (CGFloat)labelWidthFromString:(NSString *)str FontSize:(CGFloat)FontSize;
//创建类方法根据image计算imageView的高度
+ (CGFloat)imageScaleHeightWith:(NSString *)imageName;

//提示框自动消失
+(void)showMessage:(NSString *)message Time:(NSTimeInterval)time;
/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
//加载css文件类方法
+ (NSString *)htmlWithContent:(NSString *)content title:(NSString *)title adddate:(NSString *)addate author:(NSString *)author source:(NSString *)source ;
//计算两个日期相差的天数,(忽略24小时之内)
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
//字符在日期格式转换
+(NSString *)getDateStyle:(NSString *)dateStr;



@end
