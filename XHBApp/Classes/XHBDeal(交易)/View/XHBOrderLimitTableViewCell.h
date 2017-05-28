//
//  XHBOrderLimitTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 17/3/10.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHBTradePositionModel;
@interface XHBOrderLimitTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) XHBTradePositionModel *pModel;

@end
