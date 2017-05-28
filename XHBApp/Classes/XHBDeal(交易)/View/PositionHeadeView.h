//
//  PositionHeadeView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHBTraderUserMaginModel;

@protocol PositionHeadeViewDelegate <NSObject>

-(void)positionHeaViewClick;
-(void)positionHeaViewInGold;
//问号
-(void)positionHeaViewQuestion;

@end
@interface PositionHeadeView : UIView

-(void)setUserTradeDetailModel:(XHBTraderUserMaginModel*)Model;

@property (nonatomic,strong) XHBTraderUserMaginModel*marginModel;

@property (nonatomic,strong)id <PositionHeadeViewDelegate>delegate;

@property (nonatomic,strong)UILabel *lb_titTableview;

@end
