//
//  GXVerButton.m
//  GXApp
//
//  Created by 王振 on 16/7/26.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXVerButton.h"

@implementation GXVerButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
