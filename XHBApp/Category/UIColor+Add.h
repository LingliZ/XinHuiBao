//
//  UIColor+Add.h
//  GXApp
//
//  Created by futang yang on 16/7/27.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Add)

/**
 *  返回颜色
 *
 *  @param hexColor 16进制颜色
 *
 *  @return color对象
 */
+ (UIColor *)getColor:(NSString *)hexColor;

@end
