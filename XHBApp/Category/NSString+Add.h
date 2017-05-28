//
//  NSString+Add.h
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (Add)

/**
 *  返回一字符串的大小
 *
 *  @param size     最大size
 *  @param fontsize font大小
 *
 *  @return string的size
 */
- (CGSize)boundingWithSize:(CGSize)size FontSize:(CGFloat)fontsize;

/**
 *  是否为正整数
 */
- (BOOL)validatePositiveNumber:(NSString *)String;

/**
 *  判断字符串是否是纯汉字
 *
 *  @return 结果
 */
-(BOOL)isChinese;
/**
 *  校验姓名格式
 *
 *  @return 校验结果
 */
-(NSString*)checkName;
/**
 *  校验密码格式
 *
 *  @return 校验结果
 */
-(NSString*)checkPassword;
/**
 *校验交易密码格式
 *
 *@return 校验结果
 */
-(BOOL)checkPay_password;
/**
 *  校验昵称
 *
 *  @return 校验结果
 */
-(NSString*)checkNickName;
/**
 *  校验意见反馈中的联系方式格式
 *
 *  @return 校验结果
 */
-(NSString*)checkContactForFeedBack;
/**
 *  校验身份证格式是否合格
 *
 *  @return 校验结果
 */
-(BOOL)checkIDCardNum;
/**
 *  返回时间
 *
 *  @param quoteTime 时间戳(秒)
 *
 *  @return 时间
 */
+ (NSString *)StringFromquoteTime:(NSString *)quoteTime;
+ (NSString *)StringFromquoteTime_notYMD:(NSString *)quoteTime;
+ (NSString *)StringFromquoteTime_notHMM:(NSString *)quoteTime ;

/**
 *  传入float 转成相应的string
 *
 *  @param floatValue float
 *
 *  @return string
 */
+ (NSString *)getKlineValue:(CGFloat )floatValue;


+ (NSString *)stringToFloat:(float )fv Code:(NSString *)code;
/**
 *MD5加密
 *@return 加密结果
 */
+ (NSString *) md5:(NSString *) input;

@end
