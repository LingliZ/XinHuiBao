//
//  XHBAddCountSuccessVertifiedViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBAddCountSuccessVertifiedViewController.h"
#import "GXTabBarController.h"
#import "GXTabbar.h"
@interface XHBAddCountSuccessVertifiedViewController ()

@end

@implementation XHBAddCountSuccessVertifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"开户成功";
    
    UIBarButtonItem*rightBtnItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_addCount_returnToHome"] style:UIBarButtonItemStylePlain target:self action:@selector(returnToHome)];
    self.label_account.text=[GXUserInfoTool getLoginAccount];
    self.navigationItem.rightBarButtonItem=rightBtnItem;
    [self.view_bg mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
}
-(void)returnToHome
{
    if([GXUserdefult boolForKey:IsFromIndex])
    {
        [GXUserdefult setBool:NO forKey:IsFromIndex];
        GXTabBarController*tabVC=[[GXTabBarController alloc]init];
        AppDelegate* appDelagete = [UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController=tabVC;
        return ;
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //观看直播
        GXTabBarController*currentTab=(GXTabBarController*)self.navigationController.tabBarController;
        [currentTab.gxTabBar setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if(sender.tag==1)
    {
        //在线入金
        XHBInOrOutGoldViewController*inOrOutVC=[[XHBInOrOutGoldViewController alloc]init];
        [self.navigationController pushViewController:inOrOutVC animated:YES];
    }
    if(sender.tag==2)
    {
        //了解行情
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *www=[UIApplication sharedApplication].keyWindow;
            GXTabBarController *tabbarc=(GXTabBarController *)www.rootViewController;
            GXTabbar *tabbar= tabbarc.gxTabBar;
            [tabbar setSelectedIndex:1];
            [tabbarc setSelectedIndex:1];
        });
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

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
