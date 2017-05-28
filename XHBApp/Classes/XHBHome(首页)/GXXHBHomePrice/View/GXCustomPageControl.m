//
//  GXCustomPageControl.m
//  PageControl练习
//
//  Created by 王振 on 2016/9/28.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import "GXCustomPageControl.h"




@implementation GXCustomPageControl
//重新定义PageControl圆点大小
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = GXdotW + GXmagrin;
    
    //计算整个pageControll的宽度
    //CGFloat newW = (self.subviews.count - 1 ) * marginX;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX + (self.frame.size.width - ((self.subviews.count - 1) * marginX)- GXactiveDotW) / 2, dot.frame.origin.y, GXactiveDotW, GXactiveDotW)];
        }else {
            [dot setFrame:CGRectMake(i * marginX + (self.frame.size.width - ((self.subviews.count - 1) * marginX)- GXactiveDotW) / 2, dot.frame.origin.y, GXdotW, GXdotW)];
        }
    }
}


@end
