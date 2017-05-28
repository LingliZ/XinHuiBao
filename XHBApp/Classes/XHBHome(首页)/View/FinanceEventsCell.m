//
//  FinanceEventsCell.m
//  GXApp
//
//  Created by GXJF on 16/6/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "FinanceEventsCell.h"

@implementation FinanceEventsCell

-(void)setModel:(GXFinanceDataModel *)model{
    if (_model != model) {
        _model = model;
        //时间
        NSString *dateStr = model.date;
        dateStr = [dateStr substringWithRange:NSMakeRange(4, 4)];
        NSString *dateStr1 = [dateStr substringWithRange:NSMakeRange(2, 2)];
        dateStr = [dateStr substringWithRange:NSMakeRange(0, 2)];
        dateStr = [dateStr stringByAppendingString:@"/"];
        dateStr = [dateStr stringByAppendingString:dateStr1];
        self.FEDateLabel.text = dateStr;
        //日期
        self.FEDateLabel.font = GXFONT_Helvetica_Light(GXFONT_SIZE10);
        //图片
        self.regionImgView.image = [UIImage imageNamed:model.region];
        
        self.timeLabel.text = model.time;
        self.timeLabel.font = GXFONT_Helvetica_Light(GXFONT_SIZE12);
        
        self.timeLabel.layer.borderWidth = 0.5;
        self.timeLabel.layer.cornerRadius = 10;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
        //标题
        self.quotaLabel.text = model.quota;
        self.quotaLabel.font = GXFONT_PingFangSC_Regular(GXDEFAULTFONT_SIZE);
        if ([model.former_value isEqualToString:@""] || [model.former_value isEqualToString:@"待公布"]) {
            self.former_valueLabel.text = @"---";
        }else{
            self.former_valueLabel.text = model.former_value;
        }
        self.former_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE12);
        self.predict_valueLabel.text = model.predict_value;
        self.predict_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE12);
        if ([model.public_value isEqualToString:@"待公布"]) {
            self.public_valueLabel.text = @"---";
        }else{
            self.public_valueLabel.text = model.public_value;

        }
        self.public_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE12);
        if ([model.weight isEqualToString:@"1"]) {
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
//            self.star2ImageView.image = [UIImage imageNamed:@"nilfivestar"];
//            self.star3ImageView.image = [UIImage imageNamed:@"nilfivestar"];
        }else if ([model.weight isEqualToString:@"2"]){
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
//            self.star3ImageView.image = [UIImage imageNamed:@"nilfivestar"];
        }else{
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
        }
    }
}
-(void)layoutSubviews{
    if (IS_IPHONE_5_OR_LESS) {
        //frame
        self.formatLabel.frame = CGRectMake(82, 45, 20, 12);
        self.former_valueLabel.frame = CGRectMake(self.formatLabel.frame.size.width + self.formatLabel.frame.origin.x, self.formatLabel.frame.origin.y, 30, 12);
        self.predicLabel.frame = CGRectMake(self.former_valueLabel.frame.origin.x + self.former_valueLabel.frame.size.width + 2, self.formatLabel.frame.origin.y, 20, 12);
        self.predict_valueLabel.frame = CGRectMake(self.predicLabel.frame.size.width + self.predicLabel.frame.origin.x, self.formatLabel.frame.origin.y, 30, 12);
        self.publicLabel.frame = CGRectMake(self.predict_valueLabel.frame.origin.x + self.predict_valueLabel.frame.size.width + 2, self.formatLabel.frame.origin.y, 20, 12);
        self.public_valueLabel.frame = CGRectMake(self.predicLabel.frame.size.width + self.predicLabel.frame.origin.x , self.formatLabel.frame.origin.y, 30, 12);
        //字体
        self.formatLabel.font =  GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        self.former_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        self.predicLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        self.predict_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        self.publicLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        self.public_valueLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
        //颜色
        
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.starTrailingLine.constant = WidthScale_IOS6(15);
    self.titleTrailingLine.constant = WidthScale_IOS6(15);
    self.timeLabelLeadingLine.constant = WidthScale_IOS6(15);
    self.FEDateLeadingLabel.constant = WidthScale_IOS6(15);
    if (IS_IPHONE_5) {
        self.QuotaLabelLeadingLine.constant = 2;
        self.regionImgLeadingLine.constant = 2;
        self.star1LeadingLine.constant = 0;
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
