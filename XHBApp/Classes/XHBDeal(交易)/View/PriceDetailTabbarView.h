//
//  PriceDetailTabbarView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceDetailTabbarViewDelegate <NSObject>

-(void)PriceDetailTabbarBtnClick:(NSInteger)barTouchIndex;

@end

@interface PriceDetailTabbarView : UIView

@property (nonatomic, assign)id <PriceDetailTabbarViewDelegate> delegate;

@end
