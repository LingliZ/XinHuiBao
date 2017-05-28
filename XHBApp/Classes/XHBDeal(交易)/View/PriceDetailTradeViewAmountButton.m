//
//  PriceDetailTradeViewAmountButton.m
//  XHBApp
//
//  Created by shenqilong on 16/12/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceDetailTradeViewAmountButton.h"

@implementation PriceDetailTradeViewAmountButton
{
    id tradeViewTarget;
    SEL tradeViewAction;
    NSInteger buttonStyle;
    NSTimer *timer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(OrderAmountButtonStyle)style {
    
    if (self = [super initWithFrame:frame]) {
        
        buttonStyle=style;
        
        if(style==0)
        {
            [self setImage:[UIImage imageNamed:@"tradeContract_plus"] forState:UIControlStateNormal];
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }else
        {
            [self setImage:[UIImage imageNamed:@"tradeContract_min"] forState:UIControlStateNormal];
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
    }
    return self;
}


- (void)addLongPressGestureRecognizer:(id)target action:(SEL)action
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btn_contract_long:)];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];

    tradeViewTarget=target;
    tradeViewAction=action;
}

-(void)btn_contract_long:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if(timer)
        {
            [timer invalidate];
            timer=nil;
        }
        timer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:tradeViewTarget selector:tradeViewAction userInfo:nil repeats:YES];
        
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        if(timer)
        {
            [timer invalidate];
            timer=nil;
        }
    }
}

-(void)dealloc
{
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
}


@end
