//
//  GXXHBHomeAnalystCell.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeAnalystCell.h"
#import "GXAdaptiveHeightTool.h"
static NSInteger analystCount = 2;
@implementation GXXHBHomeAnalystCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization co
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createdUI];
    }
    return self;
}
-(void)createdUI{
    [self createdSepraterView];
    [self createdHeaderImgView];
    [self createdNameLabel];
    [self createdEvaluateLabel];
    [self createdRightLabel];
    [self createdBtns];
}
-(void)createdSepraterView{
//    analystCount
    for (NSInteger i = 0; i < analystCount; i++) {
        UIView *sepraterView = [[UIView alloc]init];
        sepraterView.backgroundColor = [UIColor orangeColor];
        if (i % 2 == 0) {
            sepraterView.frame = CGRectMake((GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2 * (i % 2) + 15, HeightScale_IOS6(15) + (i / 2) * HeightScale_IOS6(100),WidthScale_IOS6(3), HeightScale_IOS6(90));
        }else{
            sepraterView.frame = CGRectMake((GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2 * (i % 2) + 15 + WidthScale_IOS6(15), HeightScale_IOS6(15) + (i / 2) * HeightScale_IOS6(100),WidthScale_IOS6(3), HeightScale_IOS6(90));
        }
        [self.contentView addSubview:sepraterView];
    }
}
-(void)createdHeaderImgView{
//    NSMutableArray *headImgArray = [NSMutableArray arrayWithObjects:@"analyst_2",@"analyst_6",@"analyst_5",@"analyst_4", nil];
    NSMutableArray *headImgArray = [NSMutableArray arrayWithObjects:@"analyst_6",@"analyst_5", nil];
    for (NSInteger i = 0; i < headImgArray.count; i++) {
        UIImageView *headImgView = [[UIImageView alloc]init];
        headImgView.backgroundColor = [UIColor whiteColor];
        if (i % 2 == 0) {
            headImgView.frame = CGRectMake((GXScreenWidth - WidthScale_IOS6(41) - 30) / 2 * (i % 2) + 15 + WidthScale_IOS6(10), HeightScale_IOS6(35) + (i / 2) * HeightScale_IOS6(100), 50,50);
        }else{
            headImgView.frame = CGRectMake((GXScreenWidth - WidthScale_IOS6(41) - 30) / 2 * (i % 2) + 15 + WidthScale_IOS6(38), HeightScale_IOS6(35) + (i / 2) * HeightScale_IOS6(100), 50, 50);
        }
        headImgView.layer.cornerRadius = 25;
        headImgView.layer.masksToBounds = YES;
        [headImgView setImage:[UIImage imageNamed:headImgArray[i]]];
        [self.contentView addSubview:headImgView];
        
    }
}
-(void)createdNameLabel{
//    NSArray *nameArray = @[@"沈志宏",@"张建彬",@"刘猛",@"朱炜"];
    NSArray *nameArray = @[@"张建彬",@"刘猛"];
    CGFloat nameWith = 0;
    for (NSInteger i = 0; i < nameArray.count ; i++) {
        //nameWith = [GXAdaptiveHeightTool labelWidthFromString:nameArray[i] FontSize:GXHomeFontFit12];
        nameWith = [GXAdaptiveHeightTool labelWidthFromString:nameArray[i] FontSize:14];
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor whiteColor];
        if (i % 2 == 0) {

            nameLabel.frame = CGRectMake((GXScreenWidth - 130 - WidthScale_IOS6(55)) / 2 * (i % 2) + 65 + WidthScale_IOS6(20), HeightScale_IOS6(35) + (i / 2) * HeightScale_IOS6(100), nameWith, 12);
        }else{
            nameLabel.frame = CGRectMake((GXScreenWidth - 130 - WidthScale_IOS6(55)) / 2 * (i % 2) + 115 + WidthScale_IOS6(55), HeightScale_IOS6(35) + (i / 2) * HeightScale_IOS6(100), nameWith, 12);
        }
        nameLabel.text = nameArray[i];
        nameLabel.font = GXFONT_PingFangSC_Regular(14);
        nameLabel.textColor = [UIColor getColor:@"333333"];
        [self.contentView addSubview:nameLabel];
    }
}
-(void)createdEvaluateLabel{
//    NSArray *evaluateArray = @[@"高级策略分析师",@"首席宏观分析师",@"金牌分析师",@"首席技术分析师"];
    NSArray *evaluateArray = @[@"首席宏观分析师",@"金牌分析师"];
    CGFloat evaluateWidth = 0;
    for (NSInteger i = 0; i < evaluateArray.count; i++) {
        evaluateWidth = [GXAdaptiveHeightTool labelWidthFromString:evaluateArray[i] FontSize:GXHomeFontFit12];
        UILabel *evaluateLabel = [[UILabel alloc]init];
        evaluateLabel.backgroundColor = [UIColor whiteColor];
        if (i % 2 == 0) {
            evaluateLabel.frame = CGRectMake((GXScreenWidth - 130-5 - WidthScale_IOS6(55)) / 2 * (i % 2) + 65 + WidthScale_IOS6(20), HeightScale_IOS6(57) + (i / 2) * HeightScale_IOS6(100), evaluateWidth, 15);
        }else{
            evaluateLabel.frame = CGRectMake((GXScreenWidth - 130 -5- WidthScale_IOS6(55)) / 2 * (i % 2) + 115 + WidthScale_IOS6(55), HeightScale_IOS6(57) + (i / 2) * HeightScale_IOS6(100),evaluateWidth, 15);
        }
        evaluateLabel.text = evaluateArray[i];
        evaluateLabel.font = GXFONT_PingFangSC_Regular(GXHomeFontFit12);
        evaluateLabel.layer.borderWidth = 0.5;
        evaluateLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        evaluateLabel.layer.cornerRadius = 3;
        evaluateLabel.layer.masksToBounds = YES;
        evaluateLabel.textColor = [UIColor getColor:@"FF9957"];
        [self.contentView addSubview:evaluateLabel];
    }
    
}
-(void)createdRightLabel{
//    NSArray *rightArray = @[@"擅长:布林强盗系统",@"擅长:三八线理论",@"擅长: 形态异同战法",@"擅长: 三均线系统"];
    NSArray *rightArray = @[@"擅长:三八线理论",@"擅长: 形态异同战法"];
    CGFloat rihgtWidth = 0;
    for (NSInteger i = 0; i < rightArray.count; i++) {
        rihgtWidth = [GXAdaptiveHeightTool labelWidthFromString:rightArray[i] FontSize:GXHomeFontFit10];
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.backgroundColor = [UIColor whiteColor];
        if (i % 2 == 0) {
            rightLabel.frame = CGRectMake((GXScreenWidth - 130 - WidthScale_IOS6(55)) / 2 * (i % 2) + 65 + WidthScale_IOS6(20), HeightScale_IOS6(82) + (i / 2) * HeightScale_IOS6(100), rihgtWidth, 10);
        }else{
            rightLabel.frame = CGRectMake((GXScreenWidth - 130 - WidthScale_IOS6(55)) / 2 * (i % 2) + 115 + WidthScale_IOS6(55), HeightScale_IOS6(82) + (i / 2) * HeightScale_IOS6(100),rihgtWidth, 10);
        }
        rightLabel.text = rightArray[i];
        rightLabel.font = GXFONT_PingFangSC_Regular(GXHomeFontFit10);
       
        rightLabel.textColor = [UIColor getColor:@"333333"];
        NSMutableAttributedString*attrStr=[[NSMutableAttributedString alloc]initWithString:rightLabel.text];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor getColor:@"A5A5A5"] range:NSMakeRange(0, 3)];
        rightLabel.attributedText=attrStr;
        [self.contentView addSubview:rightLabel];

    }
}
-(void)createdBtns{
    for (NSInteger i = 0; i < analystCount; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor clearColor];
        if (i % 2 == 0) {
            button.frame = CGRectMake((GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2 * (i % 2) + 15, HeightScale_IOS6(15) + (i / 2) * HeightScale_IOS6(100),(GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2, HeightScale_IOS6(90));
        }else{
            button.frame = CGRectMake((GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2 * (i % 2) + 15 + WidthScale_IOS6(15), HeightScale_IOS6(15) + (i / 2) * HeightScale_IOS6(100),(GXScreenWidth - 30 - WidthScale_IOS6(15)) / 2, HeightScale_IOS6(90));
        }
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0xF8F8F8).CGColor;
        button.tag = 200 + i;
        [button addTarget:self action:@selector(analystClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];

    }
}
-(void)analystClickAction:(UIButton *)button{
    if (button.tag >= 200) {
        _analystBtnBlock(button.tag - 200);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
