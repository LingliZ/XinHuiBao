//
//  HistoryListTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 16/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHBTradePositionModel;

@interface HistoryListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) XHBTradePositionModel *hModel;

@end
