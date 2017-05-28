//
//  XHBAccountSecuriySetViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/18.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAccountSecuriySetViewController.h"
#import "XHBVertyPhoneViewController.h"
#import "XHBuserIdentityInfoViewController.h"
#import "XHBChangePasswordViewController.h"
@interface XHBAccountSecuriySetViewController ()

@end

@implementation XHBAccountSecuriySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"账户安全设置";
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    [self.view_phoneNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@(WidthScale_IOS6(52)));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Click:(UIButton *)sender {
    if(sender.tag==0)
    {
        //绑定手机
        XHBVertyPhoneViewController*vertyPhoneVC=[[XHBVertyPhoneViewController alloc]init];
       // [self.navigationController pushViewController:vertyPhoneVC animated:YES];
    }
    if(sender.tag==1)
    {
        //修改登录密码
        XHBChangePasswordViewController*changeVC=[[XHBChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    if(sender.tag==2)
    {
        //真实姓名
    }
    if(sender.tag==3)
    {
        //证件信息
        XHBuserIdentityInfoViewController*infoVC=[[XHBuserIdentityInfoViewController alloc]init];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
