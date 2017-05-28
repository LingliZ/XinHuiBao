//
//  PositionListModel.h
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionListModel : NSObject

//名字
@property(nonatomic,copy)NSString *InvestmentCode;

//方向
@property(nonatomic,copy)NSString *OrderLongShort_text;//1做多 2做空
@property(nonatomic,copy)NSString *OrderLongShort;


//建仓时间
@property(nonatomic,copy)NSString *OrderTime;

//建仓价
@property(nonatomic,copy)NSString *OrderPrice;

//平仓价（现价）
@property(nonatomic,copy)NSString *OrderClosePrice;

//浮动盈亏（盈亏）
@property(nonatomic,copy)NSString *OrderProfit;//持仓没用,历史有用,持仓里不读接口自己计算
@property (nonatomic,strong) NSMutableAttributedString *OrderProfit_att;

//方向背景颜色
@property (nonatomic,strong)UIColor *OrderLongShortBackgColor;

//手数
@property(nonatomic,copy)NSString *OrderAmount;

//买价
@property (nonatomic,copy) NSString *buy;

//卖价
@property (nonatomic,copy) NSString *sell;

//code
@property (nonatomic,copy) NSString *QuoteUUID;

//隔夜利息
@property (nonatomic,copy) NSString *OrderInsterest;

//订单号
@property (nonatomic,copy) NSString *ExchangeOrderID;

//手续费
@property (nonatomic,copy) NSString  *OrderCommission;

//LocalOrderID
@property (nonatomic,copy) NSString  *LocalOrderID;


@end
