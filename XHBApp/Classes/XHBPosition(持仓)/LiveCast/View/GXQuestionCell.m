//
//  GXQuestionCell.m
//  GXApp
//
//  Created by zhudong on 16/7/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXQuestionCell.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "GXTextAttachment.h"
#import "GXEmotion.h"
#import "YYLabel.h"
#import "YYText.h"
#import "YYImage.h"
#import "NSString+GXEmotAttributedString.h"
#import "GXLiveCastCommonSize.h"
#import "UIColor+Add.h"
#import "NSDateFormatter+GXDateFormatter.h"

#define CornerRadius WidthScale_IOS6(10)

@interface GXQuestionCell()
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic,strong) YYLabel *contentLable;
@end

@implementation GXQuestionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor getColor:@"F8F8F8"];
        self.backgroundColor = [UIColor getColor:@"F8F8F8"];
    }
    return self;
}
- (void)setupUI{
    UILabel *nameL = [[UILabel alloc] init];
    nameL.textColor = [UIColor getColor:@"000000"];
    nameL.font = smallFont;
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textColor = [UIColor getColor:@"9B9B9B"];
    timeL.font = smallerFont;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [nameL addGestureRecognizer:tapGesture];
    nameL.userInteractionEnabled = YES;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = CornerRadius;
    backgroundView.layer.masksToBounds = YES;
    
    YYLabel *contentLable = [[YYLabel alloc] init];
    contentLable.textColor = [UIColor getColor:@"000000"];
    contentLable.preferredMaxLayoutWidth = kScreenSize.width - 8 * kMargin;
    contentLable.numberOfLines = 0;
    
    self.timeLable = timeL;
    self.nameLable = nameL;
    self.contentLable = contentLable;
    
    [self.contentView addSubview:backgroundView];
    [self.contentView addSubview:nameL];
    [self.contentView addSubview:timeL];
    [self.contentView addSubview:self.contentLable];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(2 * kMargin);
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nameL);
        make.left.equalTo(nameL.mas_right).offset(kMargin);
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(2.5 *kMargin);
        make.left.equalTo(nameL).offset(1.5 * kMargin);
        make.bottom.equalTo(self.contentView).offset(-1.5 * kMargin);
    }];

    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2 * kMargin);
        make.top.equalTo(nameL.mas_bottom).offset(kMargin);
                make.right.equalTo(contentLable).offset(2 * kMargin);
                make.bottom.equalTo(self.contentView);
    }];
}
- (void)tapGesture{
    if (self.delegate) {
        self.delegate(self);
    }
}

- (void)setQuestion:(GSQuestion *)question{
    _question = question;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:question.questionTime];
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    formatter.dateFormat = @"HH:mm";
    self.timeLable.text = [formatter stringFromDate:date];
    self.nameLable.text = question.ownerName;
//    GXLog(@"****%@",question.questionContent);
    self.contentLable.attributedText = [NSString dealContentText:question.questionContent];
}

@end
