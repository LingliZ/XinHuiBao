//
//  GXXHBHomeFourBtnCell.h
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXXHBHomeFourBtn.h"



@interface GXXHBHomeFourBtnCell : UITableViewCell
//Btn点击回调
@property (nonatomic,copy)void (^btnClick)(NSInteger btn);

@property (nonatomic,strong)UIButton *aboutUsBtn;
@property (nonatomic,strong)UIButton *safeguardBtn;
@property (nonatomic,strong)UIButton *specialOfferBtn;
@property (nonatomic,strong)UIButton *tradeRulesBtn;
@property (nonatomic,strong)GXXHBHomeFourBtn *fourBtn;


@end
