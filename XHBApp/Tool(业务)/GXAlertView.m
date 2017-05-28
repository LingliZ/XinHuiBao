//
//  GXAlertView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/30.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXAlertView.h"

#define alertView_maxWidth (GXScreenWidth-60)
#define msg_maxHeight (GXScreenHeight-320)

@implementation GXAlertView
{
    NSMutableArray *otherBtnAr;
}
@synthesize delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)del cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        self.backgroundColor=[UIColor clearColor];
        
        self.alpha=0;
        
        UIView *rootV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        rootV.backgroundColor=[UIColor clearColor];
        [self addSubview:rootV];
        
        UIView *backg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        backg.backgroundColor=[UIColor blackColor];
        backg.alpha=0.6;
        [rootV addSubview:backg];
        
        UIView *alertv=[[UIView alloc]init];
        alertv.backgroundColor=[UIColor whiteColor];
        alertv.layer.masksToBounds=YES;
        alertv.layer.cornerRadius=4;
        [rootV addSubview:alertv];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(alertView_maxWidth-65, (66-50)/2.0, 50, 50)];
        icon.image=[UIImage imageNamed:@"littlewhale"];
        [alertv addSubview:icon];
        
        UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, icon.frame.origin.x-20, 66)];
        lb_tit.textColor=GXMainColor;
        lb_tit.font=GXFONT_PingFangSC_Medium(18);
        lb_tit.text=title;
        [alertv addSubview:lb_tit];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 66, alertView_maxWidth, 1)];
        line.backgroundColor=GXGrayLineColor;
        [alertv addSubview:line];
        
        UILabel *lb_msg=[[UILabel alloc]init];
        lb_msg.textColor=GXGray_priceTitleColor;
        lb_msg.font=GXFONT_PingFangSC_Regular(16);
        lb_msg.text=message;
        [alertv addSubview:lb_msg];
        lb_msg.numberOfLines=0;
        CGSize lbSize = [message boundingRectWithSize:CGSizeMake(alertView_maxWidth-40, msg_maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lb_msg.font} context:nil].size;
        lb_msg.frame=CGRectMake(20, line.frame.origin.y+20, lbSize.width, lbSize.height);
        
        
        
        otherBtnAr=[[NSMutableArray alloc]init];
        
        va_list params;//定义一个指向个数可变的参数列表指针
        va_start(params, otherButtonTitles);//va_start 得到第一个可变参数地址
        NSString *arg;
        
        if (otherButtonTitles) {
            //将第一个参数添加到array
            id prev = otherButtonTitles;
            [otherBtnAr addObject:prev];
            
            //va_arg 指向下一个参数地址
            //
            while ((arg = va_arg(params, NSString *))) {
                if (arg) {
                    GXLog(@"%@",arg);
                    [otherBtnAr addObject:arg];
                }
            }  
            //置空  
            va_end(params);  
        }
        
        float height=lb_msg.frame.origin.y+lb_msg.frame.size.height+30;
        float width=alertView_maxWidth;
        float x=0;
        
        //其他button 原则上最多3个再多显示就有问题了
        for (int i=0; i<[otherBtnAr count]; i++) {
            if([otherBtnAr count]==1)
            {
                width=width/2.0;
                x=width;
                
                UIButton *btn=[self setOtherButton:otherBtnAr[i]];
                btn.frame=CGRectMake(0, height, width, 50);
                btn.tag=i;
                [alertv addSubview:btn];
                
                [self setBorderWithView:btn top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
            }else
            {
                UIButton *btn=[self setOtherButton:otherBtnAr[i]];
                btn.frame=CGRectMake(0, height, width, 50);
                btn.tag=i;
                [alertv addSubview:btn];
                [self setBorderWithView:btn top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
                
                height+=50;
            }
        }
        UIButton *btn=[self setCancelButton:cancelButtonTitle];
        btn.frame=CGRectMake(x, height, width, 50);
        btn.tag=[otherBtnAr count];
        [alertv addSubview:btn];
        
        
        
        alertv.frame=CGRectMake(0, 0, alertView_maxWidth, btn.frame.origin.y+btn.frame.size.height);
        alertv.center=self.window.center;
        
        self.delegate=del;
    }
    
    return self;
}


