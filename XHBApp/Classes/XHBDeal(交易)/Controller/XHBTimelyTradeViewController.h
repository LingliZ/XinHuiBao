//
//  XHBTimelyTradeViewController.h
//  XHBApp
//
//  Created by shenqilong on 17/2/28.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBTimelyTradeViewController : UIViewController
@property(nonatomic,copy) NSString *TradeCode;
@property(nonatomic,assign) int TradeDirection;//0做多 1做空 //0买入限价 1卖出限价 2买入止损 3卖出止损

@property(nonatomic,assign)BOOL isOpen1;//切换kview
@property(nonatomic,assign)BOOL isOpen2;//切换是否有挂单价格

-(void)setLabelAndTextFieldDefault;
-(void)updateKdata:(NSArray *)ar;
-(void)updateCodePrice:(NSArray *)ar;
-(void)updateUserMagin;
-(void)setDirectionButtonTitle;


@end
