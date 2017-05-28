//
//  XHBLoginViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XHBLoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_Next;//下一步或者提交按钮
@property (weak, nonatomic) IBOutlet UITextField *TF_Account;//登录账号
@property (weak, nonatomic) IBOutlet UITextField *TF_Password;//登录密码
@end
