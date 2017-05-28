//
//  GXTabbar+badge.h
//  GXApp
//
//  Created by futang yang on 2016/11/17.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabbar.h"

@interface GXTabbar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
