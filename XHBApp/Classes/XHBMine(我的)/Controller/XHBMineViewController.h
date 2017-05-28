//
//  XHBMineViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBMineViewController : XHBBaseViewController
@property (weak, nonatomic) IBOutlet UIView *view_Login;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Head;//头像
@property (weak, nonatomic) IBOutlet UILabel *label_Name;//用户名
@property (weak, nonatomic) IBOutlet UILabel *label_isAuthenticate;//是否已认证
@property (weak, nonatomic) IBOutlet UIView *view_Account;//实盘账号
@property (weak, nonatomic) IBOutlet UIView *view_OnlineService;//在线客服
@property (weak, nonatomic) IBOutlet UILabel *label_AccountType;//账户类型
@property (weak, nonatomic) IBOutlet UILabel *label_Asset;//资产
@property (weak, nonatomic) IBOutlet UIView *view_noLogin;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;//登录
@property (weak, nonatomic) IBOutlet UILabel *label_Account;//实盘账号
@property (weak, nonatomic) IBOutlet UILabel *label_Account_noLogin;
@property (weak, nonatomic) IBOutlet UILabel *label_Asset_noLogin;



@end
