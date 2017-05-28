//
//  GXFileTool.m
//  GXApp
//
//  Created by futang yang on 16/7/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXFileTool.h"
#import "CCSSMAParam.h"

@implementation GXFileTool

/// 把对象转换成NSData类型
+ (NSData *)changeObjectToData:(id)objc{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objc];
    return data;
}

/// 把NSData接档成对象
+ (id)changeDataToObject:(NSData *)data {
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/// 根据文件名判断是否存在文件
+(BOOL)isExistFileName:(NSString *)fileName {
    if ([GXFileTool readObjectByFileName:fileName]) {
        return YES;
    }
    return NO;
}
/// 根据key名判断偏好设置里是否存在
+(BOOL)isExistKeyName:(NSString *)KeyName {
    if ([GXFileTool readUserDataForKey:KeyName]) {
        return YES;
    }
    return NO;
}

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName {
    
    NSString *path  = [self appendFilePath:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:path];
    
}
/// 通过文件名从沙盒中找到归档的对象
+(id)readObjectByFileName:(NSString*)fileName {
    
    NSString *path  = [self appendFilePath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName {
    
    NSString *path  = [self appendFilePath:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/// 拼接文件路径
+(NSString*)appendFilePath:(NSString*)fileName {
    
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file = [NSString stringWithFormat:@"%@/%@.archiver",documentsPath,fileName];
    return file;
}

/// 存储用户偏好设置 到 NSUserDefults
+(void)saveUserData:(id)data forKey:(NSString*)key {
    if (data) {
        [GXUserdefult setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
/// 读取用户偏好设置
+(id)readUserDataForKey:(NSString*)key {
    return [GXUserdefult objectForKey:key];
}
/// 删除用户偏好设置
+(void)removeUserDataForkey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}



/**
 *  将CCSSma模型数组归档
 *
 *  @param array CCSSma模型数组
 */
+ (void)saveCCSSmaArchiverArray:(NSArray *)array byFileName:(NSString*)fileName {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (CCSSMAParam *param in array) {
        NSData *data = [GXFileTool changeObjectToData:param];
        [dataArray addObject:data];
    }
    [GXFileTool saveObject:dataArray.mutableCopy byFileName:fileName];
}


+ (NSArray *)readCCSSmaUnarchiverArrayByFileName:(NSString *)fileName {

    NSMutableArray *resultArray = [NSMutableArray array];
    // 取归档数据
    if ([GXFileTool readObjectByFileName:fileName]) {
       
        NSArray *array = [GXFileTool readObjectByFileName:fileName];
        for (NSData *data in array) {
            CCSSMAParam *param = [GXFileTool changeDataToObject:data];
            [resultArray addObject:param];
        }
    }
    return resultArray.mutableCopy;
}



@end
