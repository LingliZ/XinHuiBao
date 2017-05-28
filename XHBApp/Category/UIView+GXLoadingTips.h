//
//  UIViewController+GXLoadingTips.h
//  GXApp
//
//  Created by zhudong on 16/7/21.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GXLoadingTips)
- (void)showLoadingWithTitle:(NSString *)title;
- (void)showSuccessWithTitle:(NSString *)title;
- (void)showFailWithTitle:(NSString *)title;
- (void)removeTipView;

-(void)banClickView;//当前view上的元素是否可点击,默认是可点击,需要在show方法前先调用
@end
