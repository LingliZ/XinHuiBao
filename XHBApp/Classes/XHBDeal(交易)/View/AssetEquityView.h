//
//  AssetEquityView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBTraderUserMaginModel.h"

@interface AssetEquityView : UIView

-(void)setUserMargin:(XHBTraderUserMaginModel *)model;
@property(nonatomic,strong)XHBTraderUserMaginModel *usrModel;

-(void)cancelTimer;

@end
