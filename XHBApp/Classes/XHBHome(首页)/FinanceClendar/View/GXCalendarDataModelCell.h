//
//  GXCalendarDataModelCell.h
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarBaseModelCell.h"
#import "GXCalendarDataModel.h"
@interface GXCalendarDataModelCell : GXCalendarBaseModelCell
@property (nonatomic,strong)GXCalendarDataModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *foreCastLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star5ImageView;




















@end
