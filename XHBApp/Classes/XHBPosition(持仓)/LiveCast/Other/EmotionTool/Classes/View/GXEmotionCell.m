//
//  GXEmotionCell.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXEmotionCell.h"
#import "GXButton.h"
#define toobarHeight 40
#define keyboardViewHeight 216
#define screenSize [UIScreen mainScreen].bounds.size
#define columCount 7
#define rowCount 3
#define notifyName @"GXEmotionBtnDidClicked"

@implementation GXEmotionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupUI{
    CGFloat width = screenSize.width / columCount;
    CGFloat height = (keyboardViewHeight - toobarHeight) / rowCount;
    for (int i = 0; i < 21; i++) {
        NSInteger col = i / columCount;
        NSInteger row = i % columCount;
        CGFloat x = row * width;
        CGFloat y = col * height;
        GXButton *btn = [[GXButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
- (void)setSectionEmotion:(NSArray *)sectionEmotion{
    _sectionEmotion = sectionEmotion;
    [self.contentView.subviews enumerateObjectsUsingBlock:^(GXButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.emotion = sectionEmotion[idx];
    }];
}
- (void)btnClicked:(GXButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:btn.emotion];
}
@end
