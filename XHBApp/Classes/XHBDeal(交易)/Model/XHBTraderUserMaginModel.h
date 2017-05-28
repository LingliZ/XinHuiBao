//
//  XHBTraderUserMaginModel.h
//  XHBApp
//
//  Created by shenqilong on 17/3/6.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBTraderUserMaginModel : NSObject
@property(nonatomic,copy) NSString *balance;
@property(nonatomic,copy) NSString *credit;
@property(nonatomic,copy) NSString *currency;
@property(nonatomic,copy) NSString *equity;
@property(nonatomic,copy) NSString *group;
@property(nonatomic,copy) NSString *interestrate;
@property(nonatomic,copy) NSString *leverage;
@property(nonatomic,copy) NSString *login;
@property(nonatomic,copy) NSString *margin;
@property(nonatomic,copy) NSString *marginFree;
@property(nonatomic,copy) NSString *marginLevel;
@property(nonatomic,copy) NSString *marginLevel_str;
@property(nonatomic,copy) NSString *modifyTime;
@property(nonatomic,copy) NSString *prevbalance;
@property(nonatomic,copy) NSString *prevmonthbalance;
@property(nonatomic,copy) NSString *taxes;
@property(nonatomic,copy) NSString *FL;
@property(nonatomic,copy) NSString *limitOrderCount;



@property(nonatomic,copy) NSMutableAttributedString *userFreeMargin_att;
@property(nonatomic,copy) NSMutableAttributedString *userEquity_att;
@property(nonatomic,copy) NSMutableAttributedString *userFL_att;

@property(nonatomic,copy) NSMutableAttributedString *userEquity_att_smallFont;


@end
