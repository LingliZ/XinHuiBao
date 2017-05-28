//
//  PriceMarketTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 16/11/7.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceMarketModel.h"


@interface PriceMarketTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) PriceMarketModel *marketModel;


@end
