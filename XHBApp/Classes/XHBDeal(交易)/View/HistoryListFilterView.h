//
//  HistoryListFilterView.h
//  XHBApp
//
//  Created by shenqilong on 16/12/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryListFilterViewDelegate <NSObject>

-(void)HistoryListFilterViewDelegate_tit:(NSString *)tit startTime:(NSString *)sTime endTime:(NSString *)eTime ;

@end

@interface HistoryListFilterView : UIView

@property (nonatomic,assign)id<HistoryListFilterViewDelegate>delegate;

-(void)setSelectTimeViewShow;

@end
