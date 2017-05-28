//
//  UIImage+Resize.m
//  NYXImagesKit
//
//  Created by yangfutang on 02/05/11.
//  Copyright yangfutang. All rights reserved.
//

#import "NYXImagesHelper.h"

typedef enum {
	GXCropModeTopLeft,
	GXCropModeTopCenter,
	GXCropModeTopRight,
	GXCropModeBottomLeft,
	GXCropModeBottomCenter,
	GXCropModeBottomRight,
	GXCropModeLeftCenter,
	GXCropModeRightCenter,
	GXCropModeCenter
} GXCropMode;

typedef enum {
	GXResizeModeScaleToFill,
	GXResizeModeAspectFit,
	GXResizeModeAspectFill
}GXResizeMode;


@interface UIImage (Resizing)
// 裁剪
-(UIImage*)cropToSize:(CGSize)newSize;
// 裁剪 显示模式
-(UIImage*)cropToSize:(CGSize)newSize usingMode:(GXCropMode)cropMode;
// 缩放图片
-(UIImage*)scaleByFactor:(float)scaleFactor;
// 缩放图片 显示模式
-(UIImage*)scaleToSize:(CGSize)newSize usingMode:(GXResizeMode)resizeMode;

// 缩放图片 显示图片：图片充满容器 不保持纵横比
-(UIImage*)scaleToSize:(CGSize)newSize;
// 缩放图片 显示图片：保持纵横比 可能会超出容器
-(UIImage*)scaleToFillSize:(CGSize)newSize;
// 缩放图片 显示图片：填满容器 按照纵横比
-(UIImage*)scaleToFitSize:(CGSize)newSize;
// 缩放图片 显示图片：保持纵横比
-(UIImage*)scaleToCoverSize:(CGSize)newSize;
// 裁剪图片
- (UIImage *)circleImage;
@end
