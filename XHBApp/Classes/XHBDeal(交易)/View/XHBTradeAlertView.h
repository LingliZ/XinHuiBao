//
//  CloseDetailAlertView.h
//  XHBApp
//
//  Created by shenqilong on 16/12/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHBTradeAlertViewDelegate <NSObject>

-(void)XHBTradeAlertViewDelegate_done;

@end

@interface XHBTradeAlertView : UIView

- (instancetype)initWithTitle:(NSString *)str leftText:(NSArray *)textAr ;
-(void)setOrderCloseButtonText:(NSString *)btnStr backgroundColor:(UIColor *)color;
-(void)setAlerRightData:(NSArray *)dataAr;


@property(nonatomic,assign)id<XHBTradeAlertViewDelegate>delegate;
@end
