//
//  XHBTradePositionModel.h
//  XHBApp
//
//  Created by shenqilong on 17/3/7.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBTradePositionModel : NSObject
@property(nonatomic,copy)NSString * closePrice;
@property(nonatomic,copy)NSString *closeTime;
@property(nonatomic,copy)NSString * cmd;//0多1空
@property(nonatomic,copy)NSString *comment;
@property(nonatomic,copy)NSString * commission;
@property(nonatomic,copy)NSString * commissionAgent;
@property(nonatomic,copy)NSString * convRate1;
@property(nonatomic,copy)NSString * convRate2;
@property(nonatomic,copy)NSString * digits;
@property(nonatomic,copy)NSString *expiration;
@property(nonatomic,copy)NSString * gwClosePrice;
@property(nonatomic,copy)NSString * gwOpenPrice;
@property(nonatomic,copy)NSString * gwVolume;
@property(nonatomic,copy)NSString * internalId;
@property(nonatomic,copy)NSString * login;
@property(nonatomic,copy)NSString * magic;
@property(nonatomic,copy)NSString * marginRate;
@property(nonatomic,copy)NSString *modifyTime;
@property(nonatomic,copy)NSString *openPrice;
@property(nonatomic,copy)NSString *openTime;
@property(nonatomic,copy)NSString * profit;
@property(nonatomic,copy)NSString * reason;
@property(nonatomic,copy)NSString * sl;
@property(nonatomic,copy)NSString * swaps;
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString * taxes;
@property(nonatomic,copy)NSString *ticket;
@property(nonatomic,copy)NSString *timestamp;
@property(nonatomic,copy)NSString * tp;
@property(nonatomic,copy)NSString * volume;
@property(nonatomic,copy)NSString * buy;
@property(nonatomic,copy)NSString * sell;
@property(nonatomic,copy)NSString *TotalLots;

@property(nonatomic,copy)NSString *symbolCode;


@property(nonatomic,copy)NSString *swapsCommission_str;//交易金额 手续费+隔夜
@property(nonatomic,copy)NSString *sl_str;
@property(nonatomic,copy)NSString *tp_str;
@property(nonatomic,copy)NSString * FL;

@property(nonatomic,copy)NSString *cmd_str;
@property(nonatomic,strong)UIColor *cmd_BackgColor;

@property(nonatomic,strong)NSMutableAttributedString *OrderProfit_att;
@property(nonatomic,strong)NSMutableAttributedString *OrderProfit_noCommission_att;

@property(nonatomic,copy)NSString *openTime_noHMM;


////////////////////历史列表专用

@property(nonatomic,copy)NSString *historyList_tag;
@property(nonatomic,strong)UIColor *historyList_tagBg;

//显示名字
@property(nonatomic,copy)NSString *hisName;
//左边标题
@property(nonatomic,copy)NSString *left_tit;
//左边内容
@property(nonatomic,copy)NSMutableAttributedString *left_val_att;
//右边标题
@property(nonatomic,copy)NSString *right_tit;
//右边内容
@property(nonatomic,copy)NSString *right_value;
//中间标题
@property(nonatomic,copy)NSString *middle_tit;
//中间内容
@property(nonatomic,copy)NSMutableAttributedString *middle_val_att;


@end
