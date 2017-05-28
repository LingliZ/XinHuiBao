//
//  ReusableHeaderView.m
//  GXApp
//
//  Created by GXJF on 16/6/30.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "ReusableHeaderView.h"

@interface ReusableHeaderView ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *separateView;
@end

@implementation ReusableHeaderView

+ (instancetype)headerViewWihtTableView:(UITableView *)tableView{
    static NSString *ID = @"header";
    ReusableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[ReusableHeaderView alloc]initWithReuseIdentifier:ID];
    }
    
    return header;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.separateView = [[UIView alloc]init];
        [self.contentView addSubview:self.separateView];
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        //[self.moreBtn setTitleColor:UIColorFromRGB(0x4A4A4A) forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"homepage_arrowhead_right"] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:GXRGBColor(51, 51, 51) forState:UIControlStateNormal];
        [self.moreBtn setShowsTouchWhenHighlighted:YES];
        self.moreBtn.titleLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE12);
        [self.moreBtn addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
    }return self;
}
- (void)moreButtonAction{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickMoreBtn:)]) {
        [self.delegate headerViewDidClickMoreBtn:self.moreBtn.tag];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.separateView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 8);
    self.separateView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.titleLabel.frame = CGRectMake(15, 10, 100, self.contentView.frame.size.height - 10);
    self.titleLabel.font = GXFONT_PingFangSC_Regular(16);
    self.titleLabel.textColor = [UIColor getColor:@"333333"];
    self.moreBtn.frame = CGRectMake(self.contentView.frame.size.width - WidthScale_IOS6(165), 10, WidthScale_IOS6(165), self.contentView.frame.size.height - 10);
    //self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.moreBtn setImagePosition:GXImagePositionRight spacing:WidthScale_IOS6(125)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -110)];
}
- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
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
