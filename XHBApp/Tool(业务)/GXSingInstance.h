//
//  GXSingInstance.h
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GXInstance [GXSingInstance getInstance]

@interface GXSingInstance : NSObject

+(GXSingInstance*)getInstance;

@property(nonatomic,strong) NSMutableDictionary *last_lastDic;//储存行情最后报价与颜色 {code:[1234.00,redcolor]}

- (NSString *)getnNetworkDate:(NSInteger)n;



@property(nonatomic,strong) id trade_userMarginModel;//交易用

@end
