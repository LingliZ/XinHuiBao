//
//  XHBSettingViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBSettingViewController : XHBBaseViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_BG;
@property (weak, nonatomic) IBOutlet UIView *view_accountSecuritySet;


@property (weak, nonatomic) IBOutlet UIButton *btn_logout;
@property (weak, nonatomic) IBOutlet UILabel *label_cache;

@end
