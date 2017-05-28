//
//  XHBHelpDetailModel.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBBaseModel.h"

@interface XHBHelpDetailModel : XHBBaseModel
@property(nonatomic,strong)NSString*introtext;
@property(nonatomic,strong)NSString*metadesc;
@property(nonatomic,strong)NSString*created;
@property(nonatomic,strong)NSString*xreference;
@property(nonatomic,strong)NSString*author;
@property(nonatomic,copy)NSString*id;
@end
