//
//  XHBRegistSuccessController.h
//  XHBApp
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBBaseViewController.h"
#import "XHBInGoldViewController.h"
@interface XHBRegistSuccessController : XHBBaseViewController


@property (weak, nonatomic) IBOutlet UIView *view_accountInfo;
@property (weak, nonatomic) IBOutlet UILabel *label_account;//账号
@property (weak, nonatomic) IBOutlet UIButton *btn_copyAccount;//拷贝账户
@property (weak, nonatomic) IBOutlet UIButton *btn_inGold;//入金
@property (weak, nonatomic) IBOutlet UIButton *btn_vertyIdentity;//实名认证

@end
