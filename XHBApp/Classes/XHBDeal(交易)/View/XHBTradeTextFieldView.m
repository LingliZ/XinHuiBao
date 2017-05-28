//
//  XHBTradeTextFieldView.m
//  XHBApp
//
//  Created by shenqilong on 17/3/1.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBTradeTextFieldView.h"
#import "PriceDetailTradeViewAmountButton.h"


#define buttonW 40
#define buttonS 8

@implementation XHBTradeTextFieldView
{
    PriceDetailTradeViewAmountButton *btnDown;
    PriceDetailTradeViewAmountButton *btnUp;
    
}

@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTfText:(NSString *)str y:(float)y tradeTfStyle:(tradeTfStyle)type{
    if (self = [super initWithFrame:CGRectMake(0, y, GXScreenWidth, buttonW)]) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        
        self.customTf=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, GXScreenWidth-30-2*buttonS-2*buttonW, buttonW)];
        self.customTf.font=GXFONT_PingFangSC_Regular(15);
        self.customTf.textAlignment=NSTextAlignmentCenter;
        self.customTf.textColor=GXRGBColor(0, 0, 0);
        self.customTf.backgroundColor=[UIColor whiteColor];
        self.customTf.clearButtonMode = UITextFieldViewModeNever;
        [self.customTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.customTf setBorderStyle:UITextBorderStyleNone];
        [self.customTf setKeyboardType:UIKeyboardTypeDecimalPad];
        [self.customTf setReturnKeyType:UIReturnKeyDone];
        self.customTf.delegate=(id)self;
        self.customTf.layer.borderWidth=1;
        self.customTf.layer.borderColor=GXRGBColor(232, 232, 232).CGColor;
        NSMutableAttributedString *plstr=[[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:GXRGBColor(165, 165, 165)}];
        [self.customTf setAttributedPlaceholder:plstr];
        [self addSubview:self.customTf];
        
        
        
        btnDown=[[PriceDetailTradeViewAmountButton alloc]initWithFrame:CGRectMake(self.customTf.frame.origin.x+self.customTf.frame.size.width+buttonS, 0, buttonW, buttonW) style:OrderAmountButtonStyleDown];
        [btnDown addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [btnDown addLongPressGestureRecognizer:self action:@selector(btnDown)];
        [self addSubview:btnDown];
        
        btnUp=[[PriceDetailTradeViewAmountButton alloc]initWithFrame:CGRectMake(btnDown.frame.origin.x+btnDown.frame.size.width+buttonS, 0, buttonW, buttonW) style:OrderAmountButtonStyleUp];
        [btnUp addTarget:self action:@selector(btnUp) forControlEvents:UIControlEventTouchUpInside];
        [btnUp addLongPressGestureRecognizer:self action:@selector(btnUp)];
        [self addSubview:btnUp];
        
        [btnDown setImage:[UIImage imageNamed:@"minImg_orange"] forState:UIControlStateNormal];
        [btnDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btnUp setImage:[UIImage imageNamed:@"addImg_orange"] forState:UIControlStateNormal];
        [btnUp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        

        
        if(type==1)
        {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, buttonW+10, buttonW)];
            [btn setImage:[UIImage imageNamed:@"tradeUnSelect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"tradeSelect"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(seleButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            self.cusSelectButton=btn;
            
            UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(25+buttonW, (buttonW-26)/2.0, 0.5, 26)];
            lineimg.backgroundColor=GXRGBColor(232, 232, 232);
            [self addSubview:lineimg];
            
            
            self.customTf.enabled=NO;
            btnDown.enabled=NO;
            btnUp.enabled=NO;
            
            [btnDown setImage:[UIImage imageNamed:@"minImg_gray"] forState:UIControlStateNormal];
            [btnDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [btnUp setImage:[UIImage imageNamed:@"addImg_gray"] forState:UIControlStateNormal];
            [btnUp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];


        }
        
    }
    return self;
}

-(void)btnDown
{
    if(self.tradeCode)
    {
        self.customTf.text=[NSString stringToFloat:[self.customTf.text floatValue]-0.01 Code:self.tradeCode];
    }else
        self.customTf.text=[NSString stringWithFormat:@"%.2f",[self.customTf.text floatValue]-0.01];
    
    
    if([self.customTf.text floatValue]<=0)
    {
        self.customTf.text=@"";
    }
    
    [delegate tradeTextField:self.customTf];

}

-(void)btnUp
{
    if([self.customTf.text floatValue]==0 && self.tfActivateValue)
    {
        self.customTf.text=self.tfActivateValue;
    }else
    {
        if(self.tradeCode)
        {
            self.customTf.text=[NSString stringToFloat:[self.customTf.text floatValue]+0.01 Code:self.tradeCode];
        }else
            self.customTf.text=[NSString stringWithFormat:@"%.2f",[self.customTf.text floatValue]+0.01];
    }
    
    [delegate tradeTextField:self.customTf];
}

-(void)setTfTag:(int)tfTag
{
    self.customTf.tag=tfTag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if([textField.text floatValue]<=0)
    {
        textField.text=@"";
    }
    else
    {
        if(self.tradeCode)
        {
            textField.text=[NSString stringToFloat:[textField.text floatValue] Code:self.tradeCode];
        }else
            textField.text=[NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
    }
    
    
    [delegate tradeTextField:textField];
}

-(void)seleButton:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if(sender.selected)
    {
        self.customTf.enabled=YES;
        btnDown.enabled=YES;
        btnUp.enabled=YES;
        
        self.customTf.textColor=GXRGBColor(0, 0, 0);
        
        [btnDown setImage:[UIImage imageNamed:@"minImg_orange"] forState:UIControlStateNormal];
        [btnDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btnUp setImage:[UIImage imageNamed:@"addImg_orange"] forState:UIControlStateNormal];
        [btnUp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    }else
    {
        self.customTf.enabled=NO;
        btnDown.enabled=NO;
        btnUp.enabled=NO;
        
        self.customTf.textColor=GXRGBColor(165, 165, 165);
        
        [btnDown setImage:[UIImage imageNamed:@"minImg_gray"] forState:UIControlStateNormal];
        [btnDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btnUp setImage:[UIImage imageNamed:@"addImg_gray"] forState:UIControlStateNormal];
        [btnUp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text floatValue]==0 && self.tfActivateValue)
    {
        textField.text=self.tfActivateValue;
    }
}

@end
