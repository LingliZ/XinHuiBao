//
//  GXHomeTableViewCell.m
//  GXApp
//
//  Created by GXJF on 16/6/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXHomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXHomeTableViewCell

-(void)setModel:(GXCommentModel *)model{
    if (_model != model) {
        _model = model;
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        //[format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [format setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
        NSDate *getDate = [format dateFromString:model.created];
        //NSTimeInterval tiemSeconds = [getDate timeIntervalSince1970];
        NSString *str = [GXAdaptiveHeightTool compareCurrentTime:getDate];
        self.titleLabel.text = _model.title;
        self.descriptionLabel.text = self.model.metadesc;
        self.createdLabel.text = str;
        self.authorLabel.text = _model.author;
        //[self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgurl] placeholderImage:[UIImage imageNamed:@"information_placeholder_pic"]];
        CGFloat titleHeight = [GXAdaptiveHeightTool lableHeightWithText:self.model.title font:self.titleLabel.font Width:20];
        self.titleLabel.frame = CGRectMake(10, 10, GXScreenWidth - 10, titleHeight);
        self.authorLabel.frame = CGRectMake(10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y , 100, 21);
        self.createdLabel.frame = CGRectMake(GXScreenWidth - 10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y , 150, 21);
        self.model.cellHeight = titleHeight + self.authorLabel.frame.size.height;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.titleLabelRightLine.constant = WidthScale_IOS6(15);
//    self.titleLabelTopLine.constant = HeightScale_IOS6(15);
//    self.timeBottomLine.constant = HeightScale_IOS6(15);
//    self.iamgeWidthLine.constant = WidthScale_IOS6(100);
//    self.imgTopLine.constant = HeightScale_IOS6(15);
//    self.imgBottomLine.constant = HeightScale_IOS6(15);
//    self.imgLeftLine.constant = 15;
    
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
