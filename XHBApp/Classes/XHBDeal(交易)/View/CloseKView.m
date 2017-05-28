//
//  CloseKView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/17.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "CloseKView.h"
#import "KlineModel.h"

#define topSpace 15//框距离边界高度
#define leftSpace 40//左距离边界宽度
#define rightSpace 0//右距离边界宽度

#define cell_height 30//格子高度
#define cell_width (self.frame.size.width-leftSpace-rightSpace)/3.0//格子宽度

#define yhighSpace 5//k线上下距离框的高度（和）
#define y_high (cell_height*3-yhighSpace*2)//图形总高度
@implementation CloseKView
{
    UIActivityIndicatorView *indiV;
    
    NSArray *dataAr;
    
    float point_h;//高度
    float point_price;//一块钱占的高度
    float t_max;//最大值
    float t_min;//最小值
    float Kline_weight;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        indiV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indiV.center=self.center;
        [indiV startAnimating];
        [self addSubview:indiV];
        
    }
    return self;
}

-(void)setIndiView:(BOOL)isAnimat
{
    if(isAnimat)
    {
        [indiV startAnimating];
    }else
    {
        [indiV stopAnimating];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ref=UIGraphicsGetCurrentContext();
    
    //横线框
    for (int i=0;i< 4; i++) {
        
        float x=leftSpace;
        float width=self.frame.size.width-leftSpace-rightSpace;
        if(i==0||i==3)
        {
            x=0;
            width=self.frame.size.width;
        }
        
        CGContextBeginPath(ref);
        CGContextSetStrokeColorWithColor(ref, GXGray_priceNameColor.CGColor );
        CGContextSetLineDash(ref, 0,0, 0);
        CGContextSetLineWidth(ref,0.5f);
        CGContextMoveToPoint(ref, x,  topSpace + i*cell_height);
        CGContextAddLineToPoint(ref, x+width,  topSpace + i*cell_height);
        CGContextStrokePath(ref);
        
        if([dataAr count]>0)
        {
            //纵坐标
            float maxPrice= t_max+ yhighSpace*point_price;
            if(i==1||i==2)
            {
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = NSTextAlignmentRight;
                
                NSString *price=[NSString stringToFloat:maxPrice-i*cell_height*point_price Code:self.code];
                
                [price drawInRect:CGRectMake(0,topSpace+cell_height*i-7 , leftSpace, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:GXGray_PositionTrade_TextColor,NSParagraphStyleAttributeName:paragraph}];
                paragraph=nil;
            }

        }
    }
    
    //竖线框
    for (int i=0;i< 4; i++) {
        
        CGContextBeginPath(ref);
        CGContextSetStrokeColorWithColor(ref, GXGray_priceNameColor.CGColor);
        CGContextSetLineDash(ref, 0,0, 0);
        CGContextSetLineWidth(ref,0.5f);
        CGContextMoveToPoint(ref, leftSpace+i*cell_width,  topSpace);
        CGContextAddLineToPoint(ref, leftSpace+i*cell_width,  topSpace + cell_height*3);
        CGContextStrokePath(ref);
        
        //时间坐标
        int index=i*cell_width/Kline_weight;
        if(index>=[dataAr count])
            index=(int)[dataAr count]-1;
        if(index<[dataAr count])
        {
            KlineModel *model=dataAr[index];
            
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentLeft;
            
            NSString *timestr=model.time;
            
            float x=leftSpace+i*cell_width-27;
            if(index==[dataAr count]-1)
            {
                x=leftSpace+i*cell_width-56;
            }
            
            [timestr drawInRect:CGRectMake(x,topSpace+cell_height*3 +5 , 100, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:GXGray_priceDetailTrade_TextColor,NSParagraphStyleAttributeName:paragraph}];
            paragraph=nil;
        }
    }
    
    if([dataAr count]==0)
    {
        return;
    }
    
    for (int i=0; i<[dataAr count]; i++)
    {
        KlineModel *model=dataAr[i];
        
        float kline_highY = y_high - ([model.high floatValue]-t_min) * point_h;
        float kline_lowY = y_high - ([model.low floatValue]-t_min) * point_h;
        
        float open=[model.open floatValue];
        float close=[model.close floatValue];
        
        if(close>open)//涨
        {
            float kline_highTop = y_high - ([model.close floatValue]-t_min) * point_h;
            float kline_lowButtom = y_high - ([model.open floatValue]-t_min) * point_h;
            float kline_H = fabs(kline_highTop-kline_lowButtom);
            if(kline_H<1)
            {
                kline_H=1;
            }
            
            CGContextBeginPath(ref);
            CGContextSetLineWidth(ref,1);
            CGContextSetStrokeColorWithColor(ref, GXRed_priceBackgColor.CGColor);
            CGContextMoveToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f, topSpace +yhighSpace+ kline_highY);
            CGContextAddLineToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f,topSpace +yhighSpace+kline_lowY);
            CGContextStrokePath(ref);
            
            CGContextSetLineWidth(ref, 1);
            CGContextSetFillColorWithColor(ref, [UIColor whiteColor].CGColor);
            CGContextSetStrokeColorWithColor(ref, GXRed_priceBackgColor.CGColor);
            CGContextAddRect(ref, CGRectMake(leftSpace+Kline_weight*i+1, topSpace+yhighSpace+kline_highTop, Kline_weight-2,kline_H));
            CGContextDrawPath(ref, kCGPathFillStroke);
            
        }else if (close<open)//跌
        {
            float kline_highTop = y_high - ([model.open floatValue]-t_min) * point_h;
            float kline_lowButtom = y_high - ([model.close floatValue]-t_min) * point_h;
            float kline_H = fabs(kline_highTop-kline_lowButtom);
            if(kline_H<1)
            {
                kline_H=1;
            }
            CGContextBeginPath(ref);
            CGContextSetLineWidth(ref,1);
            CGContextSetFillColorWithColor(ref, GXGreen_priceBackgColor.CGColor);
            CGContextFillRect(ref, CGRectMake(leftSpace+Kline_weight*i+0.5, topSpace+yhighSpace+kline_highTop, Kline_weight-1,kline_H));
            CGContextStrokePath(ref);
            
            CGContextBeginPath(ref);
            CGContextSetLineWidth(ref,1);
            CGContextSetStrokeColorWithColor(ref, GXGreen_priceBackgColor.CGColor);
            CGContextMoveToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f, topSpace+yhighSpace + kline_highY);
            CGContextAddLineToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f,topSpace+yhighSpace+kline_lowY);
            CGContextStrokePath(ref);
        }else
        {
            float kline_highM = y_high - ([model.close floatValue]-t_min) * point_h;
            
            CGContextBeginPath(ref);
            CGContextSetLineWidth(ref,1);
            CGContextSetStrokeColorWithColor(ref, GXRed_priceBackgColor.CGColor);
            CGContextMoveToPoint(ref, leftSpace+Kline_weight*i+0.5, topSpace+yhighSpace+ kline_highM);
            CGContextAddLineToPoint(ref, leftSpace+Kline_weight*(i+1)-1,topSpace +yhighSpace+ kline_highM);
            CGContextStrokePath(ref);
            
            CGContextBeginPath(ref);
            CGContextSetLineWidth(ref,1);
            CGContextSetStrokeColorWithColor(ref, GXRed_priceBackgColor.CGColor);
            CGContextMoveToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f, topSpace +yhighSpace+ kline_highY);
            CGContextAddLineToPoint(ref, leftSpace+Kline_weight*i+Kline_weight/2.0f,topSpace+yhighSpace+kline_lowY);
            CGContextStrokePath(ref);
        }

    }
}

-(void)setKLinemodel:(NSArray *)modelar
{
    if([modelar count]==0)
    {
        return;
    }
    dataAr=[[modelar reverseObjectEnumerator]allObjects];
    
    t_max=0;
    t_min=0;
    
    [self getmaxmin];
    
    Kline_weight=(self.frame.size.width-leftSpace-rightSpace)/(float)[dataAr count];
    
    point_price=(float)(t_max-t_min)/y_high;
    
    [self setNeedsDisplay];
}

-(void)getmaxmin
{
    for (KlineModel *m in dataAr) {
        if(t_max==0)
        {
            t_max=[m.high floatValue];
        }
        
        if(t_min==0)
        {
            t_min=[m.low floatValue];
        }
        
        float max_xx=[m.high floatValue];
        float min_xx=[m.low floatValue];
        
        if(max_xx>t_max)
        {
            t_max=max_xx;
        }
        if(min_xx<t_min)
        {
            t_min=min_xx;
        }
    }
    GXLog(@"%d",y_high);
    if((t_max-t_min)==0)
    {
        point_h=0;
    }else
        point_h = (float) (y_high/(t_max-t_min));
}

@end
