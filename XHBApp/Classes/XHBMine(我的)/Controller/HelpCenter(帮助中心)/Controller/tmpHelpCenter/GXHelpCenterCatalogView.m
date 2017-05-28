//
//  GXHelpCenterCatalogView.m
//  GXApp
//
//  Created by 王淼 on 16/7/11.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXHelpCenterCatalogView.h"


@interface GXHelpCenterCatalogView ()


@end


@implementation GXHelpCenterCatalogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView* spView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, HeightScale_IOS6(10))];
        
        spView.backgroundColor=GXRGBColor(245, 246, 244);;
        [self addSubview:spView];
        
        UIImageView* sp1View=[[UIImageView alloc] initWithFrame:CGRectMake(0, HeightScale_IOS6(10), frame.size.width, HeightScale_IOS6(.5))];
        
        sp1View.backgroundColor=GXRGBColor(188, 186, 193);
        [self addSubview:sp1View];
        
        
        UIImageView* sp2View=[[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, HeightScale_IOS6(.5))];
        
        sp2View.backgroundColor=GXRGBColor(188, 186, 193);
        [self addSubview:sp2View];
        
        
        
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(WidthScale_IOS6(15),(frame.size.height-HeightScale_IOS6(10)-HeightScale_IOS6(16.5))/2+HeightScale_IOS6(10), WidthScale_IOS6(18.5), HeightScale_IOS6(16.5))];
        //self.imageView.backgroundColor=[UIColor orangeColor];
        [self addSubview:self.imageView];
        self.backgroundColor=[UIColor whiteColor];
        
        
        self.title=[[UILabel alloc] initWithFrame:CGRectMake(WidthScale_IOS6(15)+WidthScale_IOS6(10)+WidthScale_IOS6(18.5), HeightScale_IOS6(10), frame.size.width-30, frame.size.height-HeightScale_IOS6(10))];
        self.title.textColor=[UIColor orangeColor];
        [self addSubview:self.title];
       

    }
    return self;
}

-(void) setModel:(GXHelperCatalogModel* ) model{
    self.title.text=model.title;
}


@end
