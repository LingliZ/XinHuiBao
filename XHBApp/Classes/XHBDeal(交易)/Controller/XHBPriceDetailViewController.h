//
//  XHBPriceDetailViewController.h
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceMarketModel;

@interface XHBPriceDetailViewController : UIViewController

@property (nonatomic, strong) PriceMarketModel *marketModel;

@property (nonatomic,assign)BOOL fromTradeEnter;//从及时、挂单交易的k线点进来用
@property (nonatomic,assign)BOOL fromLimitEnter;//从挂单详细的k线点进来用
@property (nonatomic,assign)BOOL fromCloseEnter;//从平仓详细的k线点进来用

@end
