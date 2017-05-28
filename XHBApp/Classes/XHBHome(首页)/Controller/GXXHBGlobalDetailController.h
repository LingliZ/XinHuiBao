//
//  GXXHBGlobalDetailController.h
//  XHBApp
//
//  Created by 王振 on 2016/11/22.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXTabBarController.h"
#import "GXTabbar.h"
@interface GXXHBGlobalDetailController : UIViewController
//接收文章ID
@property (nonatomic,assign)NSInteger analystID;

//接收URL
@property (nonatomic,strong)NSString *recieveUrl;

@end
