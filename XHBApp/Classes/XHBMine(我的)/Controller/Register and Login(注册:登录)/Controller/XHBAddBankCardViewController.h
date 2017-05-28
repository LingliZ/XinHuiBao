//
//  XHBAddBankCardViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//
//添加银行卡
#import <UIKit/UIKit.h>

@interface XHBAddBankCardViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF_bankCardNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (weak, nonatomic) IBOutlet UIView *view_BG;


@property(nonatomic,strong)UIViewController *vc;

@end
