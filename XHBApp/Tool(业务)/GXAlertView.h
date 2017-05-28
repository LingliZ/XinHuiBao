//
//  GXAlertView.h
//  XHBApp
//
//  Created by shenqilong on 16/11/30.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXAlertViewDelegate;

@interface GXAlertView : UIView

@property(nonatomic,assign)id<GXAlertViewDelegate>delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)del  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (instancetype)initWithTitle:(NSString *)title delegate:(id)del buttonAr:(NSArray *)btnAr buttonDesAr:(NSArray *)btnDesAr selectButton:(int)sIndex;

- (void)show;

@end
@protocol GXAlertViewDelegate <NSObject>

- (void)gxAlertView:(GXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
