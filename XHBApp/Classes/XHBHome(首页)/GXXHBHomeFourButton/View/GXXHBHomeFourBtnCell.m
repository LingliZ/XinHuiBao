//
//  GXXHBHomeFourBtnCell.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeFourBtnCell.h"

@implementation GXXHBHomeFourBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatBtn];
    }
    return self;
}
-(void)creatBtn{
    NSArray *imgArr = @[@"about_us_pic",@"safe_guard_pic",@"special_offer_pic",@"trade_rules_pic"];
    NSArray *titleArr = @[@"关于我们",@"安全保障",@"优惠活动",@"交易规则"];
    for (int i = 0; i < imgArr.count; i++) {
        self.fourBtn = [GXXHBHomeFourBtn buttonWithType:UIButtonTypeCustom];
        self.fourBtn.frame = CGRectMake(GXScreenWidth / 4 * i, 0, GXScreenWidth / 4, HeightScale_IOS6(90));
        [self.fourBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [self.fourBtn setImage:[UIImage imageNamed: imgArr[i]] forState:UIControlStateNormal];
        self.fourBtn.tag = 200 + i;
        [self.fourBtn setBackgroundColor:[UIColor whiteColor]];
        [self.fourBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.fourBtn];
    }

}
-(void)clickBtn:(UIButton *)button{
    if (button.tag >= 200) {
        _btnClick(button.tag - 200);

    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
