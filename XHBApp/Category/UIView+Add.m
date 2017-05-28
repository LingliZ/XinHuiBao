//
//  UIView+Add.m
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIView+Add.h"


@implementation UIView (Add)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)maxX
{
    return self.x+self.width;
}
-(CGFloat)maxY
{
    return self.y+self.height;
}
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
        
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width , width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

- (void)setBorderWithViewBottom:(UIView *)view  borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width * 0.5, width);
    layer.backgroundColor = color.CGColor;
    [view.layer addSublayer:layer];
 
}


+(void)setBorForView:(UIView*)view withWidth:(CGFloat)width andColor:(UIColor*)color andCorner:(CGFloat)corner {
    view.layer.masksToBounds=YES;
    if(width)
    {
        view.layer.borderWidth=width;
    }
    if(color)
    {
        view.layer.borderColor=color.CGColor;
        
    }
    if(corner)
    {
        view.layer.cornerRadius=corner;
    }
}

-(void)addNOWifiViewWithFrame:(CGRect)frame refreshTarget:(id)target refreshButton:(SEL)refreshButtonClick
{
    UIView *vv=[self viewWithTag:20161211];
    if(vv)
    {
        return;
    }
    UIView *backgv=[[UIView alloc]initWithFrame:frame];
    backgv.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
    backgv.tag=20161211;
    [self addSubview:backgv];
    
    UIView *imgview=[[UIView alloc]init];
    [backgv addSubview:imgview];
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-180)/2.0, 0, 180, 120)];
    img.image=[UIImage imageNamed:@"NOWifi_pic"];
    [imgview addSubview:img];
    
    UILabel *lb1=[[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.origin.y+img.frame.size.height+10, GXScreenWidth, 25)];
    lb1.textColor=GXBlack_priceNameColor;
    lb1.textAlignment=NSTextAlignmentCenter;
    lb1.font=GXFONT_PingFangSC_Regular(18);
    lb1.text=@"网络无法连接！";
    [imgview addSubview:lb1];
    
    UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(0, lb1.frame.origin.y+lb1.frame.size.height+7, GXScreenWidth, 25)];
    lb2.textColor=GXGray_priceTitleColor;
    lb2.textAlignment=NSTextAlignmentCenter;
    lb2.font=GXFONT_PingFangSC_Regular(16);
    lb2.text=@"世界上最遥远的距离莫过于此";
    [imgview addSubview:lb2];
    
    
    UIButton *rebutton=[[UIButton alloc]initWithFrame:CGRectMake((frame.size.width-70)/2.0, lb2.frame.origin.y+lb2.frame.size.height, 70, 70)];
    [rebutton setTitleColor:GXMainColor forState:UIControlStateNormal];
    rebutton.titleLabel.font=GXFONT_PingFangSC_Regular(16);
    [rebutton setTitle:@"刷新" forState:UIControlStateNormal];
    [imgview addSubview:rebutton];
    rebutton.backgroundColor=[UIColor clearColor];
    
    if([target respondsToSelector:refreshButtonClick])
    [rebutton addTarget:target action:refreshButtonClick forControlEvents:UIControlEventTouchUpInside];
    
    
    imgview.bounds=CGRectMake(0, 0, frame.size.width, rebutton.frame.size.height+rebutton.frame.origin.y);
    imgview.center=backgv.center;
}

-(void)removeNOWifiView
{
    UIView *vv=[self viewWithTag:20161211];
    [vv removeFromSuperview];
    vv=nil;
}


@end
