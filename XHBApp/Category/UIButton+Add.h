//
//  UIButton+Add.h
//  GXApp
//
//  Created by WangLinfang on 16/7/7.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GXImagePosition) {
    GXImagePositionLeft = 0,              //图片在左，文字在右，默认
    GXImagePositionRight = 1,             //图片在右，文字在左
    GXImagePositionTop = 2,               //图片在上，文字在下
    GXImagePositionBottom = 3,            //图片在下，文字在上
};


@interface UIButton (Add)

/**
 *  验证手机号是否合法
 *
 *  @param phoneNum 电话号码
 *
 *  @return BOOL值
 */
+(BOOL)checkIsLegalPhoneNum:(NSString*)phoneNum;

/**
 *  拨打电话
 *
 *  @param phoneNum 电话号码
 *  @param view     当前控制器的View
 */
+(void)callPhoneWithPhoneNum:(NSString*)phoneNum atView:(UIView*)view;

/**
 *  将按钮变为发送验证码时的倒计时模式
 *
 *  @param timeInterval 时间间隔
 */
-(void)turnModeForSendVertyCodeWithTimeInterval:(int)timeInterval;

/**
 *  设置Button图片显示的位置
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(GXImagePosition)postion spacing:(CGFloat)spacing;


/**
 *  旋转button的图片
 *
 *  @param sender 参数
 */
+ (void)makeMoreBtnRotaionWith:(UIButton *)sender;

/**
 *  增加button点击区域大小
 *  必须都要设置才能起作用
 *  @param top    上
 *  @param right  右
 *  @param bottom 下
 *  @param left   左
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
