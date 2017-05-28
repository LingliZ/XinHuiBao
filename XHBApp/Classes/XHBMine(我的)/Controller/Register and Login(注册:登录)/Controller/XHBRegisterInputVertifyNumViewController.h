//
//  XHBRegisterInputVertifyNumViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBRegisterInputVertifyNumViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF_vertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_CommiteVertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_GetVertyNum;
@property(nonatomic,copy)NSString*phoneNum;
@end
