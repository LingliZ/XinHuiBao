//
//  GXXHBSpecialActivityCell.m
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBSpecialActivityCell.h"

@implementation GXXHBSpecialActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(GXXHBHomeCycleModel *)model{
    if (_model != model) {
        _model = model;
        self.timeLabel.text = self.model.created;
        [UIView setBorForView:self.timeLabel withWidth:0 andColor:nil andCorner:2];
        self.titleLabel.text = self.model.name ;
        self.detialLabel.text = @"查看详情";
        //self.bannerImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.imgurl]]];
        [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgurl] placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
