//
//  GXHttpTool.h
//  网络请求
//
//  Created by yangfutang on 16/6/24.
//  Copyright © 2016年 yangFutang. All rights reserved.
//  网络请求工具(缓存&转模型)

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


#define GXSuccess @"success"
#define GXValue @"value"

typedef NS_ENUM(NSUInteger, GXHttpRequestMethod){
    GXHttpRequestMethodGet = 0, // GET请求
    GXHttpRequestMethodPost     // POST请求
};

typedef NS_ENUM(NSUInteger, GXHttpCaceType){
    GXHttpOnlyRequest = 0,                // 只请求不缓存
    GXHttpCacheIgnoringLocalCacheData,    // 默认忽略缓存直接请求
    GXHttpCacheReturnLastCache,   // 先读缓存再同步请求
    GXHttpCacheReturnCacheDataDontLoad,   // 返回缓存不请求
};


@interface GXHttpTool : AFHTTPSessionManager

/**
 * 创建请求工具单例
 */
+(instancetype)shareHttpTool;


/**
 *  GET请求(只请求不缓存)
 *
 *  @param UrlString  URL
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)Get:(NSString *)UrlString
                   parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  GET请求(先返回缓存再请求)
 *
 *  @param UrlString  URL
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)GetCacheThenRequest:(NSString *)UrlString
                                   parameters:(id)parameters
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

/**
 *  POST请求(默认不缓存)
 *
 *  @param UrlString  URL
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)POST:(NSString *)UrlString
                   parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;



/**
 *  POST请求(请求并且缓存)
 *
 *  @param UrlString  URL
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)POSTCache:(NSString *)UrlString
                    parameters:(id)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  上传头像
 *
 *  @param url     URL
 *  @param image   图片数据流
 *  @param name    图片名字
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)post:(NSString *)url image:(NSData *)image params:(NSDictionary*)params name:(NSString *)name success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+(void)registerDevice;

@end















