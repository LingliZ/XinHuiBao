//
//  HistoryNavBarView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/18.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "HistoryListFilterView.h"
#import "XHBDealConst.h"
#import "GXCalendarPickerView.h"

@implementation HistoryListFilterView
{
    UIButton *selectBackgView;//黑色背景
    UIView *selectBtnView;//选择周期视图
    
    UIButton *btn_selectTimeButton;
    
    NSString *startTime;
    NSString *endTime;
    
    GXCalendarPickerView *pickV;
}
@synthesize delegate;

- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)]) {
        
        self.backgroundColor=[UIColor clearColor];
        self.hidden=YES;
        self.clipsToBounds=YES;
        
        selectBackgView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        selectBackgView.backgroundColor=[UIColor blackColor];
        selectBackgView.alpha=0;
        [selectBackgView addTarget:self action:@selector(closeV) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBackgView];
        
        
        selectBtnView=[[UIView alloc]initWithFrame:CGRectMake(0, -173, GXScreenWidth, 173)];
        selectBtnView.backgroundColor=[UIColor whiteColor];
        [self addSubview:selectBtnView];
        
        
        startTime=[GXInstance getnNetworkDate:-6];
        endTime=[GXInstance getnNetworkDate:0];
        
        
        //默认显示一周的
        NSArray *titar1=@[startTime,@"",endTime,@"全部",@"近一周",@"近三月"];
        for (int i=0; i<6; i++) {
            
            float x=i%3;
            float y=i/3;
            
            float sp=(GXScreenWidth-WidthScale_IOS6(103)*3)/4.0;
            
            if(i==1)
            {
                UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0-15, sp+15, 30, 1)];
                lineimg.backgroundColor=GXGray_priceNameColor;
                [selectBtnView addSubview:lineimg];
                continue;
            }
            
            UIButton *btn_selectTime=[[UIButton alloc]initWithFrame:CGRectMake(sp+x*(WidthScale_IOS6(103)+sp), sp+y*(30+sp), WidthScale_IOS6(103), 30)];
            btn_selectTime.backgroundColor=GXGrayLineColor;
            [btn_selectTime setTitle:titar1[i] forState:UIControlStateNormal];
            [btn_selectTime setTitleColor:GXGray_priceTitleColor forState:UIControlStateNormal];
            btn_selectTime.titleLabel.font=GXFONT_PingFangSC_Regular(14);
            btn_selectTime.layer.masksToBounds=YES;
            btn_selectTime.layer.cornerRadius=4;
            btn_selectTime.layer.borderWidth=1;
            btn_selectTime.layer.borderColor=GXGrayLineColor.CGColor;
            btn_selectTime.tag=tag_HistoryNavBarView_btn_selectTime+i;
            [btn_selectTime addTarget:self action:@selector(btn_selectTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectBtnView addSubview:btn_selectTime];
            
            if(i==3)
                [self setButtonUnSelect:btn_selectTime];
            if(i==4)
                [self setButtonSelect:btn_selectTime];
            if(i==5)
                [self setButtonUnSelect:btn_selectTime];
        }
        
        UIButton *btn_select_done=[[UIButton alloc]initWithFrame:CGRectMake((GXScreenWidth-166)/2.0, 116, 166, 36)];
        btn_select_done.backgroundColor=GXMainColor;
        [btn_select_done setTitle:@"确定" forState:UIControlStateNormal];
        [btn_select_done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_select_done.titleLabel.font=GXFONT_PingFangSC_Medium(16);
        btn_select_done.layer.masksToBounds=YES;
        btn_select_done.layer.cornerRadius=4;
        [btn_select_done addTarget:self action:@selector(btn_selectTime_doneClick) forControlEvents:UIControlEventTouchUpInside];
        [selectBtnView addSubview:btn_select_done];
        
    }
    return self;
}

-(void)setSelectTimeViewShow
{
    if(self.hidden)
    {
        self.hidden=NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect f=selectBtnView.frame;
            f.origin.y=0;
            selectBtnView.frame=f;
            
            selectBackgView.alpha=0.5;
        }];
        
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect f=selectBtnView.frame;
            f.origin.y=-f.size.height;
            selectBtnView.frame=f;
            
            selectBackgView.alpha=0;
            
        }completion:^(BOOL isf){
            
            self.hidden=YES;
        }];
    }
}

-(void)closeV
{
    [self setSelectTimeViewShow];
}

