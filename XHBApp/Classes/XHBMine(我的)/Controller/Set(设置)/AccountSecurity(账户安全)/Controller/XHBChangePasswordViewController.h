//
//  XHBChangePasswordViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBChangePasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_BG;

@property (weak, nonatomic) IBOutlet UITextField *TF_oldPassword;

@property (weak, nonatomic) IBOutlet UITextField *TF_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *TF_confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirmChange;

@end
