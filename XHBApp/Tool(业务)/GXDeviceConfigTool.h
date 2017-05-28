//
//  GXDeviceConfigTool.h
//  GXApp
//
//  Created by yangfutang on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDeviceConfigTool : NSObject

/**
 * 获取KeyChain中的UUID
 */
+ (NSString *)deviceid_UUID;

/**
 *  获取终端
 */
+ (NSString *)model;

/**
 *  系统版本
 */
+ (NSString *)systemVersion;

/**
 *  ios
 */
+ (NSString*)name;

/**
 *  获取DeviceToken
 */
+ (NSString *)device_Token;

@end
