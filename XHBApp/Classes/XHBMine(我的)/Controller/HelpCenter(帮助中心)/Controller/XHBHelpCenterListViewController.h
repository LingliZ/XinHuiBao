//
//  XHBHelpCenterListViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBHelpListModel.h"
#import "XHBHelpCenterDetailViewController.h"
@interface XHBHelpCenterListViewController : XHBBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString*catid;
@end
