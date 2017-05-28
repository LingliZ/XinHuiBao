//
//  XHBInteractionView.m
//  XHBApp
//
//  Created by zhudong on 2016/11/22.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBInteractionView.h"
#import "XHBLiveCastViewController.h"
#import "XHBCommonSize.h"

#define LeftWidth 28
#define TriHeight 8
#define LineWidth 2
@interface XHBInteractionView ()

@end

@implementation XHBInteractionView

- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, kBtnViewHeight)];
    [path addLineToPoint:CGPointMake(kMargin + LeftWidth, kBtnViewHeight)];
    [path addLineToPoint:CGPointMake(kMargin + LeftWidth + TriHeight, kBtnViewHeight - TriHeight)];
    [path addLineToPoint:CGPointMake(kMargin + LeftWidth + TriHeight + TriHeight, kBtnViewHeight)];
    [path addLineToPoint:CGPointMake(kScreenSize.width, kBtnViewHeight)];
    
    [path setLineWidth:LineWidth];
    [[UIColor orangeColor] setStroke];
    [path stroke];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI{
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"互动交流";
    titleL.textColor = [UIColor orangeColor];
    
    UILabel *countL = [[UILabel alloc] init];
    countL.textColor = [UIColor darkGrayColor];
    self.countLable = countL;
    [self addSubview:titleL];
    [self addSubview:countL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(kMargin);
    }];
    [countL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL.mas_right).offset(5);
        make.top.bottom.equalTo(self);
    }];

}
@end
