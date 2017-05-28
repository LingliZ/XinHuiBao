//
//  XHBRegisterInputVertifyNumViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/10.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBRegisterInputVertifyNumViewController.h"
#import "XHBRegisterSetPasswordViewController.h"

@interface XHBRegisterInputVertifyNumViewController ()

@end

@implementation XHBRegisterInputVertifyNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
    [self createUI];
}
-(void)editClick
{
    if(self.TF_vertyNum.text.length==0)
    {
        self.btn_CommiteVertyNum.enabled=NO;
    }
    else
    {
        self.btn_CommiteVertyNum.enabled=YES;
    }
}
-(void)createUI
{
    self.title=@"注册";
    self.TF_vertyNum.delegate=self;
    [UIView setBorForView:self.btn_CommiteVertyNum withWidth:0 andColor:nil andCorner:5];
    [self.btn_CommiteVertyNum setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_CommiteVertyNum setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_GetVertyNum turnModeForSendVertyCodeWithTimeInterval:30];
    [self editClick];
    //[self getVertyNum];
}
-(void)getVertyNum
{
    [self.view showLoadingWithTitle:@"正在获取验证码"];
    [self.btn_GetVertyNum turnModeForSendVertyCodeWithTimeInterval:30];
    NSDictionary* URLParameters = @{
                                    @"mobile":self.phoneNum,
                                    };
    [GXHttpTool POST:XHBUrl_sendVertyNum parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==0)
        {
            GXLog(@"验证码发送成功");
        }
        else
        {
            [self.view showSuccessWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        
    }];
}
#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.TF_vertyNum resignFirstResponder];
}
- (IBAction)btnClick_getVertyNum:(UIButton *)sender {
    [self.TF_vertyNum resignFirstResponder];
    [self getVertyNum];
}
- (IBAction)btnClick_commiteVertyNum:(UIButton *)sender {
    [self.TF_vertyNum resignFirstResponder];
    [self vertyVertyNum];
}
-(void)vertyVertyNum
{
    [self.view showLoadingWithTitle:@"正在验证验证码"];
    NSDictionary* URLParameters = @{
                                    @"mobile":self.phoneNum,
                                    @"valid":self.TF_vertyNum.text,
                                    };
    [GXHttpTool POST:XHBUrl_vertyVertyNum parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"验证码正确");
            XHBRegisterSetPasswordViewController*setPasswordVC=[[XHBRegisterSetPasswordViewController alloc]init];
            setPasswordVC.phoneNum=self.phoneNum;
            setPasswordVC.vertyNum=self.TF_vertyNum.text;
            [self.navigationController pushViewController:setPasswordVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        
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
