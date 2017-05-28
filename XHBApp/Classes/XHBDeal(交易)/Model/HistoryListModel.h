//
//  HistoryListModel.h
//  XHBApp
//
//  Created by shenqilong on 16/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryListModel : NSObject

@property(nonatomic,copy)NSString *TotalCount;
@property(nonatomic,copy)NSString *Agent;
@property(nonatomic,copy)NSString *OrderTime;
@property(nonatomic,copy)NSString *QuoteUUID;
@property(nonatomic,copy)NSString *LocalOrderID;
@property(nonatomic,copy)NSString *ExchangeOrderID;
@property(nonatomic,copy)NSString *InvestmentCode;
@property(nonatomic,copy)NSString *ExchangeCloseOrderID;
@property(nonatomic,copy)NSString *OrderLongShort;
@property(nonatomic,copy)NSString *OrderOpenClose;
@property(nonatomic,copy)NSString *OrderAmount;
@property(nonatomic,copy)NSString *OrderAvailableAmount;
@property(nonatomic,copy)NSString *OrderPrice;
@property(nonatomic,copy)NSString *OrderType;
@property(nonatomic,copy)NSString *OrderSlippage;
@property(nonatomic,copy)NSString *OrderStatus;
@property(nonatomic,copy)NSString *OrderClosePrice;
@property(nonatomic,copy)NSString *OrderOtcCode;
@property(nonatomic,copy)NSString *OrderOtcFee;
@property(nonatomic,copy)NSString *OrderProfit;
@property(nonatomic,copy)NSString *OrderInsterest;
@property(nonatomic,copy)NSString *OrderCommission;
@property(nonatomic,copy)NSString *OrderNetProfit;
@property(nonatomic,copy)NSString *TotalLots;
@property(nonatomic,copy)NSString *TotalInsterest;
@property(nonatomic,copy)NSString *TotalProfit;

//类型
@property(nonatomic,copy)NSString *OrderLongShort_text;
//订单号
@property(nonatomic,copy)NSString *LocalOrderID_text;
//时间去掉时分秒
@property(nonatomic,copy)NSString *OrderTime_noHMM;
//方向背景颜色
@property (nonatomic,strong)UIColor *OrderLongShortBackgColor;
//类型颜色
@property (nonatomic,strong)UIColor *OrderOpenCloseBackgColor;
//类型是否显示
@property (nonatomic,assign)BOOL OrderOpenClose_isHidden;
//左边标题
@property(nonatomic,copy)NSString *left_tit;
//左边内容
@property(nonatomic,copy)NSMutableAttributedString *left_val_att;
//中间标题
@property(nonatomic,copy)NSString *middle_tit;
//中间内容
@property(nonatomic,copy)NSMutableAttributedString *middle_val_att;
//右边标题
@property(nonatomic,copy)NSString *right_tit;
@end