#pragma mark - 时间选择和商品选择操作
-(void)btn_selectTimeClick:(id)sender
{
    UIButton *bb=sender;
    btn_selectTimeButton=bb;
    
    if(bb.tag==tag_HistoryNavBarView_btn_selectTime+0 || bb.tag==tag_HistoryNavBarView_btn_selectTime+2)
    {
        [pickV remove];
        pickV=nil;
        
        NSDate *date;
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        
        date = [formater dateFromString:bb.titleLabel.text];
        
        
        pickV =[[GXCalendarPickerView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        pickV.delegate = (id)self;
        pickV.tag=bb.tag+10000;
        [pickV show];
        
    }else
    {
        //重置所有btn
        for (int i=3; i<6; i++) {
            UIButton *btn=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+i];
            [self setButtonUnSelect:btn];
        }
        //点亮选中btn
        [self setButtonSelect:sender];
    }
}

#pragma mark - 确定
-(void)btn_selectTime_doneClick
{
    [self setSelectTimeViewShow];
    
    NSString *tit;
    //更新startTime 和 endTime
    if(btn_selectTimeButton.tag==tag_HistoryNavBarView_btn_selectTime+3)
    {
        tit=@"全部";
        
        startTime=[GXInstance getnNetworkDate:-365*100];
        endTime=[GXInstance getnNetworkDate:0];
    }else if (btn_selectTimeButton.tag==tag_HistoryNavBarView_btn_selectTime+4)
    {
        tit=@"近一周";
        
        startTime=[GXInstance getnNetworkDate:-6];
        endTime=[GXInstance getnNetworkDate:0];
    }else if (btn_selectTimeButton.tag==tag_HistoryNavBarView_btn_selectTime+5)
    {
        tit=@"近三月";
        
        startTime=[GXInstance getnNetworkDate:-90];
        endTime=[GXInstance getnNetworkDate:0];
    }else
    {
        tit=[NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    }
    
    //确定
    [delegate HistoryListFilterViewDelegate_tit:tit startTime:startTime endTime:endTime];
}

#pragma mark -
-(void)setButtonSelect:(UIButton *)btn
{
    [btn setTitleColor:GXMainColor forState:UIControlStateNormal];
    [btn setBackgroundColor:GXGrayLineColor];
    btn.selected=YES;
}

-(void)setButtonUnSelect:(UIButton *)btn
{
    [btn setTitleColor:GXGray_priceTitleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.selected=NO;
}


//日期选择器代理
-(void)toobarDonBtnHaveClick:(GXCalendarPickerView *)pickView resultString:(NSString *)resultString{
    
    GXLog(@"%@",resultString);
    
    //把time赋值为上次选择的time
    UIButton *btn_start=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+0];
    startTime = btn_start.titleLabel.text;
    
    UIButton *btn_end=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+2];
    endTime = btn_end.titleLabel.text;
    
    
    //赋值新time
    NSMutableString *time=[[NSMutableString alloc]initWithString:resultString];
    [time insertString:@"-" atIndex:4];
    [time insertString:@"-" atIndex:7];
    
    if(pickView.tag==tag_HistoryNavBarView_btn_selectTime+10000+0)
    {
        startTime=time;
        
        NSString *strattimestr=[startTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *endtimestr=[endTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if([endtimestr integerValue]<[strattimestr integerValue])
        {
            startTime=endTime;
            
            [[GXToast shareInstance] makeToast:@"所选时间不能大于结束时间"];
        }
        
        UIButton *btn_start=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+0];
        [btn_start setTitle:startTime forState:UIControlStateNormal];
        
        btn_selectTimeButton=btn_start;
    }else
    {
        endTime=time;
        
        NSString *strattimestr=[startTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *endtimestr=[endTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if([endtimestr integerValue]<[strattimestr integerValue])
        {
            endTime=startTime;
            
            [[GXToast shareInstance] makeToast:@"所选时间不能小于开始时间"];
        }
        
        UIButton *btn_end=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+2];
        [btn_end setTitle:endTime forState:UIControlStateNormal];
        
        btn_selectTimeButton=btn_end;
    }
    
    //重置时间选择周期状态
    for (int i=3; i<6; i++) {
        UIButton *btn=[self viewWithTag:tag_HistoryNavBarView_btn_selectTime+i];
        [self setButtonUnSelect:btn];
    }
    
    time=nil;
}


@end
