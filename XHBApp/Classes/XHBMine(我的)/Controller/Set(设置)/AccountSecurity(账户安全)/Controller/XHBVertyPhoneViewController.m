//
//  XHBVertyPhoneViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/18.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBVertyPhoneViewController.h"

@interface XHBVertyPhoneViewController ()

@end

@implementation XHBVertyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"绑定手机";
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
