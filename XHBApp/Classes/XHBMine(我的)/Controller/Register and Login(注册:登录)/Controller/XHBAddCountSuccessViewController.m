//
//  XHBAddCountSuccessViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAddCountSuccessViewController.h"
#import "XHBAddCountSuccessVertifiedViewController.h"
#import "XHBUpLoadIDCardViewController.h"
@interface XHBAddCountSuccessViewController ()

@end

@implementation XHBAddCountSuccessViewController
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
    self.title=@"开户成功";
    self.bottomScrollView=[[UIScrollView alloc]init];
    self.bottomScrollView.userInteractionEnabled=YES;
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    
    UILabel*label_mark=[[UILabel alloc]init];
    label_mark.text=@"恭喜阁下，开户成功!";
    label_mark.textAlignment=NSTextAlignmentCenter;
    [self.bottomScrollView addSubview:label_mark];
    [label_mark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@30);
        make.height.mas_equalTo(@22);
        make.centerX.mas_equalTo(@0);
    }];

    UIImageView*img_mark=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_addCount_sucessMark"]];
    [self.bottomScrollView addSubview:img_mark];
    [img_mark mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@30);
        make.right.mas_equalTo(label_mark.mas_left).offset(-5);
        make.centerY.mas_equalTo(label_mark.mas_centerY).offset(0);
    }];
    
    
    UILabel*label_accountMark=[[UILabel alloc]init];
    label_accountMark.text=@"实盘账号";
    label_accountMark.textColor=[UIColor lightGrayColor];
    label_accountMark.font=[UIFont italicSystemFontOfSize:14];
    [self.bottomScrollView addSubview:label_accountMark];
    [label_accountMark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_mark.mas_bottom).offset(26);
        make.centerX.mas_equalTo(@0);
    }];
    
    self.label_Account=[[UILabel alloc]init];
    self.label_Account.text=[GXUserInfoTool getLoginAccount];
    self.label_Account.font=[UIFont systemFontOfSize:26];
    self.label_Account.textColor=[UIColor orangeColor];
    [self.bottomScrollView addSubview:self.label_Account];
    [self.label_Account mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(label_accountMark.mas_bottom).offset(2);
        make.height.mas_equalTo(@37);
        make.centerX.mas_equalTo(@0);
    }];
    
    UILabel*label_Alert=[[UILabel alloc]init];
    label_Alert.text=@"账号及密码 已发送到阁下的手机中，请注意查收！";
    label_Alert.textColor=[UIColor lightGrayColor];
    label_Alert.font=[UIFont systemFontOfSize:12];
    [self.bottomScrollView addSubview:label_Alert];
    [label_Alert mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.label_Account.mas_bottom).offset(14.4);
        make.centerX.mas_equalTo(@0);
    }];
    
    UIView*view_Alert=[[UIView alloc]init];
    view_Alert.backgroundColor=[UIColor whiteColor];
    [self.bottomScrollView addSubview:view_Alert];
    [view_Alert mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(label_Alert.mas_bottom).offset(24);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@30);
    }];
    
    
    UIView*lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor getColor:@"F2F3F3"];
    [view_Alert addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@(1));
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    
    UIImageView*img_mark_alertToVerty=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_addCount_mark_alertToVerty"]];
    [view_Alert addSubview:img_mark_alertToVerty];
    [img_mark_alertToVerty mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(@0);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
        make.left.mas_equalTo(@16);
    }];
    
    UILabel*label_alertToVerty=[[UILabel alloc]init];
    label_alertToVerty.textColor=[UIColor getColor:@"A5A5A5"];
    label_alertToVerty.text=@"为了保证您的账户安全，请进行实名认证";
    label_alertToVerty.font=[UIFont systemFontOfSize:12];
    [view_Alert addSubview:label_alertToVerty];
    [label_alertToVerty mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@40.6);
        make.centerY.mas_equalTo(@0);
    }];
    
    UILabel*label_nameMark=[[UILabel alloc]init];
    label_nameMark.text=@"真实姓名:";
    label_nameMark.font=[UIFont systemFontOfSize:14];
    [self.bottomScrollView addSubview:label_nameMark];
    [label_nameMark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view_Alert.mas_bottom).offset(22);
        make.left.mas_equalTo(@16);
    }];
    
    self.TF_realName=[[UITextField alloc]init];
    self.TF_realName.placeholder=@"填写真实姓名";
    self.TF_realName.borderStyle=UITextBorderStyleNone;
    self.TF_realName.font=[UIFont systemFontOfSize:14];
    self.TF_realName.delegate=self;
    self.TF_realName.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.bottomScrollView addSubview:self.TF_realName];
    [self.TF_realName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label_nameMark.mas_centerY).offset(0);
        make.left.mas_equalTo(label_nameMark.mas_right).offset(26);
        make.right.mas_equalTo(@(-15));
    }];
    
    UIView*view_line1=[[UIView alloc]init];
    view_line1.backgroundColor=[UIColor getColor:Color_lineView];
    [self.bottomScrollView addSubview:view_line1];
    [view_line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(self.TF_realName.mas_bottom).offset(12.5);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel*label_identityMark=[[UILabel alloc]init];
    label_identityMark.text=@"身份证号:";
    label_identityMark.font=[UIFont systemFontOfSize:14];
    [self.bottomScrollView addSubview:label_identityMark];
    [label_identityMark mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@16);
        make.top.mas_equalTo(view_line1.mas_bottom).offset(23);
    }];
    
    self.TF_identifyId=[[UITextField alloc]init];
    self.TF_identifyId.placeholder=@"填写身份证号";
    self.TF_identifyId.borderStyle=UITextBorderStyleNone;
    self.TF_identifyId.font=[UIFont systemFontOfSize:14];
    self.TF_identifyId.delegate=self;
    self.TF_identifyId.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.bottomScrollView addSubview:self.TF_identifyId];
    [self.TF_identifyId mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(label_identityMark.mas_centerY).offset(0);
        make.left.mas_equalTo(label_identityMark.mas_right).offset(26);
        make.right.mas_equalTo(@(-15));
    }];
    
    UIView*view_line2=[[UIView alloc]init];
    view_line2.backgroundColor=[UIColor getColor:Color_lineView];
    [self.bottomScrollView addSubview:view_line2];
    [view_line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.height.mas_equalTo(@1);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(self.TF_identifyId.mas_bottom).offset(12.5);
    }];
    
    self.btn_next=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_next addTarget:self action:@selector(btnClickNext:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_next.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
   // [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_Highled) forState:UIControlStateHighlighted];
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.bottomScrollView addSubview:self.btn_next];
    [self.btn_next mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@(-15));
        make.height.mas_equalTo(@50);
        make.top.mas_equalTo(view_line2.mas_bottom).offset(50);
                make.bottom.mas_equalTo(@(-GXScreenHeight+64+420+CGRectGetMaxY(self.btn_next.frame)));
    }];
    
    UIButton*btn_skip=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn_skip setTitle:@"跳过>>" forState:UIControlStateNormal];
    btn_skip.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn_skip setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn_skip addTarget:self action:@selector(btnClickSkip:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScrollView addSubview:btn_skip];
    [btn_skip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@60);
        make.bottom.mas_equalTo(@(-30));
        
    }];
    
    [self editClick];
}
-(void)editClick
{
    if(self.TF_realName.text.length==0||self.TF_identifyId.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}

#pragma mark--UITextFieldDelegate
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
#pragma mark--下一步
-(void)btnClickNext:(UIButton*)button
{
    [currentTF resignFirstResponder];
    if(![[self.TF_realName.text checkName]isEqualToString:Check_Name_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_realName.text checkName]];
        return;
    }
    if(![self.TF_identifyId.text checkName])
    {
        [self.view showFailWithTitle:@"请输入正确的身份证号码"];
        return;
    }
    
    [self vertyIdentity];
}
#pragma mark--验证用户身份
-(void)vertyIdentity
{
    [self.view showLoadingWithTitle:@"正在提交实名认证数据"];
    NSDictionary* URLParameters = @{
                                    @"idCardNum":self.TF_identifyId.text,
                                    @"realName":self.TF_realName.text,
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    };
    [GXHttpTool POST:XHBUrl_vertyUserIdentify parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [GXUserInfoTool saveUserReallyName:self.TF_realName.text];
            [self.view showSuccessWithTitle:responseObject[@"message"]];
            XHBUpLoadIDCardViewController*uploadVC=[[XHBUpLoadIDCardViewController alloc]init];
            [self.navigationController pushViewController:uploadVC animated:YES];
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
#pragma mark--跳过
-(void)btnClickSkip:(UIButton*)button
{
    if([GXUserdefult boolForKey:IsFromIndex])
    {
        [GXUserdefult setBool:NO forKey:IsFromIndex];
        GXTabBarController*tabVC=[[GXTabBarController alloc]init];
        AppDelegate* appDelagete = [UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController=tabVC;
        return ;
    }
    [GXUserdefult setBool:YES forKey:IsSkip];
    [GXUserdefult synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
