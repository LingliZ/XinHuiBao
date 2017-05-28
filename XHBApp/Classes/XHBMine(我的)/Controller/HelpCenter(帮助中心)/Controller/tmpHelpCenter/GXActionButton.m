//
//  GXActionButton.m
//  GXApp
//
//  Created by 王振 on 16/7/26.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXActionButton.h"

@implementation GXActionButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorWithWhite:0.608 alpha:1.000] forState:UIControlStateNormal];
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
    center.y = self.imageView.frame.size.height/2+3;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 10;
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
