//
//  GXCalendarBaseModel.h
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXCalendarBaseModel : NSObject
@property (nonatomic,strong)NSString *country;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *importance;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)CGFloat cellHeight;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;



@end
