//
//  UIImage+Add.m
//  GXApp
//
//  Created by WangLinfang on 16/8/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIImage+Add.h"

@implementation UIImage (Add)
/**
 *  根据十六进制颜色获取图片
 *
 *  @param hexColorStr 十六进制颜色字符串
 *
 *  @return 生成的图片
 */
+(UIImage*)getImageWithHexColor:(NSString *)hexColorStr
{
    UIColor*color=[UIColor getColor:hexColorStr];
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
