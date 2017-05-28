//
//  PriceDetailKSelectBarView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSelectBarViewDelegate <NSObject>

-(void)PriceDetailSelectKBarViewDelegate:(NSInteger)deleIndex barTit:(NSString *)tit httpPostInd:(NSString *)ind;

@end

@interface PriceDetailKSelectBarView : UIView

@property (nonatomic, assign)id <KSelectBarViewDelegate> delegate;

//目前是用于打开更多周期视图后未关闭执行关闭
-(void)KSelectBarViewCloseMorebar;

@end
