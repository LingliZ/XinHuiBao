//
//  XHBRealNameVertyViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//
//实名认证

#import <UIKit/UIKit.h>

@interface XHBRealNameVertyViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_BG;
@property (weak, nonatomic) IBOutlet UITextField *TF_name;
@property (weak, nonatomic) IBOutlet UITextField *TF_IDCard;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;

@end
