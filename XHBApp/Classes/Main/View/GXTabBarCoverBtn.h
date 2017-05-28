//
//  GXTabBarCoverBtn.h
//  GXApp
//
//  Created by zhudong on 16/7/25.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GXTabBarCoverBtn;
@protocol GXTabBarCoverBtnDelegate <NSObject>
- (void)tabBarCoverBtnDidClick:(GXTabBarCoverBtn *)btn;
@end

@interface GXTabBarCoverBtn : UITabBar
@property (nonatomic,weak) id<GXTabBarCoverBtnDelegate> coverBtnDelegate;
@end
