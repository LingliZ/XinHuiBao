//
//  GXFileTool.h
//  GXApp
//
//  Created by futang yang on 16/7/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXFileTool : NSObject

/// 把对象归档成NSData类型(对象需要是实现接档归档遵守NSCoding协议)
+ (NSData *)changeObjectToData:(id)objc;
/// 把NSData解档成对象
+ (id)changeDataToObject:(NSData *)data;

/// 根据文件名判断是否存在文件
+(BOOL)isExistFileName:(NSString *)fileName;

/// 根据key名判断偏好设置里是否存在
+(BOOL)isExistKeyName:(NSString *)KeyName;

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;

/// 通过文件名从沙盒中找到归档的对象
+(id)readObjectByFileName:(NSString*)fileName;

/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;





/**
 *  将CCSSma模型数组归档
 *
 *  @param array CCSSma模型数组
 */
+ (void)saveCCSSmaArchiverArray:(NSArray *)array byFileName:(NSString*)fileName;
/**
 *  返回CCSSma模型
 *
 *  @param fileName 路径
 *
 *  @return 模型数组
 */
+ (NSArray *)readCCSSmaUnarchiverArrayByFileName:(NSString *)fileName;







@end
