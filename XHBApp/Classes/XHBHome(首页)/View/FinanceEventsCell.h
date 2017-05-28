//
//  FinanceEventsCell.h
//  GXApp
//
//  Created by GXJF on 16/6/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXFinanceDataModel.h"
@interface FinanceEventsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *star1LeadingLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QuotaLabelLeadingLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regionImgLeadingLine;



@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (weak, nonatomic) IBOutlet UILabel *predicLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTrailingLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeadingLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FEDateLeadingLabel;

@property (weak, nonatomic) IBOutlet UIView *view_Line;



@property (weak, nonatomic) IBOutlet UILabel *FEDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *regionImgView;

@property (weak, nonatomic) IBOutlet UILabel *quotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *former_valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *predict_valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *public_valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star3ImageView;
@property (nonatomic,strong)GXFinanceDataModel *model;
@end
