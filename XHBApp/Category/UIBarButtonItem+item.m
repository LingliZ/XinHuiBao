//
//  UIBarButtonItem+item.m
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIBarButtonItem+item.h"


@implementation UIBarButtonItem (item)


+ (instancetype)MyBarButtonItem:(UIImage *)image helited:(UIImage *)heiImage target:(id)target action:(SEL)action forcontroEvent:(UIControlEvents)controlEvents {
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 增加点击区域
    [btn setEnlargeEdgeWithTop:10 right:10 bottom:1 left:20];
  
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:heiImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    [btn sizeToFit];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

+ (instancetype)MyBarButtonItemTitle:(NSString *)title target:(id)target action:(SEL)action forcontroEvent:(UIControlEvents)controlEvents {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    [btn sizeToFit];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}



@end
