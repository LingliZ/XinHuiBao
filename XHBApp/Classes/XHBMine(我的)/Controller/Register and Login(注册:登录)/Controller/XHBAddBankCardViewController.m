//
//  XHBAddBankCardViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAddBankCardViewController.h"
#import "XHBUploadBankCardViewController.h"
@interface XHBAddBankCardViewController ()

@end

@implementation XHBAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
    [self createUI];
}
-(void)createUI
{
    self.title=@"添加银行卡";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_bankCardNum.delegate=self;
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    [self editClick];
}
-(void)editClick
{
    if(self.TF_bankCardNum.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
    if(self.TF_bankCardNum.text.length>30)
    {
        self.TF_bankCardNum.text=[self.TF_bankCardNum.text substringToIndex:30];
    }
}
#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.TF_bankCardNum resignFirstResponder];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    
    [self.TF_bankCardNum resignFirstResponder];
    
    if(self.TF_bankCardNum.text.length<15||self.TF_bankCardNum.text.length>30)
    {
        [self.view showFailWithTitle:@"请输入合法的银行卡号"];
        return;
    }
    [self addBankCard];
   
}
-(void)addBankCard
{
    NSDictionary* URLParameters = @{
                                    @"bankCardNum":self.TF_bankCardNum.text,
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    };
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在添加银行卡"];
    [GXHttpTool POST:XHBUrl_vertyUserIdentify parameters:URLParameters success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                XHBUploadBankCardViewController*uploadBankVC=[[XHBUploadBankCardViewController alloc]init];
                uploadBankVC.responseObject=responseObject;
                uploadBankVC.bankCardNum=self.TF_bankCardNum.text;
                 uploadBankVC.vc=self;
                [self.navigationController pushViewController:uploadBankVC animated:YES];
                
                [self.vc removeFromParentViewController];
                self.vc=nil;
            });
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
