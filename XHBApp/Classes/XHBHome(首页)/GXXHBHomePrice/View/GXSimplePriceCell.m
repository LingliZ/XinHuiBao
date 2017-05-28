//
//  GXSimplePriceCell.m
//  GXApp
//
//  Created by 王淼 on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXSimplePriceCell.h"





@interface GXSimplePriceCell ()


@property (nonatomic, strong) UILabel *nameLabel; // 名称

@property (nonatomic, strong) UILabel *priceLabel; //  价格

@property (nonatomic, strong) UILabel *rateLabel; // 涨幅

@property (nonatomic, strong) UIImageView *spImageview; // 分割线

@end

@implementation GXSimplePriceCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
        
    }return self;
}

-(void) layoutSubviews{
  
    self.nameLabel.frame=CGRectMake(0, (HeightScale_IOS6(90) - 62) / 2, self.frame.size.height, 12);
    self.nameLabel.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE12);
    self.priceLabel.frame=CGRectMake(0, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, self.frame.size.height, 20);
    self.priceLabel.font = GXFONT_PingFangSC_Regular(18);
    self.rateLabel.frame=CGRectMake(0, self.priceLabel.frame.origin.y + self.priceLabel.frame.size.height + 10, self.frame.size.height, 10);
    self.rateLabel.font = GXFONT_PingFangSC_Light(GXFONT_SIZE10);
    self.spImageview.frame=CGRectMake(self.frame.size.height-0.5, 0,0.5, self.frame.size.width);
    
    
}

-(void)setModel:(PriceMarketModel *)model{
    
    self.nameLabel.text=model.name;
    
    self.priceLabel.text=model.sell;
    self.priceLabel.textColor=model.increaseBackColor;
    
    self.rateLabel.text=model.increasePercentage;
    self.rateLabel.textColor=model.increaseBackColor;
    
}





-(void) createUI{
    
    
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = GXRGBColor(51, 51, 51);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    
    
    self.priceLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    
     self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.priceLabel];
   
    
    self.rateLabel=[[UILabel alloc] initWithFrame:CGRectZero];

     self.rateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rateLabel];
    
    self.spImageview=[[UIImageView alloc] initWithFrame:CGRectZero];
                      
    self.spImageview.backgroundColor=UIColorFromRGB(0xEEEEEE);
    [self addSubview:self.spImageview];
    

}


@end
