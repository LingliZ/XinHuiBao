//
//  GXSingInstance.m
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXSingInstance.h"


@implementation GXSingInstance

static GXSingInstance *instance= nil;

+(id)getInstance
{
    if(instance == nil)
    {
        instance = [[GXSingInstance alloc] init];
    }
    
    return instance;
}


-(id) init
{
    if(self=[super init])
    {
        self.last_lastDic=[[NSMutableDictionary alloc]init];
    }
    return  self;
}

- (NSString *)getnNetworkDate:(NSInteger)n{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(n != 0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay * n];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    
    date_formatter=nil;
    
    return the_date_str;
}

@end
