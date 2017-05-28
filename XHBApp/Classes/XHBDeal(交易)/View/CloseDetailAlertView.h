//
//  CloseDetailAlertView.h
//  XHBApp
//
//  Created by shenqilong on 16/12/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloseDetailAlertViewDelegate <NSObject>

-(void)CloseDetailAlertViewDelegate_cancel;

-(void)CloseDetailAlertViewDelegate_orderClose;

@end

@class PositionListModel;
@interface CloseDetailAlertView : UIView

-(void)setPModel:(PositionListModel *)pModel;
@property(nonatomic,assign)id<CloseDetailAlertViewDelegate>delegate;
@end
