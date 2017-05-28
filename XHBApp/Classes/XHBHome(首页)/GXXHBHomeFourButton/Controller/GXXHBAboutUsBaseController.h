//
//  GXXHBAboutUsBaseController.h
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXXHBAboutUsBaseController : UIViewController
@property (nonatomic,strong)NSString *type;

- (void)createLabel:(NSString *)yourTitleStr;
- (void)createTableViewFromVC:(NSString *)yourTag;

@end
