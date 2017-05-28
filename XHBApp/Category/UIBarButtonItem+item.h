//
//  UIBarButtonItem+item.h
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (item)

/**
 *  快速创建UIBarButtonItem
 *
 *  @param image         图片
 *  @param heiImage      高亮图片
 *  @param target        target
 *  @param action        方法
 *  @param controlEvents 触发方式
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)MyBarButtonItem:(UIImage *)image helited:(UIImage *)heiImage target:(id)target action:(SEL)action forcontroEvent:(UIControlEvents)controlEvents;

+ (instancetype)MyBarButtonItemTitle:(NSString *)title target:(id)target action:(SEL)action forcontroEvent:(UIControlEvents)controlEvents;




@end
