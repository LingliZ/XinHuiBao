//
//  PriceMarketModel.h
//  XHBApp
//
//  Created by shenqilong on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceMarketModel : NSObject



/**
 *  买价
 */
@property (nonatomic,copy) NSString *buy;


/**
 *  现货名称代码
 */
@property (nonatomic,copy) NSString *code;


/**
 *  交易场所代码
 */
@property (nonatomic,copy) NSString *excode;

/**
 *  交易场所名称
 */
@property (nonatomic,copy) NSString *exname;


/**
 *  来自
 */
@property (nonatomic,copy) NSString *from;

/**
 *  最高
 */
@property (nonatomic,copy) NSString *high;


/**
 *  最新价格
 */
@property (nonatomic,copy) NSString *last;
/**
 *  昨收
 */
@property (nonatomic,copy) NSString *lastclose;
/**
 *  最低
 */
@property (nonatomic,copy) NSString *low;


/**
 *  现货名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  开盘
 */
@property (nonatomic,copy) NSString *open;


/**
 *  报价时间
 */
@property (nonatomic,copy) NSString *quoteTime;

/**
 *  报价时间不带年月日
 */
@property (nonatomic,copy) NSString *quoteTime2;

/**
 *  卖价
 */
@property (nonatomic,copy) NSString *sell;


/**
 *  状态
 */
@property (nonatomic,copy) NSString *status;


/**
 *  交易量
 */
@property (nonatomic,copy) NSString *volume;

/**
 *  地点
 */
@property (nonatomic,copy) NSString *shortName;












/**
 *  涨幅
 */
@property (nonatomic,copy) NSString *increase;

/**
 *  涨幅百分比
 */
@property (nonatomic,copy) NSString *increasePercentage;

/**
 *  涨幅的背景颜色
 */
@property (nonatomic, strong) UIColor *increaseBackColor;

/**
 *  最新价格颜色
 */
@property (nonatomic, strong) UIColor *lastColor;

/**
 *  买价的颜色
 */
@property (nonatomic, strong) UIColor *buyColor;

/**
 *  卖价的颜色
 */
@property (nonatomic, strong) UIColor *sellColor;

/**
 *  最高的颜色
 */
@property (nonatomic,strong) UIColor *highColor;

/**
 *  最低的颜色
 */
@property (nonatomic,strong) UIColor *lowColor;

/**
 *  根据昨收的比较
 *
 *  @param value 参数
 *
 *  @return 不同的颜色
 */
- (UIColor *)compareWithLastClose:(NSString *)value;


//写死自定义标签1
@property (nonatomic,copy) NSString *customTag1;

//点差
@property (nonatomic,copy) NSString *spread;

//买卖的背景
@property (nonatomic, strong) UIColor *sellOrBuy_bgColor;

//文字放大买价
@property (nonatomic,strong) NSMutableAttributedString *buy_headLarg;

//文字放大卖价
@property (nonatomic,strong) NSMutableAttributedString *sell_headLarg;

//是否显示可交易标签
@property (nonatomic,assign) BOOL status_hidden;









@end
