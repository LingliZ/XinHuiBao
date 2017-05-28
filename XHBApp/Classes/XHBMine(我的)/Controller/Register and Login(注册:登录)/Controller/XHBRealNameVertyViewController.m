//
//  XHBRealNameVertyViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBRealNameVertyViewController.h"
#import "XHBUpLoadIDCardViewController.h"
@interface XHBRealNameVertyViewController ()

@end

@implementation XHBRealNameVertyViewController
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
    self.title=@"实名认证";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_name.delegate=self;
    self.TF_IDCard.delegate=self;
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(CGRectGetMaxY(self.btn_next.frame)+(GXScreenHeight-667)+1-394));
    }];
    [self editClick];
}
-(void)editClick
{
    if(self.TF_IDCard.text.length==0||self.TF_name.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
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
#pragma mark--认证
- (IBAction)btnClick_Verty:(UIButton *)sender {
    [currentTF resignFirstResponder];
    if(![[self.TF_name.text checkName]isEqualToString:Check_Name_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_name.text checkName]];
        return;
    }
    if(![self.TF_IDCard.text checkIDCardNum])
    {
        [self.view showFailWithTitle:@"请输入正确的身份证号码"];
        return;
    }
    [self vertyIdentity];

}
#pragma mark--验证用户身份
-(void)vertyIdentity
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交实名认证数据"];
    NSDictionary* URLParameters = @{
                                    @"idCardNum":self.TF_IDCard.text,
                                    @"realName":self.TF_name.text,
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    };
    [GXHttpTool POST:XHBUrl_vertyUserIdentify parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [GXUserInfoTool saveUserReallyName:self.TF_name.text];
            [self.view showSuccessWithTitle:responseObject[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XHBUpLoadIDCardViewController*uploadVC=[[XHBUpLoadIDCardViewController alloc]init];
                uploadVC.vc=self;
                [self.navigationController pushViewController:uploadVC animated:YES];
            });
            
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
    }];
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
