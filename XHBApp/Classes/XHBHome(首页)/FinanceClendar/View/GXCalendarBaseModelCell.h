//
//  GXCalendarBaseModelCell.h
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXCalendarBaseModel.h"
@interface GXCalendarBaseModelCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView Model:(GXCalendarBaseModel *)model IndexPath:(NSIndexPath *)indexPath;

- (void)setModel:(GXCalendarBaseModel *)model;

@end
