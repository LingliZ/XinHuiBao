//
//  GXXHBSpecialActivityCell.h
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXXHBHomeCycleModel.h"


@interface GXXHBSpecialActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgView;
@property (weak, nonatomic) IBOutlet UILabel *detialLabel;
@property (nonatomic,strong)GXXHBHomeCycleModel *model;
@end
