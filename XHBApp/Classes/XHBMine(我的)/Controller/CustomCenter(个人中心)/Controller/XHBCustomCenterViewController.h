//
//  XHBCustomCenterViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/16.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBCustomCenterViewController : XHBBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_BG;
@property (weak, nonatomic) IBOutlet UIView *view_NickName;

@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *label_nickName;

@property (weak, nonatomic) IBOutlet UILabel *label_accountType;//账户类别
@property (weak, nonatomic) IBOutlet UILabel *label_account;//账户
@property (weak, nonatomic) IBOutlet UILabel *label_name;//真实姓名
@property (weak, nonatomic) IBOutlet UILabel *label_phoneNum;//手机号
@property (weak, nonatomic) IBOutlet UILabel *label_bankCard;//银行卡
@property (weak, nonatomic) IBOutlet UIImageView *img_next_realName;
@property (weak, nonatomic) IBOutlet UIImageView *img_next_bankNum;




@end
