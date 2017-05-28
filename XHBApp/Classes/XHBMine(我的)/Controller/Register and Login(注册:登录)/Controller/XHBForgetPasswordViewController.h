//
//  XHBForgetPasswordViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/7.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBForgetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_Next;//下一步或者提交按钮
@property (weak, nonatomic) IBOutlet UITextField *TF_Account;//账号
@property (weak, nonatomic) IBOutlet UITextField *TF_VertifyNum;//验证码
@property (weak, nonatomic) IBOutlet UITextField *TF_NewPassword;//新登录密码
@property (weak, nonatomic) IBOutlet UIButton *btn_GetVertifyNum;//获取验证码

@end
