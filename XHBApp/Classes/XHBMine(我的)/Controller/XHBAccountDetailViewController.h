//
//  XHBAccountDetailViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/24.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBAccountDetailViewController : XHBBaseViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString*account;
@property(nonatomic,strong)NSString*acconutLevel;
@end
