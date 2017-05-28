//
//  GXXHBHomeNewsCell.h
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXXHBHomeNewsModel.h"
@interface GXXHBHomeNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descripLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)GXXHBHomeNewsModel *model;
@property (weak, nonatomic) IBOutlet UIView *view_Line;

@property (nonatomic,assign)BOOL isOneLineWidth;


@end
