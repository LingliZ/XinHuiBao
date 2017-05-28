//
//  XHBuserIdentityInfoViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBuserIdentityInfoViewController.h"

@interface XHBuserIdentityInfoViewController ()

@end

@implementation XHBuserIdentityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"实名认证";
    NSMutableString*name=[[NSMutableString alloc]initWithString:[GXUserInfoTool getUserReallyName]];
    NSMutableString*idCardNum=[[NSMutableString alloc]initWithString:[GXUserInfoTool getIDCardNum]];
    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    [idCardNum replaceCharactersInRange:NSMakeRange(4, idCardNum.length-8) withString:@"**** **** ****"];
    self.label_Name.text=name;
    self.label_idCardNum.text=idCardNum;
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
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
