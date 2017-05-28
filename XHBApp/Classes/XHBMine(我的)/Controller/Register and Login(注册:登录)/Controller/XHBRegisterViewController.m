//
//  XHBRegisterViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/4.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBRegisterViewController.h"
#import "XHBRegisterInputVertifyNumViewController.h"
#import "XHBAgreementViewController.h"
@interface XHBRegisterViewController ()

@end

@implementation XHBRegisterViewController
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
    self.title=@"注册";
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_Next setBackgroundImage:ImageFromHex(Color_btn_next_enabled)forState:UIControlStateDisabled];
    //FB631A
    NSMutableAttributedString*str1=[[NSMutableAttributedString alloc]initWithString:self.label_agreement.text];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor getColor:@"FB631A"] range:NSMakeRange(3, 8)];
    NSMutableAttributedString*str2=[[NSMutableAttributedString alloc]initWithAttributedString:str1];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor getColor:@"FB631A"] range:NSMakeRange(13, 6)];
    NSMutableAttributedString*str3=[[NSMutableAttributedString alloc]initWithAttributedString:str2];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor getColor:@"FB631A"] range:NSMakeRange(21, 4)];
    self.label_agreement.attributedText=str3;
    
    self.TF_PhoneNum.delegate=self;
    [self editClick];
    [UIView setBorForView:self.btn_Next withWidth:0 andColor:nil andCorner:5];
}
-(void)editClick
{
    if(self.TF_PhoneNum.text.length)
    {
        self.btn_Next.enabled=YES;
    }
    else
    {
        self.btn_Next.enabled=NO;
    }
    if(self.TF_PhoneNum.text.length>11)
    {
        self.TF_PhoneNum.text=[self.TF_PhoneNum.text substringToIndex:11];
    }
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
- (IBAction)btnClick_Next:(id)sender {
    [currentTF resignFirstResponder];
    if(![UIButton checkIsLegalPhoneNum:self.TF_PhoneNum.text])
    {
        [self.view showFailWithTitle:@"请输入合法的手机号"];
        return;
    }
    [self getVertyNum];

    
}
#pragma mark--获取验证码
-(void)getVertyNum
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在获取验证码"];
    NSDictionary* URLParameters = @{
                                    @"mobile":self.TF_PhoneNum.text,
                                    };
    [GXHttpTool POST:XHBUrl_sendVertyNum parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"验证码发送成功");
            XHBRegisterInputVertifyNumViewController*vertifyNumVC=[[XHBRegisterInputVertifyNumViewController alloc]init];
            vertifyNumVC.phoneNum=self.TF_PhoneNum.text;
            [self.navigationController pushViewController:vertifyNumVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络状况"];
    }];
}
#pragma mark--协议
- (IBAction)btnClick_agreeMent:(UIButton *)sender {
    XHBAgreementViewController*agreeVC=[[XHBAgreementViewController alloc]init];
    if(sender.tag==0)
    {
        //贵金属客户协议书
        agreeVC.urlStr=@"http://www.91pme.com/zhuanti/app/protocol/customer_agreement.html";
    }
    if(sender.tag==1)
    {
        //风险披露声明
        agreeVC.urlStr=@"http://www.91pme.com/zhuanti/app/protocol/risk_statement.html";
    }
    if(sender.tag==2)
    {
        //免责声明
        agreeVC.urlStr=@"http://www.91pme.com/zhuanti/app/protocol/disclaimer.html";
    }
    [self.navigationController pushViewController:agreeVC animated:YES];
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
