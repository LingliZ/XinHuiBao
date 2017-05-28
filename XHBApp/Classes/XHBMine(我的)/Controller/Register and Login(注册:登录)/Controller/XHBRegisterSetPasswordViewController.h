//
//  XHBRegisterSetPasswordViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBRegistSuccessController.h"
@interface XHBRegisterSetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF_password;
@property (weak, nonatomic) IBOutlet UIButton *btn_Register;
@property(copy,nonatomic)NSString*phoneNum;//手机号
@property(copy,nonatomic)NSString*vertyNum;//验证码
@end
