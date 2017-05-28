//
//  XHBRegisterSetPasswordViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBRegisterSetPasswordViewController.h"
#import "XHBAddCountSuccessViewController.h"

@interface XHBRegisterSetPasswordViewController ()

@end

@implementation XHBRegisterSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
    [self createUI];
}
-(void)createUI
{
    self.title=@"注册";
    [UIView setBorForView:self.btn_Register withWidth:0 andColor:nil andCorner:5];
    [self.btn_Register setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_Register setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_password.delegate=self;
    [self editClick];
}
-(void)editClick
{
    if(self.TF_password.text.length==0)
    {
        self.btn_Register.enabled=NO;
    }
    else
    {
        self.btn_Register.enabled=YES;
    }
}
- (IBAction)btnClick_register:(UIButton *)sender {
    [self.TF_password resignFirstResponder];
    NSString*checkPassword=[self.TF_password.text checkPassword];
    if(![checkPassword isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:checkPassword];
        return;
    }
    [self registers];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.TF_password resignFirstResponder];
}
-(void)registers
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"注册数据提交中……"];
    self.btn_Register.enabled=NO;
    NSDictionary* URLParameters = @{
                                    @"mobile":self.phoneNum,
                                    @"valid":self.vertyNum,
                                    @"password":self.TF_password.text,
                                    @"channel":Regist_Channel,
                                    };
    [GXHttpTool POST:XHBUrl_register parameters:URLParameters success:^(id responseObject) {
        
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue]==1)
        {
            GXLog(@"注册成功");
            [self.view showSuccessWithTitle:@"注册成功"];
            [GXUserInfoTool loginSuccess];
            [GXUserdefult setBool:NO forKey:IsSkip];
            
            [GXUserInfoTool saveAppSessionId:responseObject[@"value"][@"AppSessionId"]];//保存AppSessionId
            [GXUserInfoTool saveLoginAccount:responseObject[@"value"][@"SpNumber"]];//保存实盘账号
            [GXUserInfoTool savePhoneNum:responseObject[@"value"][@"Mobile"]];//保存手机号
            [GXUserInfoTool saveUserReallyName:responseObject[@"value"][@"Name"]];//保存用户真实姓名
            [GXUserInfoTool saveUserIDCardNum:responseObject[@"value"][@"IDNumber"]];//保存用户身份证号码
            [GXUserInfoTool saveIdentifyStatusWithStatus:responseObject[@"value"][@"Identity_Result"]];//保存用户实名认证状态
            [GXUserInfoTool saveUserBankCardStatus:responseObject[@"value"][@"Bank_Attest_Result"]];//保存用户银行卡状态
            [GXUserInfoTool saveEaseMobAccount:responseObject[@"value"][@"PushAccount"] Password:responseObject[@"value"][@"PushPassword"]];//保存环信账号和密码
            [GXUserInfoTool loginOutFromEaseMob];
            
             [Growing setCS1Value:[NSString md5:[GXUserInfoTool getLoginAccount]] forKey:@"user_id"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.btn_Register.enabled=YES;
//                XHBAddCountSuccessViewController*addCountSucessVC=[[XHBAddCountSuccessViewController alloc]init];
                XHBRegistSuccessController*registerSuccessVC=[[XHBRegistSuccessController alloc]init];
                [self.navigationController pushViewController:registerSuccessVC animated:YES];
            });

        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
            self.btn_Register.enabled=YES;
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
        self.btn_Register.enabled=YES;
    }];
}


@end
