//
//  GXXHBHomeFourBtn.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeFourBtn.h"

@implementation GXXHBHomeFourBtn
#define GXColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:1.000 green:0.592 blue:0.110 alpha:1.000] forState:UIControlStateHighlighted];
    }
    return self;
}

//取消按钮的高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
}
////重写这个方法（调整标签标题的位置）
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(ZPScreenWidth/3-contentRect.size.width/2, contentRect.size.height-7, contentRect.size.width, 12);
//}
////调整图片位置
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake((ZPScreenWidth/5-44)/2, 7, 44, 44);
//}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2+HeightScale_IOS6(15);
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + HeightScale_IOS6(20);
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
