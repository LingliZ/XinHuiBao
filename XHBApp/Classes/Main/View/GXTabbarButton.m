//
//  GXTabbarButton.m
//  demo
//
//  Created by yangfutang on 16/5/10.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabbarButton.h"


NSString *const kLLTabBarItemAttributeTitle = @"LLTabBarItemAttributeTitle";
NSString *const kLLTabBarItemAttributeNormalImageName = @"LLTabBarItemAttributeNormalImageName";
NSString *const kLLTabBarItemAttributeSelectedImageName = @"LLTabBarItemAttributeSelectedImageName";
NSString *const kLLTabBarItemAttributeType = @"LLTabBarItemAttributeType";

@implementation GXTabbarButton



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)config {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//    [super titleRectForContentRect:contentRect];
//    CGRect titleRect = CGRectMake(20, 0, 0, 0);
//    return titleRect;
//}
//- (CGRect)imageRectForContentRect:(CGRect)contentRect;
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    if (imageSize.width != 0 && imageSize.height != 0) {
        CGFloat imageViewCenterY = CGRectGetHeight(self.frame) - 3 - titleSize.height - imageSize.height / 2 - 4;
        if (self.tag == 2) {
//             imageViewCenterY = CGRectGetHeight(self.frame) - 8 -6- titleSize.height - imageSize.height / 2;
            imageViewCenterY = CGRectGetHeight(self.frame) -5- titleSize.height - imageSize.height / 2;
        }
        self.imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, imageViewCenterY);
    } else {
        CGPoint imageViewCenter = self.imageView.center;
        imageViewCenter.x = CGRectGetWidth(self.frame) / 2;
        //imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height + 4) / 2;
        if (self.tag == 2) {
            imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height ) / 2;
        }else{
            imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height) / 2;
        }
        self.imageView.center = imageViewCenter;
    }
    if (self.tag == 2) {
        self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)- 10 - titleSize.height / 2);
    }else{
        CGPoint labelCenter = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)- 4 - titleSize.height / 2);
        self.titleLabel.center = labelCenter;

    }
//    NSLog(@"x轴:%f y轴:%f,宽:%f,高:%f",self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y,self.titleLabel.frame.size.width,self.titleLabel.frame.size.height);
    // 还有一种实现方式是设置 Edge Insets，Xcode 7.0.1 好像有点不开心，在 IB 里面更改一下属性的时候，经常崩溃。。。
    /* 位置还有一点不准确，推荐用上面的代码来设置
     
     [self.titleLabel sizeToFit];
     CGSize titleSize = self.titleLabel.frame.size;
     CGSize imageSize = [self imageForState:UIControlStateNormal].size;
     NSInteger titleTopInset = CGRectGetHeight(self.frame) - 3 - titleSize.height;
     CGFloat titleRightInset = (CGRectGetWidth(self.frame) - titleSize.width) / 2 + titleSize.width;
     [self setTitleEdgeInsets:UIEdgeInsetsMake(titleTopInset, 0, 3, titleRightInset)];
     CGFloat imageViewLeftRightInset = (CGRectGetWidth(self.frame) - imageSize.width) / 2;
     [self setImageEdgeInsets:UIEdgeInsetsMake(CGRectGetHeight(self.frame) - 3 - 5 - titleSize.height - imageSize.height, imageViewLeftRightInset, 3 + 5 + titleSize.height, imageViewLeftRightInset)];
     
     */
}

/**
 *  复写系统的高量实现，禁止按钮高亮
 *  此函数里不用写任何代码
 */
- (void)setHighlighted:(BOOL)highlighted{
    // do not anything
}






@end
