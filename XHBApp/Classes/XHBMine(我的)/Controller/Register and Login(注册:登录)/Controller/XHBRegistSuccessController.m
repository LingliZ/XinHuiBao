//
//  XHBRegistSuccessController.m
//  XHBApp
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBRegistSuccessController.h"

@interface XHBRegistSuccessController ()

@end

@implementation XHBRegistSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"注册";
    [self setNaviagtionBar];
    [UIView setBorForView:self.view_accountInfo withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_inGold withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_vertyIdentity withWidth:0 andColor:nil andCorner:5];
    NSMutableAttributedString*attributeStr=[[NSMutableAttributedString alloc]initWithString:self.btn_copyAccount.titleLabel.text];
    NSRange range=NSMakeRange(0, attributeStr.length);
    [attributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [self.btn_copyAccount setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
    self.label_account.text=[GXUserInfoTool getLoginAccount];
}
-(void)setNaviagtionBar
{
    UIButton*btn_back=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back addTarget:self action:@selector(btnClick_back) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [btn_back sizeToFit];
    UIBarButtonItem*item_back=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    self.navigationItem.leftBarButtonItem=item_back;
}
-(void)btnClick_back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark--复制账号
- (IBAction)btnClick_copyAccount:(UIButton *)sender {
    [self.view showSuccessWithTitle:@"账号复制成功"];
    UIPasteboard*pastedBoard=[UIPasteboard generalPasteboard];
    pastedBoard.string=self.label_account.text;
}
#pragma mark--开始入金
- (IBAction)btnClick_inGold:(UIButton *)sender {
    //跳转到入金界面
    XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
    ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
    ingold.homeTit=@"入金";
    [self.navigationController pushViewController:ingold animated:YES];
}
#pragma mark--实名认证
- (IBAction)btnClick_vertyIdentity:(UIButton *)sender {
     [GXUserInfoTool turnAboutVertyNameForViewController:self];
    
}
#pragma mark--随便看看
- (IBAction)btnClick_skip:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
