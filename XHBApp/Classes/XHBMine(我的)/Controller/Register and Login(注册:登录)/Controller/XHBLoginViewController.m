//
//  XHBLoginViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBLoginViewController.h"
#import "XHBRegisterViewController.h"
#import "XHBForgetPasswordViewController.h"
@interface XHBLoginViewController ()

@end

@implementation XHBLoginViewController
{
    UITextField*currentTF;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
   // [GXUserInfoTool loginSuccess];
    [self createUI];
}
-(void)createUI
{
    self.title=@"登录";
    [UIView setBorForView:self.btn_Next withWidth:0 andColor:nil andCorner:5];
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_Password.delegate=self;
    self.TF_Account.delegate=self;
    [self editClick];
}
-(void)editClick
{
    if(self.TF_Account.text.length==0||self.TF_Password.text.length==0)
    {
        self.btn_Next.enabled=NO;
    }
    else
    {
        self.btn_Next.enabled=YES;
    }

}
- (IBAction)btnClick_login:(UIButton *)sender {
    [currentTF resignFirstResponder];
    [self beginToLogin];
}
#pragma mark--登录
-(void)beginToLogin
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"登录中……"];
    NSDictionary* URLParameters = @{
                                    @"spnumber":self.TF_Account.text,
                                    @"password":self.TF_Password.text,
                                    };
    
    [GXHttpTool POST:XHBUrl_login parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue]==1)
        {
            GXLog(@"登录成功");
            [self.view showSuccessWithTitle:@"登录成功"];
            [GXUserInfoTool loginSuccess];
            [GXUserInfoTool saveAppSessionId:responseObject[@"value"][@"AppSessionId"]];//保存AppSessionId
            [GXUserInfoTool saveLoginAccount:responseObject[@"value"][@"SpNumber"]];//保存实盘账号
            [GXUserInfoTool savePhoneNum:responseObject[@"value"][@"Mobile"]];//保存手机号
            [GXUserInfoTool saveUserReallyName:responseObject[@"value"][@"Name"]];//保存用户真实姓名
            [GXUserInfoTool saveIdentifyStatusWithStatus:responseObject[@"value"][@"Identity_Result"]];//保存用户实名认证状态
            [GXUserInfoTool saveUserBankCardStatus:responseObject[@"value"][@"Bank_Attest_Result"]];//保存用户银行卡状态
            [GXUserInfoTool saveUserIDCardNum:responseObject[@"value"][@"IDNumber"]];//保存用户身份证号码
            [GXUserInfoTool saveUserBankName:responseObject[@"value"][@"BankName"]];//保存银行名字
            [GXUserInfoTool saveEaseMobAccount:responseObject[@"value"][@"PushAccount"] Password:responseObject[@"value"][@"PushPassword"]];//保存环信账号和密码
            [GXUserInfoTool loginOutFromEaseMob];
            [Growing setCS1Value:[NSString md5:[GXUserInfoTool getLoginAccount]] forKey:@"user_id"];
            if([GXUserdefult boolForKey:IsFromIndex])
            {
                [GXUserdefult setBool:NO forKey:IsFromIndex];
                GXTabBarController*tabVC=[[GXTabBarController alloc]init];
                AppDelegate* appDelagete = [UIApplication sharedApplication].delegate;
                appDelagete.window.rootViewController=tabVC;
                return ;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"登录请求失败，请检查网络设置"];
    }];
}
- (IBAction)btnClick:(UIButton *)sender {
    [currentTF resignFirstResponder];
    if(sender.tag==0)
    {
        XHBRegisterViewController*registerVC=[[XHBRegisterViewController alloc]init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    if(sender.tag==1)
    {
        XHBForgetPasswordViewController*forgetVC=[[XHBForgetPasswordViewController alloc]init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [currentTF resignFirstResponder];
}
#pragma mark--UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTF=textField;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
