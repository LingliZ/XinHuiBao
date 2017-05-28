//
//  UIImage+Tabbar.h
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tabbar)

/**
 *  始终绘制图片原始状态，不使用Tint Color
 *
 *  @param imageName 图片名称
 *
 *  @return image对象
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

/**
 *  拉伸图片
 *
 *  @param imageName 图片名称
 *
 *  @return image对象
 */
+ (instancetype)resizableWithImageName:(NSString *)imageName;

@end
