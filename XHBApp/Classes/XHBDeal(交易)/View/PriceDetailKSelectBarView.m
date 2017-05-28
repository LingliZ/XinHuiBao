//
//  PriceDetailKSelectBarView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "PriceDetailKSelectBarView.h"
#import "XHBDealConst.h"


#define tag_priceDetailKBarV_barbutton 201611090020

@implementation PriceDetailKSelectBarView
{
    UIImageView *selectLineImg;
    
    UIButton *otherSelectImgBackgBtn;
    
    UIView *otherKselectView;
    
    NSArray *titAr;
    
    NSArray *titArMore;
}
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        titAr=@[@[@"分时",@"1"],@[@"15分",@"15"],@[@"1小时",@"60"],@[@"4小时",@"240"],@[@"日K",@"1440"],@[@"其他",@""]];
        titArMore=@[@[@"5分",@"5"],@[@"30分",@"30"],@[@"周K",@"week"],@[@"月K",@"month"]];
        
        
        float btn_width=(GXScreenWidth-10-40)*1.00/[titAr count];
        
        for (int i=0; i<[titAr count]; i++) {
            UIButton *bb=[[UIButton alloc]initWithFrame:CGRectMake(10+btn_width*i, 0,btn_width , priceDetailKSelectBarView_height)];
            [bb setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
            [bb setTitle:titAr[i][0] forState:UIControlStateNormal];
            bb.titleLabel.font=GXFONT_PingFangSC_Regular(12);
            [bb addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            bb.tag=tag_priceDetailKBarV_barbutton+i;
            [self addSubview:bb];
            
            if(i==0)
            {
                [bb setTitleColor:GXMainColor forState:UIControlStateNormal];
            }
        }
        
        
        //底下选中橘色条条
        selectLineImg=[[UIImageView alloc]initWithFrame:CGRectMake(10+5, priceDetailKSelectBarView_height-3, btn_width-10, 2)];
        selectLineImg.backgroundColor=GXMainColor;
        [self addSubview:selectLineImg];
        
        
        //more按钮
        otherSelectImgBackgBtn=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-40, 0, 40, priceDetailKSelectBarView_height)];
        [otherSelectImgBackgBtn addTarget:self action:@selector(otherSelectImgBackgBtn:) forControlEvents:UIControlEventTouchUpInside];
        [otherSelectImgBackgBtn setImage:[UIImage imageNamed:@"priceDetailKBarSelectMore"] forState:UIControlStateNormal];
        [otherSelectImgBackgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [self addSubview:otherSelectImgBackgBtn];
        

        //更多周期视图
        otherKselectView=[[UIView alloc]initWithFrame:CGRectMake(0, priceDetailKSelectBarView_height, GXScreenWidth, 0)];
        otherKselectView.backgroundColor=[UIColor whiteColor];
        [self addSubview:otherKselectView];
        
        //更多周期button
        for (int i=0; i<[titArMore count]; i++) {
            UIButton *bb=[[UIButton alloc]initWithFrame:CGRectMake(10+btn_width*i, 0,btn_width , 0)];
            [bb setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
            [bb setTitle:titArMore[i][0] forState:UIControlStateNormal];
            bb.titleLabel.font=GXFONT_PingFangSC_Regular(12);
            [bb addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            bb.tag=tag_priceDetailKBarV_barbutton+i+[titAr count];
            bb.alpha=0;
            [otherKselectView addSubview:bb];
        }
        
        //结束线
        UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, priceDetailKSelectBarView_height-1, GXScreenWidth, 1)];
        lineimg.backgroundColor=GXGrayLineColor;
        [self addSubview:lineimg];
        
    }
    return self;
}

