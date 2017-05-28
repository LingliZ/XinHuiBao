//
//  GXTabbarButton.h
//  demo
//
//  Created by yangfutang on 16/5/10.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LLTabBarItemType) {
    LLTabBarItemNormal = 0,
    LLTabBarItemRise,
};

extern NSString *const kLLTabBarItemAttributeTitle;// NSString
extern NSString *const kLLTabBarItemAttributeNormalImageName;// NSString
extern NSString *const kLLTabBarItemAttributeSelectedImageName;// NSString
extern NSString *const kLLTabBarItemAttributeType;// NSNumber, LLTabBarItemType


@interface GXTabbarButton : UIButton

@property (nonatomic, assign) LLTabBarItemType tabBarItemType;

@end
