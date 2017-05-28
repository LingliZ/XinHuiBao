//
//  XHBChangePasswordViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBChangePasswordViewController.h"
#import "XHBForgetPasswordViewController.h"
@interface XHBChangePasswordViewController ()

@end

@implementation XHBChangePasswordViewController
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
    self.title=@"修改密码";
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    [UIView setBorForView:self.btn_confirmChange withWidth:0 andColor:nil andCorner:5];
    [self.btn_confirmChange setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_confirmChange setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_oldPassword.delegate=self;
    self.TF_newPassword.delegate=self;
    self.TF_confirmPassword.delegate=self;
    [self editClick];
}
-(void)editClick
{
    if(self.TF_oldPassword.text.length==0||self.TF_newPassword.text.length==0||self.TF_confirmPassword.text.length==0)
    {
        self.btn_confirmChange.enabled=NO;
    }
    else
    {
        self.btn_confirmChange.enabled=YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTF=textField;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [currentTF resignFirstResponder];
}
- (IBAction)btnClick_forgetPassword:(UIButton *)sender {
    [currentTF resignFirstResponder];
    XHBForgetPasswordViewController*forgetVC=[[XHBForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)btnClick_confirmChange:(UIButton *)sender {
    [currentTF resignFirstResponder];
    if(![[self.TF_newPassword.text checkPassword]isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_newPassword.text checkPassword]];
        return;
    }
    if(![self.TF_newPassword.text isEqualToString:self.TF_confirmPassword.text])
    {
        [self.view showFailWithTitle:@"确认密码与新密码不一致"];
        return;
    }
    [self updatePasswords];
}
#pragma mark--更新密码
-(void)updatePasswords
{
    NSDictionary*params=@{
                          @"AppSessionId":[GXUserInfoTool getAppSessionId],
                          @"oldpassword":self.TF_oldPassword.text,
                          @"newpassword":self.TF_confirmPassword.text,
                          };
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在更新密码"];
    [GXHttpTool POST:XHBUrl_changePassword parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"密码更新成功");
            [self.view showSuccessWithTitle:@"密码更新成功"];
            [GXUserInfoTool loginOut];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@""];
        
    }];
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