-(void)btnClick:(id)sender
{
    UIButton *bb=(UIButton *)sender;
    
    NSInteger touchIndex=bb.tag-tag_priceDetailKBarV_barbutton;
    
    //点中“其他”按钮，打开更多视图
    if(touchIndex==[titAr count]-1)
    {
        [self otherSelectImgBackgBtn:otherSelectImgBackgBtn];
    }else//点击除“其他”以外的按钮更多视图应该关闭
    {
        if(otherSelectImgBackgBtn.selected)
        {
            [self otherSelectImgBackgBtn:otherSelectImgBackgBtn];
        }
    }
    
    
    //如果点击了默认显示的周期，除了"其他"
    if(touchIndex<[titAr count]-1)
    {
        [delegate PriceDetailSelectKBarViewDelegate:touchIndex barTit:titAr[touchIndex][0] httpPostInd:titAr[touchIndex][1]];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            //控制橘色条
            CGRect r_selectLineImg=selectLineImg.frame;
            r_selectLineImg.origin.x=bb.frame.origin.x+5;
            selectLineImg.frame=r_selectLineImg;
            
            //控制button颜色
            for (int i=0; i<[titAr count]; i++) {
                UIButton *tag_bb=[self viewWithTag:tag_priceDetailKBarV_barbutton+i];
                [tag_bb setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
            }
            [bb setTitleColor:GXMainColor forState:UIControlStateNormal];
            
            //还原“其他”按钮文本
            UIButton *other_bb=[self viewWithTag:tag_priceDetailKBarV_barbutton+[titAr count]-1];
            [other_bb setTitle:[titAr lastObject][0] forState:UIControlStateNormal];
        }];
        
    }
    else if (touchIndex>=[titAr count])//如果点击了展开的更多周期
    {
        [delegate PriceDetailSelectKBarViewDelegate:touchIndex barTit:titArMore[touchIndex-[titAr count]][0] httpPostInd:titArMore[touchIndex-[titAr count]][1]];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            //控制橘色条
            UIButton *other_bb=[self viewWithTag:tag_priceDetailKBarV_barbutton+[titAr count]-1];//找到“其他”按钮,让橘色条落在它下面
            CGRect r_selectLineImg=selectLineImg.frame;
            r_selectLineImg.origin.x=other_bb.frame.origin.x+5;
            selectLineImg.frame=r_selectLineImg;
            
            //控制button颜色
            for (int i=0; i<[titAr count]; i++) {
                UIButton *tag_bb=[self viewWithTag:tag_priceDetailKBarV_barbutton+i];
                [tag_bb setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
            }
            [other_bb setTitleColor:GXMainColor forState:UIControlStateNormal];
            
            //控制“其他”按钮文本为点击文本
            [other_bb setTitle:titArMore[touchIndex-[titAr count]][0] forState:UIControlStateNormal];
        }];
        
    }
    
    
}


#pragma mark - 更多周期视图
-(void)otherSelectImgBackgBtn:(id)sender
{
    UIButton *bb=(UIButton *)sender;
    
    if(bb.selected==YES)
    {
        bb.selected=NO;
        
        [self setButtonColorAndImgRotationAndFrame_otherSelectImgRotation:0 otherKselectViewHeight:0 kButtonHeight:0 kButtonAlpha:0 selfViewHeight:priceDetailKSelectBarView_height];
    }else
    {
        bb.selected=YES;
        
        [self setButtonColorAndImgRotationAndFrame_otherSelectImgRotation:(M_PI-0.001) otherKselectViewHeight:priceDetailKSelectBarView_height kButtonHeight:priceDetailKSelectBarView_height kButtonAlpha:1 selfViewHeight:(priceDetailKSelectBarView_height*2)];
    }
}

//设置更多周期视图
-(void)setButtonColorAndImgRotationAndFrame_otherSelectImgRotation:(CGFloat)r otherKselectViewHeight:(float)h kButtonHeight:(float)bh kButtonAlpha:(float)alpha selfViewHeight:(float)sh
{
    [UIView animateWithDuration:0.2 animations:^{
        
        //调整三角图片旋转
        otherSelectImgBackgBtn.imageView.transform = CGAffineTransformMakeRotation(r);
        
        //调整更多周期视图
        CGRect r=otherKselectView.frame;
        r.size.height=h;
        otherKselectView.frame=r;
        
        //调整更多周期button
        for (int i=0; i<[titArMore count]; i++) {
            UIButton *bb=[self viewWithTag:tag_priceDetailKBarV_barbutton+i+[titAr count]];
            CGRect r=bb.frame;
            r.size.height=bh;
            bb.frame=r;
            
            bb.alpha=alpha;
        }
        
        //调整self的高度
        r=self.frame;
        r.size.height=sh;
        self.frame=r;
    }];
}
-(void)KSelectBarViewCloseMorebar
{
    if(otherSelectImgBackgBtn.selected)
    {
        [self otherSelectImgBackgBtn:otherSelectImgBackgBtn];
    }
}
@end
