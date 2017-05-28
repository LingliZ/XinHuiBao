#import "GXHttpTool.h"
#import "GXCacheTool.h"
#import "MJExtension.h"
#import "GXDeviceConfigTool.h"

#define timeoutInterValue 20

@interface GXHttpTool ()

@end


@implementation GXHttpTool

NSString * const GXHttpRequestCache = @"GXHttpRequestCache";

static  NSDictionary* httpDic = nil;

#pragma mark - life Circle
//单例
+(instancetype)shareHttpTool {
    static GXHttpTool *shareHttpTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHttpTool = [GXHttpTool client];
    });
    
    return shareHttpTool;
}

+ (instancetype)client {
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];

    GXHttpTool *manger = [[self alloc] initWithBaseURL:nil sessionConfiguration:configration];
    //设置响应内容格式  经常因为服务器返回的格式不是标准json而出错 服务器可能返回text/html text/plain 作为json
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"image/png", nil];
    
    NSString *DeviceToken = [GXDeviceConfigTool device_Token];
    if (DeviceToken && DeviceToken.length > 0) {
        [manger.requestSerializer setValue:DeviceToken forHTTPHeaderField:@"device-token"];
    }

     [manger.requestSerializer setValue:@"403" forHTTPHeaderField:@"version"];

     [manger.requestSerializer setValue:@"ios" forHTTPHeaderField:@"system"];
    
    
    
    return manger;
}



