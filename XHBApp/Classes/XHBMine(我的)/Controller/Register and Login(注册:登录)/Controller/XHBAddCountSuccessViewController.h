//
//  XHBAddCountSuccessViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBAddCountSuccessViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,strong)UIScrollView*bottomScrollView;
@property(nonatomic,strong)UILabel*label_Account;//账号
@property(nonatomic,strong)UITextField*TF_realName;//真实姓名
@property(nonatomic,strong)UITextField*TF_identifyId;//身份证号
@property(nonatomic,strong)UIButton*btn_next;//下一步或者提交按钮
@end
