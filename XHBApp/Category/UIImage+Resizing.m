//
//  UIImage+Resize.m
//  NYXImagesKit
//
//  Created by yangfutang on 02/05/11.
//  Copyright yangfutang. All rights reserved.
//


#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

-(UIImage*)cropToSize:(CGSize)newSize usingMode:(GXCropMode)cropMode
{
	const CGSize size = self.size;
	CGFloat x, y;
	switch (cropMode)
	{
		case GXCropModeTopLeft:
			x = y = 0.0f;
			break;
		case GXCropModeTopCenter:
			x = (size.width - newSize.width) * 0.5f;
			y = 0.0f;
			break;
		case GXCropModeTopRight:
			x = size.width - newSize.width;
			y = 0.0f;
			break;
		case GXCropModeBottomLeft:
			x = 0.0f;
			y = size.height - newSize.height;
			break;
		case GXCropModeBottomCenter:
			x = (size.width - newSize.width) * 0.5f;
			y = size.height - newSize.height;
			break;
		case GXCropModeBottomRight:
			x = size.width - newSize.width;
			y = size.height - newSize.height;
			break;
		case GXCropModeLeftCenter:
			x = 0.0f;
			y = (size.height - newSize.height) * 0.5f;
			break;
		case GXCropModeRightCenter:
			x = size.width - newSize.width;
			y = (size.height - newSize.height) * 0.5f;
			break;
		case GXCropModeCenter:
			x = (size.width - newSize.width) * 0.5f;
			y = (size.height - newSize.height) * 0.5f;
			break;
		default: // Default to top left
			x = y = 0.0f;
			break;
	}

	if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored || self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored)
	{
		CGFloat temp = x;
		x = y;
		y = temp;
        
        temp = newSize.width;
        newSize.width = newSize.height;
        newSize.height = temp;
	}

	CGRect cropRect = CGRectMake(x * self.scale, y * self.scale, newSize.width * self.scale, newSize.height * self.scale);

	/// Create the cropped image
	CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
	UIImage* cropped = [UIImage imageWithCGImage:croppedImageRef scale:self.scale orientation:self.imageOrientation];

	/// Cleanup
	CGImageRelease(croppedImageRef);

	return cropped;
}

/* Convenience method to crop the image from the top left corner */
-(UIImage*)cropToSize:(CGSize)newSize
{
	return [self cropToSize:newSize usingMode:GXCropModeTopLeft];
}

-(UIImage*)scaleByFactor:(float)scaleFactor
{
	CGSize scaledSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);
	return [self scaleToFillSize:scaledSize];
}

-(UIImage*)scaleToSize:(CGSize)newSize usingMode:(GXResizeMode)resizeMode
{
	switch (resizeMode)
	{
		case GXResizeModeAspectFit:
			return [self scaleToFitSize:newSize];
		case GXResizeModeScaleToFill:
			return [self scaleToCoverSize:newSize];
		default:
			return [self scaleToFillSize:newSize];
	}
}

/* Convenience method to scale the image using the NYXResizeModeScaleToFill mode */
-(UIImage*)scaleToSize:(CGSize)newSize
{
	return [self scaleToFillSize:newSize];
}

-(UIImage*)scaleToFillSize:(CGSize)newSize
{
	size_t destWidth = (size_t)(newSize.width * self.scale);
	size_t destHeight = (size_t)(newSize.height * self.scale);
	if (self.imageOrientation == UIImageOrientationLeft
		|| self.imageOrientation == UIImageOrientationLeftMirrored
		|| self.imageOrientation == UIImageOrientationRight
		|| self.imageOrientation == UIImageOrientationRightMirrored)
	{
		size_t temp = destWidth;
		destWidth = destHeight;
		destHeight = temp;
	}

  /// Create an ARGB bitmap context
	CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * kNyxNumberOfComponentsPerARBGPixel, NYXImageHasAlpha(self.CGImage));
	if (!bmContext)
		return nil;

	/// Image quality
	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);

	/// Draw the image in the bitmap context

	UIGraphicsPushContext(bmContext);
  CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
	UIGraphicsPopContext();

	/// Create an image object from the context
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
	UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];

	/// Cleanup
	CGImageRelease(scaledImageRef);
	CGContextRelease(bmContext);

	return scaled;
}

-(UIImage*)scaleToFitSize:(CGSize)newSize
{
	/// Keep aspect ratio
	size_t destWidth, destHeight;
	if (self.size.width > self.size.height)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	else
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	if (destWidth > newSize.width)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	if (destHeight > newSize.height)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

-(UIImage*)scaleToCoverSize:(CGSize)newSize
{
	size_t destWidth, destHeight;
	CGFloat widthRatio = newSize.width / self.size.width;
	CGFloat heightRatio = newSize.height / self.size.height;
	/// Keep aspect ratio
	if (heightRatio > widthRatio)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	else
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

- (UIImage *)circleImage {
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
