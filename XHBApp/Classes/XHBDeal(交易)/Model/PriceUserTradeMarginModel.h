//
//  PriceUserTradeMarginModel.h
//  XHBApp
//
//  Created by shenqilong on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceUserTradeMarginModel : NSObject

/**
 *  用户可用预付款样式1
 */
@property (nonatomic, strong) NSMutableAttributedString *userFreeMargin_att1;
@property (nonatomic, copy) NSString *FreeMargin;

/**
 *  用户可用预付款样式2
 */
@property (nonatomic, strong) NSMutableAttributedString *userFreeMargin_att2;


/**
 *  净值
 */
@property (nonatomic, strong) NSMutableAttributedString *userEquity_att;
@property (nonatomic, strong) NSMutableAttributedString *userEquity_att_smallFont;
@property (nonatomic, copy) NSString *Equity;


/**
 *  浮动盈亏
 */
@property (nonatomic, strong) NSMutableAttributedString *userFL_att;
@property (nonatomic, copy) NSString *FL;


/**
 *  预付款比例
 */
@property (nonatomic, copy) NSString *Risk;


/**
 *  结余
 */
@property (nonatomic, copy) NSString *DynamicBalance;

/**
 *  预付款
 */
@property (nonatomic, copy) NSString *Margin;


/**
 *  信用额
 */
@property (nonatomic, copy) NSString *Credit;
@end
