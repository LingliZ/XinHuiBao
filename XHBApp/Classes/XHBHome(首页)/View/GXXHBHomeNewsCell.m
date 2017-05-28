//
//  GXXHBHomeNewsCell.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeNewsCell.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXXHBHomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    [self.contentView addSubview:self.titleLabel];
//    self.descripLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    [self.contentView addSubview:self.descripLabel];
//    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    [self.contentView addSubview:self.timeLabel];
    // Initialization code
}
-(void)setModel:(GXXHBHomeNewsModel *)model{
    if (_model != model) {
        _model = model;
        self.titleLabel.text = self.model.title;
        self.descripLabel.text = self.model.metadesc;
        self.timeLabel.text = self.model.created;
        self.descripLabel.numberOfLines = 0;
        CGFloat desWidth = [GXAdaptiveHeightTool labelWidthFromString:self.model.metadesc FontSize:12];
        if (desWidth <= GXScreenWidth - 30) {
            self.isOneLineWidth = YES;
        }else{
            self.isOneLineWidth = NO;
        }
    }
}
-(void)layoutSubviews{
    if (self.isOneLineWidth) {
        self.titleLabel.frame = CGRectMake(15, 10, GXScreenWidth - 30, 19);
        self.descripLabel.frame = CGRectMake(15, 19 + self.titleLabel.frame.origin.y, GXScreenWidth - 30, 16);
        self.timeLabel.frame = CGRectMake(15, 16 + self.descripLabel.frame.origin.y, GXScreenWidth - 30, 12);
        self.descripLabel.numberOfLines = 1;

    }else{
        self.titleLabel.frame = CGRectMake(15, 10, GXScreenWidth - 30, 19);
        self.descripLabel.frame = CGRectMake(15, 48 + self.titleLabel.frame.origin.y, GXScreenWidth - 30, 32);
        self.timeLabel.frame = CGRectMake(15, 32 + self.descripLabel.frame.origin.y, GXScreenWidth - 30, 12);
        self.descripLabel.numberOfLines = 2;

    }
    //self.titleLabel.numberOfLines = 0;
    //    self.createdLabel.frame = CGRectMake(15, titleHeight + self.titleLabel.frame.origin.y + 5, 200, 12);
    self.titleLabel.font = GXFONT_PingFangSC_Regular(16);
    self.titleLabel.textColor = [UIColor getColor:@"333333"];
    self.descripLabel.font = GXFONTPingFangSC_Regular(14);
    self.descripLabel.textColor = [UIColor getColor:@"A5A5A5"];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
