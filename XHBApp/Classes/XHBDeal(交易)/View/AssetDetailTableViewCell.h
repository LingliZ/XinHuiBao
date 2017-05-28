//
//  AssetDetailTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDetailTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lb_drawnumberid;

@property(nonatomic,weak)IBOutlet UILabel *lb_operationtype;

@property(nonatomic,weak)IBOutlet UILabel *lb_bankname;

@property(nonatomic,weak)IBOutlet UILabel *lb_amountnum;

@property(nonatomic,weak)IBOutlet UILabel *lb_tradetime;

@property(nonatomic,weak)IBOutlet UILabel *lb_status;
@end
