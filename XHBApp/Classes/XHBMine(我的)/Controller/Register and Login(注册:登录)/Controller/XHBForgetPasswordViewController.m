//
//  XHBForgetPasswordViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/7.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBForgetPasswordViewController.h"

@interface XHBForgetPasswordViewController ()

@end

@implementation XHBForgetPasswordViewController
{
    UITextField*currentTF;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
    [self createUI];
}
-(void)createUI
{
    self.title=@"找回密码";
    [UIView setBorForView:self.btn_Next withWidth:0 andColor:nil andCorner:5];
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_NewPassword.delegate=self;
    self.TF_VertifyNum.delegate=self;
    self.TF_Account.delegate=self;
    [self.TF_NewPassword addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingChanged];
    [self editClick];
}
-(void)editClick
{
    if(self.TF_Account.text.length==0||self.TF_VertifyNum.text.length==0||self.TF_NewPassword.text.length==0)
    {
        self.btn_Next.enabled=NO;
    }
    else
    {
        self.btn_Next.enabled=YES;
    }
}
-(void)editChange:(UITextField*)textfield
{
    if(textfield.text.length>20)
    {
        textfield.text=[textfield.text substringToIndex:20];
    }
}
- (IBAction)getVertifyBtnClick:(UIButton *)sender {
    [currentTF resignFirstResponder];
    if([UIButton checkIsLegalPhoneNum:self.TF_Account.text])
    {
        [self.btn_GetVertifyNum turnModeForSendVertyCodeWithTimeInterval:30];
        [self getVertyNum];
    }
    else
    {
        [self.view showFailWithTitle:@"请输入正确的手机号"];
    }
}
-(void)getVertyNum
{
    NSDictionary*params=@{
                          @"mobile":self.TF_Account.text,
                          };
    [GXHttpTool POST:XHBUrl_sendVertyNum_forgetPassword parameters:params success:^(id responseObject) {
        
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"重置密码验证码发送成功");
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [self.view showFailWithTitle:@"发送验证码请求失败，请检查网络状况"];
    }];
}
- (IBAction)commiteClick:(UIButton *)sender {
    if(![UIButton checkIsLegalPhoneNum:self.TF_Account.text])
    {
        [self.view showFailWithTitle:@"请输入合法的手机号"];
        return;
    }
    if(![[self.TF_NewPassword.text checkPassword]isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_NewPassword.text checkPassword]];
        return;
    }
    [self commite];
}
#pragma mark--提交更改
-(void)commite
{
    NSDictionary*params=@{
                          @"mobile":self.TF_Account.text,
                          @"valid":self.TF_VertifyNum.text,
                          @"password":self.TF_NewPassword.text,
                          };
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"新密码正在提交"];
    [GXHttpTool POST:XHBUrl_forgetPassword parameters:params success:^(id responseObject) {
        
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"密码更改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"提交失败，请检查网络状况"];
    }];
}
#pragma mark--UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTF=textField;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [currentTF resignFirstResponder];
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