+(NSDictionary*) getHttpDic{

    if (httpDic==nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GXUrl" ofType:@"plist"];
        httpDic=[[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return httpDic;

}

#pragma mark - Public Method Get Post
+ (NSURLSessionDataTask *)Get:(NSString *)UrlString
                   parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    
    
    return [self requestMethod:GXHttpRequestMethodGet urlString:UrlString parameters:parameters  timeoutInterval:timeoutInterValue cacheType:GXHttpOnlyRequest success:^(NSURLSessionDataTask *task, id responeseObject) {
        success(responeseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)GetCacheThenRequest:(NSString *)UrlString
                                   parameters:(id)parameters
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    return [self requestMethod:GXHttpRequestMethodGet urlString:UrlString parameters:parameters  timeoutInterval:timeoutInterValue cacheType:GXHttpCacheReturnLastCache success:^(NSURLSessionDataTask *task, id responeseObject) {
        success(responeseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)UrlString
                    parameters:(id)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    return [self requestMethod:GXHttpRequestMethodPost urlString:UrlString parameters:parameters  timeoutInterval:timeoutInterValue cacheType:GXHttpOnlyRequest success:^(NSURLSessionDataTask *task, id responeseObject) {
        
        success(responeseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)POSTCache:(NSString *)UrlString
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure {
    return [self requestMethod:GXHttpRequestMethodPost urlString:UrlString parameters:parameters timeoutInterval:timeoutInterValue cacheType:GXHttpCacheReturnLastCache success:^(NSURLSessionDataTask *task, id responeseObject) {
        
        success(responeseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}


#pragma mark - privat Method (返数据从缓存或请求的)
/**
 *  返数据从缓存或请求的
 */
+ (NSURLSessionDataTask *)requestMethod:(GXHttpRequestMethod)requestMethod
                              urlString:(NSString *)UrlString
                             parameters:(id)parameters
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                              cacheType:(GXHttpCaceType)cacheType
                                success:(void (^)(NSURLSessionDataTask *task, id responeseObject))success
                                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    
    // 同步请求防刷token
    if (![GXUserdefult objectForKey:GXAppDevice_token]) {
        [self registerDevice];
    }
    
    
    
   
    
    //*************** CacheKey(url+param转码)
    UrlString = UrlString.length?UrlString:@"";
    NSString *cacheKey = UrlString;
    if (parameters) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [cacheKey stringByAppendingString:paramStr];
    }
    
    GXLog(@"%@",cacheKey);
    
    
    GXCacheTool *cacheTool = [GXCacheTool cacheWithName:GXHttpRequestCache];
    cacheTool.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cacheTool.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    // 缓存数据
    id object = [cacheTool objectForKey:cacheKey];
    
    
    //*************** 监测网络状态
    __weak  AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == AFNetworkReachabilityStatusNotReachable) {
            GXLog(@"网络请求 无网络");
            if (object) {
                success(nil, object);
            } else {
                failure(nil, nil);
            }
            
            [manager stopMonitoring];
            return;
        }
    }];
    
    //***************  缓存策略
    switch (cacheType) {
        case GXHttpOnlyRequest: {
            cacheKey = nil;
            break;
        }
            
        case GXHttpCacheReturnLastCache: {
            break;
        }
            
        case GXHttpCacheIgnoringLocalCacheData: {
            break;
        }
            
        case GXHttpCacheReturnCacheDataDontLoad: {
            if (object) {
                success(nil, object);
            }
            return nil;
        }
            
        default: {
            break;
        }
    }
    // 返回 NSURLSessionDataTask
    return [self requestMethod:requestMethod urlString:UrlString parameters:parameters timeoutInterval:timeoutInterval cache:cacheTool cacheKey:cacheKey success:success failure:failure];
}



#pragma mark - 最底层处理(存储缓存)
/**
 *  最底层处理(缓存，字典转模型)
 */
+ (NSURLSessionDataTask *)requestMethod:(GXHttpRequestMethod)type
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                                  cache:(GXCacheTool *)cache
                               cacheKey:(NSString *)cacheKey
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
    
    
    GXHttpTool *manger = [GXHttpTool shareHttpTool];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manger.requestSerializer setTimeoutInterval:timeoutInterval];
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 登录后增加token
    NSString *UserToken = [GXUserInfoTool getAppSessionId];
    if (UserToken && UserToken.length > 0) {
        [manger.requestSerializer setValue:UserToken forHTTPHeaderField:@"X-IDENTIFY-TOKEN"];
    }else{
    
       [manger.requestSerializer setValue:nil forHTTPHeaderField:@"X-IDENTIFY-TOKEN"];
    }
    
    // 增加seesionToken
    NSString *SeesionTocken = [GXUserInfoTool getUserSeesionTocken];
    if (SeesionTocken && SeesionTocken.length > 0) {
        [manger.requestSerializer setValue:SeesionTocken forHTTPHeaderField:@"x-auth-token"];
    }else{
        
        [manger.requestSerializer setValue:nil forHTTPHeaderField:@"x-auth-token"];
    }
    
    switch (type) {
            
        case GXHttpRequestMethodGet: {
            
            return [manger GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (responseObject) {
                    
                    responseObject = [self HandleReceiveObject:responseObject];
                    success(task, responseObject);
                    
                    if (cacheKey) {
                        [cache setObject:responseObject forKey:cacheKey];
                    }
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task, error);
            }];
            break;
        }
            
        case GXHttpRequestMethodPost: {
            
            return [manger POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
               // GXLog(@"token:%@",[(NSHTTPURLResponse *)task.response allHeaderFields][@"x-auth-token"]);
                // 服务器缓存token
                if ([(NSHTTPURLResponse *)task.response allHeaderFields][@"x-auth-token"]) {
                  //  [GXUserdefult setObject:[(NSHTTPURLResponse *)task.response allHeaderFields][@"x-auth-token"] forKey:UserSeesionTocken];
                }
                
                
                if (responseObject) {
                    if([responseObject isKindOfClass:[NSDictionary class]])
                    {
                        responseObject = [self HandleReceiveObject:responseObject];
                    }
                    success(task, responseObject);
                    
                    if (cacheKey) {
                        [cache setObject:responseObject forKey:cacheKey];
                    }
                }
                
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(task, error);
              
            }];
            break;
        }
            
        default:
            break;
    }
    
}


// 添加错误状态和处理成功json
+ (instancetype)HandleReceiveObject:(id)responseObject {
    
    int status = [responseObject[@"success"] intValue];
    if (status == 1) {
        return responseObject;
    } else {
        
        int status = [responseObject[@"errCode"] intValue];
        NSString *errorString = responseObject[@"message"];
        
        
        // 添加错误状态
        if (status) {
            GXLog(@"errorCode = %d 错误信息 = %@", status,errorString);
            
            // 特殊情况 重新请求token
            if (status == -1) {
                //重新请求token
               [self registerDevice];
                
            }
            
            //接口不支持
            if (status == -6) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新程序" message:@"接口过早，请更新最新版本" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
                [alertView show];
            }

            
            // 公共错误处理（不显示）
            if (status < 0 && status != -1) {
                return responseObject;
            }
            
            
            
        }
        
        return responseObject;
    }
}
+(void)post:(NSString *)url image:(NSData *)image params:(NSDictionary *)params name:(NSString *)name success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    GXHttpTool *manger = [GXHttpTool shareHttpTool];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manger.requestSerializer setTimeoutInterval:timeoutInterValue];
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 登录后增加token
    NSString *UserToken = [GXUserInfoTool getAppSessionId];
    if (UserToken && UserToken.length > 0) {
        [manger.requestSerializer setValue:UserToken forHTTPHeaderField:@"X-IDENTIFY-TOKEN"];
    }
    
    
    
    
    [manger POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"mine.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];

}
/*
+(void)post:(NSString *)url image:(NSData *)image name:(NSString *)name params:(NSDictionary*)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    GXHttpTool *manger = [GXHttpTool shareHttpTool];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manger.requestSerializer setTimeoutInterval:timeoutInterValue];
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 登录后增加token
    NSString *UserToken = [GXUserInfoTool getAppSessionId];
    if (UserToken && UserToken.length > 0) {
        [manger.requestSerializer setValue:UserToken forHTTPHeaderField:@"X-IDENTIFY-TOKEN"];
    }

    
    
    
    [manger POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"mine.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}
*/


+ (void)registerDevice{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = [GXDeviceConfigTool deviceid_UUID];
    param[@"type"] = [GXDeviceConfigTool model];
    param[@"system"] = [GXDeviceConfigTool name];
    param[@"systemVersion"] = [GXDeviceConfigTool systemVersion];
    param[@"appVersion"] = GXAppVersion;
    
    NSString *paramString = [NSString stringWithFormat:@"id=%@&type=%@&system=%@&systemVersion=%@&appVersion=%@",[GXDeviceConfigTool deviceid_UUID],[GXDeviceConfigTool model],[GXDeviceConfigTool name],[GXDeviceConfigTool systemVersion],GXAppVersion];
    NSData *ParamData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *DeviceRegisteUrl =nil;
    DeviceRegisteUrl=[NSURL URLWithString:GXUrl_DeviceRegister];
    
    
    NSMutableURLRequest *UrlQuest = [NSMutableURLRequest requestWithURL:DeviceRegisteUrl];
    [UrlQuest setHTTPMethod:@"POST"];
    [UrlQuest setHTTPBody:ParamData];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:UrlQuest returningResponse:&response error:&error];
    
    if (!data) {
        return;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    int status = [(NSNumber *)dict[@"success"] intValue];
    
    if (status == 1) {
        
        NSString *device_token = dict[@"value"];
        NSMutableString *newdevice_token = [[NSMutableString alloc] initWithCapacity:device_token.length];
        for (NSInteger i = device_token.length - 1; i >=0 ; i--) {
            unichar ch = [device_token characterAtIndex:i];
            [newdevice_token appendFormat:@"%c", ch];
        }
        
        [GXUserdefult setObject:newdevice_token forKey:GXAppDevice_token];
        [GXUserdefult synchronize];
        
        GXHttpTool *shareinstance  =  [self shareHttpTool];
        [shareinstance.requestSerializer setValue:newdevice_token forHTTPHeaderField:@"device-token"];
    }
    
    
    
}

@end
