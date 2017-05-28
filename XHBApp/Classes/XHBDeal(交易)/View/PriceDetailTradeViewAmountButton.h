//
//  PriceDetailTradeViewAmountButton.h
//  XHBApp
//
//  Created by shenqilong on 16/12/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderAmountButtonStyle) {
    OrderAmountButtonStyleUp,
    OrderAmountButtonStyleDown
};

@interface PriceDetailTradeViewAmountButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame style:(OrderAmountButtonStyle)style;
- (void)addLongPressGestureRecognizer:(id)target action:(SEL)action;
@end
