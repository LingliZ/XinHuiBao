//
//  GXCalendarBaseModel.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarBaseModel.h"
#import "GXCalendarDataModel.h"
#import "GXCalendarEventModel.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXCalendarBaseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    if ([dictionary[@"type"] isEqualToString:@"data"]) {
        GXCalendarDataModel *dataModel = [GXCalendarDataModel new];
        [dataModel setValuesForKeysWithDictionary:dictionary];
        CGFloat dataHeight = [GXAdaptiveHeightTool lableHeightWithText:dataModel.name font:[UIFont systemFontOfSize:14] Width:30];
        dataModel.cellHeight = dataHeight + 70;

        return dataModel;
    }else{
        GXCalendarEventModel *eventModel = [GXCalendarEventModel new];
        [eventModel setValuesForKeysWithDictionary:dictionary];
        CGFloat eventHeight = [GXAdaptiveHeightTool lableHeightWithText:[NSString stringWithFormat:@"【事件】%@",eventModel.event] font:[UIFont systemFontOfSize:14] Width:30];
        eventModel.cellHeight = eventHeight + 70;

        return eventModel;
    }return nil;
}

@end
