//
//  XHB_Home_AlertToRegister.m
//  XHBApp
//
//  Created by WangLinfang on 16/12/5.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHB_Home_AlertToRegister.h"

@implementation XHB_Home_AlertToRegister

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnClick_close:(UIButton *)sender {
    [self.delegate closeView_AlertToRegister];
    self.hidden=YES;
}
- (IBAction)btnClick_register:(UIButton *)sender {
    [self.delegate goToRegist];
}

@end
