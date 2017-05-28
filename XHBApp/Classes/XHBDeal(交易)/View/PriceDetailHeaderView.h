//
//  PriceDetailHeaderView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceMarketModel;
@protocol priceDetailHeaderDelegate <NSObject>

-(void)priceDetailHeaderDelegate_buyClick;
-(void)priceDetailHeaderDelegate_sellClick;

@end
@interface PriceDetailHeaderView : UIView

-(void)setPriceDetailView:(PriceMarketModel*)marketModel;
@property(nonatomic,assign)id<priceDetailHeaderDelegate>delegate;
@end
