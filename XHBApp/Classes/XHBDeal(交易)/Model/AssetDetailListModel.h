//
//  AssetListModel.h
//  XHBApp
//
//  Created by shenqilong on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetDetailListModel : NSObject
@property(nonatomic,copy)NSString * tradetime;// 订单时间
@property(nonatomic,copy)NSString *spnumber;// 实盘号
@property(nonatomic,copy)NSString * bankname;// 银行名称 如果operationtype： 0入金银行、1出金银行
@property(nonatomic,copy)NSString * amountnum;//订单金额
@property(nonatomic,strong)NSMutableAttributedString * amountnum_att;
@property(nonatomic,copy)NSString * currencysign; //币种
@property(nonatomic,copy)NSString * operationtype;/// 入金0出金1
@property(nonatomic,copy)NSString * operationtype_text;
@property(nonatomic,strong)UIColor * operationtype_color;
@property(nonatomic,copy)NSString * drawnumber; // 支付订单号
@property(nonatomic,copy)NSString * drawnumberid; // 交易编号
@property(nonatomic,copy)NSString * accountcurrency;// 出金币种
@property(nonatomic,copy)NSString * payamount;  //兑换后金额
@property(nonatomic,copy)NSString * paycurrency;// 币种 人民币
@property(nonatomic,copy)NSString * exchangerate; //汇率
@property(nonatomic,copy)NSString * status;  //手工审核结果 0审核中 1成功  2失败
@property(nonatomic,copy)NSString * status_text;
@property(nonatomic,strong)UIColor * status_color;
@property(nonatomic,copy)NSString * remark; //驳回原因
@property(nonatomic,copy)NSString * total;
@end