-(UIButton *)setCancelButton:(NSString *)tit
{
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:tit forState:UIControlStateNormal];
    btn.titleLabel.font=GXFONT_PingFangSC_Medium(18);
    btn.backgroundColor=GXMainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(UIButton *)setOtherButton:(NSString *)tit
{
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:tit forState:UIControlStateNormal];
    btn.titleLabel.font=GXFONT_PingFangSC_Regular(18);
    btn.backgroundColor=[UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(otherBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)cancelBtn:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
    
    UIButton *btn=sender;
    
    if(self.delegate)
    [delegate gxAlertView:self clickedButtonAtIndex:btn.tag];
}

-(void)otherBtn:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
    
    UIButton *btn=sender;
    
    if(self.delegate)
    [delegate gxAlertView:self clickedButtonAtIndex:btn.tag];
}

-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    }];
}


#pragma mark -
- (instancetype)initWithTitle:(NSString *)title delegate:(id)del buttonAr:(NSArray *)btnAr buttonDesAr:(NSArray *)btnDesAr selectButton:(int)sIndex
{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        self.backgroundColor=[UIColor clearColor];
        
        self.alpha=0;
        
        UIView *rootV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        rootV.backgroundColor=[UIColor clearColor];
        [self addSubview:rootV];
        
        UIView *backg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        backg.backgroundColor=[UIColor blackColor];
        backg.alpha=0.6;
        [rootV addSubview:backg];
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [backg addGestureRecognizer:tap];
        
        
        
        UIView *alertv=[[UIView alloc]init];
        alertv.backgroundColor=[UIColor whiteColor];
        alertv.layer.masksToBounds=YES;
        alertv.layer.cornerRadius=4;
        [rootV addSubview:alertv];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(alertView_maxWidth-65, (66-50)/2.0, 50, 50)];
        icon.image=[UIImage imageNamed:@"littlewhale"];
        [alertv addSubview:icon];
        
        UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, icon.frame.origin.x-20, 66)];
        lb_tit.textColor=GXMainColor;
        lb_tit.font=GXFONT_PingFangSC_Medium(18);
        lb_tit.text=title;
        [alertv addSubview:lb_tit];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 66, alertView_maxWidth, 1)];
        line.backgroundColor=GXGrayLineColor;
        [alertv addSubview:line];
        
        
        float h=line.frame.origin.y+1;
        
        for (int i=0; i<[btnAr count]; i++) {
            
            NSString *des=@"";
            if(i<[btnDesAr count])
            {
                des=btnDesAr[i];
            }
            
            
            NSMutableAttributedString *str;
            
            float btnHeight=50;
            if(des.length>0)
            {
                btnHeight=62;
                
                str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",btnAr[i],des]];
                [str addAttribute:NSForegroundColorAttributeName value:GXRGBColor(165, 165, 165) range:NSMakeRange(str.length-des.length, des.length)];
                [str addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(12) range:NSMakeRange(str.length-des.length, des.length)];
            }else
            {
                str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",btnAr[i]]];
            }
            
            if(sIndex==i)
            {
                [str addAttribute:NSForegroundColorAttributeName value:GXRGBColor(254, 136, 42)  range:NSMakeRange(0,str.length-des.length)];
            }else
            {
                [str addAttribute:NSForegroundColorAttributeName value:GXRGBColor(51, 51, 51)  range:NSMakeRange(0,str.length-des.length)];
            }
            
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, h,alertView_maxWidth , btnHeight)];
            btn.titleLabel.font=GXFONT_PingFangSC_Regular(15);
            btn.backgroundColor=[UIColor whiteColor];
            [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.numberOfLines=0;
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            btn.tag=i;
            [alertv addSubview:btn];
            
            if(i>0)
            [self setBorderWithView:btn top:YES left:NO bottom:NO right:NO borderColor:GXRGBColor(242, 243, 243) borderWidth:1];
            
            
            h+=btnHeight;
        }
       
        
        alertv.frame=CGRectMake(0, 0, alertView_maxWidth, h);
        alertv.center=self.window.center;
        
        self.delegate=del;
    }
    
    return self;
}

-(void)selectBtn:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
    
    if(delegate)
    [delegate gxAlertView:self clickedButtonAtIndex:sender.tag];
}

-(void)tapClick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
