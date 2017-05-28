//
//  GXHomeTableViewCell.h
//  GXApp
//
//  Created by GXJF on 16/6/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXCommentModel.h"
@interface GXHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelRightLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iamgeWidthLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeftLine;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong)GXCommentModel *model;
@end
