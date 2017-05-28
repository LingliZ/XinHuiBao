//
//  XHBHelpListModel.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBBaseModel.h"

@interface XHBHelpListModel : XHBBaseModel
@property(nonatomic,copy)NSString*id;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*created;
@property(nonatomic,strong)NSString*catid;
@property(nonatomic,strong)NSString*metadesc;
@property(nonatomic,strong)NSString*author;
@property(nonatomic,strong)NSString*catTitle;
@end
