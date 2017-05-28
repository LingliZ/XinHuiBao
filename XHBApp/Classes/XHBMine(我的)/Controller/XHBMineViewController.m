//
//  XHBMineViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/2.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBMineViewController.h"
#import "XHBRegisterViewController.h"
#import "XHBLoginViewController.h"
#import "XHBSettingViewController.h"
#import "XHBAddCountSuccessViewController.h"
#import "XHBAddCountSuccessVertifiedViewController.h"
#import "XHBRealNameVertyViewController.h"
#import "XHBCustomCenterViewController.h"
#import "XHBHelpCenterViewController.h"
#import "GXHelpCenterViewController.h"
#import "XHBTradeRootViewController.h"
#import "XHBAccountDetailViewController.h"
#import "XHBDownloadMT4ViewController.h"
#import "XHBUserAssetViewController.h"
#import "XHBInOrOutGoldViewController.h"
#import "GXXHBNoticeListController.h"
//////
#import "XHBRegistSuccessController.h"
@interface XHBMineViewController ()

@end

@implementation XHBMineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self isLogin];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    [UIView setBorForView:self.imageView_Head withWidth:0 andColor:nil andCorner:32.5];
    [UIView setBorForView:self.label_isAuthenticate withWidth:0.8 andColor:[UIColor whiteColor] andCorner:2];
    [UIView setBorForView:self.label_AccountType withWidth:0 andColor:nil andCorner:2];
    [UIView setBorForView:self.btn_login withWidth:1 andColor:[UIColor whiteColor] andCorner:4];
    
    NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:self.label_Asset.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 1)];
    self.label_Asset.attributedText=str;
    [self.view_Login mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(GXScreenWidth));
    }];
    [self.view_Account mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(WidthScale_IOS6(52)));
    }];
    
    if(GXScreenWidth==375)
    {
        [self.view_OnlineService mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@(GXScreenHeight-CGRectGetMaxY(self.view_OnlineService.frame)+64+145+80+30-(GXScreenHeight-667)-320));
        }];
    }
    if(GXScreenWidth<375)
    {
        [self.view_OnlineService mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@(GXScreenHeight-CGRectGetMaxY(self.view_OnlineService.frame)+64+145+110-(GXScreenHeight-667)-320));
        }];
    }
    if(GXScreenWidth>375)
    {
        [self.view_OnlineService mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@(GXScreenHeight-CGRectGetMaxY(self.view_OnlineService.frame)+64+145+65+40-(GXScreenHeight-667)-320));
        }];
    }
    
}
#pragma mark--是否登录
-(void)isLogin
{
    if([GXUserInfoTool isLogin])
    {
        [self getUserInfo];
        [self getTradeAccount];
        
        self.view_Login.hidden=NO;
        self.label_Account.hidden=NO;
        self.label_AccountType.hidden=NO;
        self.label_Asset.hidden=NO;
        
        self.view_noLogin.hidden=YES;
        self.label_Account_noLogin.hidden=YES;
        self.label_Asset_noLogin.hidden=YES;
    }
    else
    {
        self.view_Login.hidden=YES;
        self.label_Account.hidden=YES;
        self.label_AccountType.hidden=YES;
        self.label_Asset.hidden=YES;
        
        self.view_noLogin.hidden=NO;
        self.label_Account_noLogin.hidden=NO;
        self.label_Asset_noLogin.hidden=NO;

    }
}
#pragma mark--获取用户基本信息
-(void)getUserInfo
{
    NSDictionary*urlParams=@{
                             @"AppSessionId":[GXUserInfoTool getAppSessionId],
                             };
    [GXHttpTool POST:XHBUrl_getUserInfo parameters:urlParams success:^(id responseObject) {
        if([responseObject[@"success"]integerValue]==1)
        {
            self.label_Name.text=responseObject[@"value"][@"Name"];
            self.label_Account.text=responseObject[@"value"][@"SpNumber"];
            self.label_AccountType.text=responseObject[@"value"][@"Account_Level"];
            [self.imageView_Head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl_mine,responseObject[@"value"][@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"mine_head"]];
            switch ([responseObject[@"value"][@"Identity_Result"]intValue]) {
                case 0:
                    self.label_isAuthenticate.text=@"未认证";
                    break;
                case 1:
                    self.label_isAuthenticate.text=@"认证中";
                    break;
                case 2:
                    self.label_isAuthenticate.text=@"已认证";
                    break;
                case 3:
                    self.label_isAuthenticate.text=@"未认证";
                    break;
                default:
                    break;
            }
            [GXUserInfoTool saveAppSessionId:responseObject[@"value"][@"AppSessionId"]];//保存AppSessionId
            [GXUserInfoTool saveLoginAccount:responseObject[@"value"][@"SpNumber"]];//保存实盘账号
            [GXUserInfoTool savePhoneNum:responseObject[@"value"][@"Mobile"]];//保存手机号
            [GXUserInfoTool saveUserReallyName:responseObject[@"value"][@"Name"]];//保存用户真实姓名
            [GXUserInfoTool saveUserIDCardNum:responseObject[@"value"][@"IDNumber"]];//保存用户身份证号码
            [GXUserInfoTool saveIdentifyStatusWithStatus:responseObject[@"value"][@"Identity_Result"]];//保存用户实名认证状态
            [GXUserInfoTool saveUserBankCardStatus:responseObject[@"value"][@"Bank_Attest_Result"]];//保存用户银行卡状态
            [GXUserInfoTool saveLoginAccountLevelWithLevel:responseObject[@"value"][@"Account_Level"]];//保存实盘账号级别
            [GXUserInfoTool saveUserBankName:responseObject[@"value"][@"BankName"]];//保存银行名字
            [GXUserInfoTool saveUserCardNumber:responseObject[@"value"][@"CardNumber"]];//保存银行卡号
            [GXUserInfoTool saveEaseMobAccount:responseObject[@"value"][@"PushAccount"] Password:responseObject[@"value"][@"PushPassword"]];//保存环信账号和密码
        }
        
    } failure:^(NSError *error) {
        
       // [self getUserInfo];
    }];
}
#pragma mark--获取用户资产数目
-(void)getTradeAccount
{
    NSDictionary*urlParams=@{
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    };
    [GXHttpTool Get:XHBUrl_tradeAccount parameters:urlParams success:^(id responseObject) {
        if([responseObject[@"success"]integerValue]==1)
        {
            NSArray*arr_value=(NSArray*)responseObject[@"value"];
            if(arr_value.count)
            {
                NSDictionary*dic=arr_value[0];
                self.label_Asset.text=[NSString stringWithFormat:@"$ %.2f",[dic[@"equity"]floatValue]];
            }
            else
            {
                self.label_Asset.text=@"$ 0.0";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:self.label_Asset.text];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 1)];
                self.label_Asset.attributedText=str;
            });
        }
        
    } failure:^(NSError *error) {
       // [self getTradeAccount];
    }];
}
#pragma mark--跳转到个人中心
- (IBAction)btnClick_turnToCustomCenter:(UIButton *)sender {
    
    XHBCustomCenterViewController*customInfoVC=[[XHBCustomCenterViewController alloc]init];
    [self.navigationController pushViewController:customInfoVC animated:YES];
}
- (IBAction)btnClick_Login:(UIButton *)sender {
    XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
    [self.navigationController pushViewController:logVC animated:YES];
}
- (IBAction)setClick:(UIButton *)sender {
    XHBSettingViewController*setVC=[[XHBSettingViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    
    if(sender.tag==0)
    {
//        XHBRegistSuccessController*successVC=[[XHBRegistSuccessController alloc]init];
//        [self.navigationController pushViewController:successVC animated:YES];
//        return;
        //实盘账号
        XHBAccountDetailViewController*detailVC=[[XHBAccountDetailViewController alloc]init];
        detailVC.account=[GXUserInfoTool getLoginAccount];
        detailVC.acconutLevel=[GXUserInfoTool getLoginAccountLevel];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    if(sender.tag==1)
    {
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            return;
        }
        //持仓
        XHBTradeRootViewController *pos=[[XHBTradeRootViewController alloc]init];
        pos.twobarIndex=2;
        [self.navigationController pushViewController:pos animated:YES];
    }
    if(sender.tag==2)
    {
        //资产行情
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            return;
        }
        XHBUserAssetViewController*assetVC=[[XHBUserAssetViewController alloc]init];
        [self.navigationController pushViewController:assetVC animated:YES];
    }
    if(sender.tag==3)
    {
        //帮助中心
        XHBHelpCenterViewController*helpVC=[[XHBHelpCenterViewController alloc]init];
        GXHelpCenterViewController*gxhelpVC=[[GXHelpCenterViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    if(sender.tag==4)
    {
        //系统设置
        XHBSettingViewController*setVC=[[XHBSettingViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];

    }
    if(sender.tag==5)
    {
        //MT4下载
        XHBDownloadMT4ViewController*downloadVC=[[XHBDownloadMT4ViewController alloc]init];
        [self.navigationController pushViewController:downloadVC animated:YES];
    }
    if(sender.tag==6)
    {
        //个人资料
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            return;
        }
        XHBCustomCenterViewController*centerVC=[[XHBCustomCenterViewController alloc]init];
        [self.navigationController pushViewController:centerVC animated:YES];
   
    }
    if(sender.tag==7)
    {
        //资金存取
        if(![GXUserInfoTool isLogin])
        {
            XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            return;
        }
        
        XHBInOrOutGoldViewController*downloadVC=[[XHBInOrOutGoldViewController alloc]init];
        [self.navigationController pushViewController:downloadVC animated:YES];
    }
    if(sender.tag==8)
    {
        //最新公告
        GXXHBNoticeListController*downloadVC=[[GXXHBNoticeListController alloc]init];
        [self.navigationController pushViewController:downloadVC animated:YES];
    }

}

@end
