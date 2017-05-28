//
//  GXCalendarEventModelCell.h
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarBaseModelCell.h"
#import "GXCalendarEventModel.h"
@interface GXCalendarEventModelCell : GXCalendarBaseModelCell
@property (nonatomic,strong)GXCalendarEventModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star5ImageView;









@end
