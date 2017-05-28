//
//  GXDeviceConfigTool.m
//  GXApp
//
//  Created by yangfutang on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXDeviceConfigTool.h"

NSString * const KEY_IN_KEYCHAIN = @"com.91jin.gxapp.UUID";
NSString * const KEY_PASSWORD = @"com.91jin.gxapp.password";

@implementation GXDeviceConfigTool

+ (NSString *)deviceid_UUID {
    
    NSString *identifierStr = [self uuid];
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:identifierStr forKey:KEY_PASSWORD];
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[self loadFromKeychain:KEY_IN_KEYCHAIN];
    
    
    if (readUserPwd) {
        for (NSString *theKey in [readUserPwd allKeys])
        {
            if ([theKey isEqualToString:KEY_PASSWORD])
            {
                //有UUID，取出来
                return [readUserPwd objectForKey:theKey];
            }
        }
        //没有UUID，存一个
        [self saveToKeychain:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
        return identifierStr;
    } else {
        //没有UUID，存一个
        [self saveToKeychain:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
        return identifierStr;
    }
}


//取
+(id)loadFromKeychain:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            GXLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+(NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}


// 存
+(void)saveToKeychain:(NSString *)service data:(id)data{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
}

+(NSString*)uuid{
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    
    uuid =  [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return uuid;
}


+ (NSString *)model {
    
    return [UIDevice currentDevice].model;
}

+ (NSString *)systemVersion {
    
    return [UIDevice currentDevice].systemVersion;
}


+ (NSString *)name {
    
    return @"ios";
}

+ (NSString *)device_Token {
    
    return [GXUserdefult objectForKey:GXAppDevice_token];
}



@end
