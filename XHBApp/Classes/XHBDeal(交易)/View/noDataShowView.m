//
//  noDataShowView.m
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "noDataShowView.h"


#define img_width 200
#define img_height 200

@implementation noDataShowView
{
    UIImageView *defaultImg;
    UILabel *detauleLb;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];
        
    }
    return self;
}

-(void)setTextTip:(NSString *)textT
{
    float y_center=self.frame.size.height/3.0;
    
    
    if(!defaultImg)
    {
        defaultImg=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-img_width)/2.0, y_center-100, img_width, img_height)];
        defaultImg.image=[UIImage imageNamed:@"positionNoDataImg"];
        [self addSubview:defaultImg];

    }
    
    if(!detauleLb)
    {
        detauleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, defaultImg.frame.origin.y+defaultImg.frame.size.height-35, self.frame.size.width, 25)];
        detauleLb.textColor=GXGray_priceTitleColor;
        detauleLb.textAlignment=NSTextAlignmentCenter;
        detauleLb.font=GXFONT_PingFangSC_Regular(16);
        [self addSubview:detauleLb];
    }
    detauleLb.text=textT;
}

@end
