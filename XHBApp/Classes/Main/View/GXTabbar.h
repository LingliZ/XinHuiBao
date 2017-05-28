//
//  GXTabbar.h
//  demo
//
//  Created by yangfutang on 16/5/10.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXTabbar;


@protocol GXTabbarDelegate <NSObject,UIApplicationDelegate>

@optional
- (void)tabbar:(GXTabbar *)Tabbar didselectIndex: (NSInteger)index;

@end


@interface GXTabbar : UIView

@property (nonatomic, copy) NSArray<NSDictionary *> *tabBarItemAttributes;

@property (nonatomic, strong) NSMutableArray *ItemsArray;
@property (nonatomic, weak) id <GXTabbarDelegate> delegate;
- (void)setSelectedIndex:(NSInteger)index;
- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes;
@end
