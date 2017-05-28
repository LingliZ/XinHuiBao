//
//  PriceDetailTradeView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceMarketModel;
@class PriceUserTradeMarginModel;

@protocol PriceDetailTradeViewDelegate <NSObject>

//建仓成功后进入持仓
-(void)priceDetailTradeViewDelegate_openOrderInsertOk;
//入金
-(void)priceDetailTradeViewDelegate_inGold;
//问号
-(void)priceDetailTradeViewDelegate_question;
@end

@interface PriceDetailTradeView : UIView<UITextFieldDelegate>

@property (nonatomic, assign)id <PriceDetailTradeViewDelegate> delegate;

@property (nonatomic,strong) PriceUserTradeMarginModel *marginModel;

//用于更新显示买入/卖出价格,和提交所用数据
-(void)setPriceShowView:(PriceMarketModel*)marketModel;

//用户点击做空或者做多按钮，用于判定是做多还是做空
-(void)setTradeTypeIndex:(NSInteger) tradeIndex;//0 空 1 多

//用户可用预付款等内容
-(void)setPriceUserTradeMarginModel:(PriceUserTradeMarginModel *)tradeModel;

@end
