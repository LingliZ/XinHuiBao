//
//  GXAskView.h
//  GXApp
//
//  Created by zhudong on 16/8/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXTextView.h"

@class GXAskView;
@protocol GXAskViewDelegate <NSObject>

- (void)sendBtnDidClick:(GXAskView *)askView;

@end
@interface GXAskView :UIView
@property (nonatomic,strong) GXTextView *textView;
@property (nonatomic,weak) id<GXAskViewDelegate> delegate;
@end
