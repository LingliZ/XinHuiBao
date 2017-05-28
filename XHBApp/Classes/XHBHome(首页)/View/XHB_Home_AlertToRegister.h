//
//  XHB_Home_AlertToRegister.h
//  XHBApp
//
//  Created by WangLinfang on 16/12/5.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHB_Home_AlertToRegistDelegate <NSObject>
-(void)goToRegist;
-(void)closeView_AlertToRegister;
@end

@interface XHB_Home_AlertToRegister : UIView
@property(nonatomic,assign)id<XHB_Home_AlertToRegistDelegate>delegate;
@end
