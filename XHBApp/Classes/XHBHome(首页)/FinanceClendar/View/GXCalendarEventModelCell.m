//
//  GXCalendarEventModelCell.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarEventModelCell.h"
#import "UIImageView+WebCache.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXCalendarEventModelCell

-(void)setModel:(GXCalendarEventModel *)model{
    if (_model != model) {
        _model = model;
        self.timeLabel.text = self.model.time;
        self.eventLabel.text =[NSString stringWithFormat:@"【事件】%@",self.model.event];
        self.countryLabel.text = self.model.country;
        self.areaLabel.text = self.model.area;
        
        self.star5ImageView.image = [UIImage imageNamed:@""];
        self.star4ImageView.image = [UIImage imageNamed:@""];
        self.star3ImageView.image = [UIImage imageNamed:@""];
        self.star2ImageView.image = [UIImage imageNamed:@""];
        self.star1ImageView.image = [UIImage imageNamed:@""];
        
        if ([self.model.importance isEqualToString:@"1"]) {
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"2"]){
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"3"]){
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"4"]){
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }else{
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
