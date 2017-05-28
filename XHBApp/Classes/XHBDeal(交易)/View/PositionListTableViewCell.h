//
//  PositionListTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBTradePositionModel.h"

@interface PositionListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) XHBTradePositionModel *pModel;

@end
