//
//  GXToast.m
//  GXApp
//
//  Created by 王淼 on 16/8/11.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXToast.h"


@implementation ToastLabel

-(instancetype) init{
    self=[super init];
    if (self) {
        self.layer.cornerRadius=8;
        self.layer.masksToBounds=YES;
        self.backgroundColor=[UIColor blackColor];
        self.numberOfLines=0;
        self.textAlignment=NSTextAlignmentCenter;
        self.textColor=[UIColor whiteColor];
        self.font=[UIFont systemFontOfSize:15];
    }

    return self;

}

-(void) setMessageText:(NSString*) text{
    [self setText:text];
    CGRect rect=[self.text boundingRectWithSize:CGSizeMake(GXScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    CGFloat width=rect.size.width+20;
    CGFloat height=rect.size.height+20;
    CGFloat x=(GXScreenWidth-width)/2;
    CGFloat y=GXScreenHeight-HeightScale_IOS6(200);
    self.frame=CGRectMake(x, y, width, height);
}


@end



@implementation GXToast

+(instancetype) shareInstance{

    static GXToast *singleton=nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton=[[GXToast alloc] init];
    });
    
    return singleton;
}


-(instancetype) init{

    self=[super init];
    if (self) {
        toastLabel=[[ToastLabel alloc] init];
        countTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        countTimer.fireDate=[NSDate distantFuture];
    }
    return self;
}


-(void) makeToast:(NSString*) message{
    if ([message length] == 0) {
        return;
    }
    [toastLabel setMessageText:message];
    [[[UIApplication sharedApplication] keyWindow] addSubview:toastLabel];
    toastLabel.alpha=0.8;
    countTimer.fireDate=[NSDate distantPast];
    changeCount=2;

}

-(void)changeTime{

    if (changeCount--<=0) {
        
        countTimer.fireDate=[NSDate distantFuture];
        [UIView animateWithDuration:.2f animations:^{
            toastLabel.alpha=0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
        
    }

}

@end
