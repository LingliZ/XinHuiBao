//
//  XHBFeedBackViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBFeedBackViewController.h"

@interface XHBFeedBackViewController ()

@end

@implementation XHBFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editClick) name:UITextViewTextDidChangeNotification object:nil];
    [self createUI];
}
-(void)createUI
{
    self.title=@"意见反馈";
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    self.TV_content.delegate=self;
    [UIView setBorForView:self.btn_commite withWidth:0 andColor:nil andCorner:5];
    [self.btn_commite setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_commite setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self editClick];
}
-(void)editClick
{
    if(self.TV_content.text.length==0)
    {
        self.btn_commite.enabled=NO;
        self.label_placeholder.hidden=NO;
    }
    else
    {
        self.btn_commite.enabled=YES;
        self.label_placeholder.hidden=YES;
    }
    self.label_numbersOfContent.text=[NSString stringWithFormat:@"%ld/200",self.TV_content.text.length];
}
- (IBAction)commiteClick:(UIButton *)sender {
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"msg"]=self.TV_content.text;
    if([GXUserInfoTool isLogin])
    {
        params[@"AppSessionId"]=[GXUserInfoTool getAppSessionId];
    }
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在提交……"];
    [GXHttpTool POST:XHBUrl_FeedBack parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
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
