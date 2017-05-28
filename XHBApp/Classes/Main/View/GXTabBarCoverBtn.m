
//
//  GXTabBarCoverBtn.m
//  GXApp
//
//  Created by zhudong on 16/7/25.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabBarCoverBtn.h"

@interface GXTabBarCoverBtn ()
@property (nonatomic,strong) UIButton *emptyButton;
@end
@implementation GXTabBarCoverBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:emptyBtn];
        self.emptyButton = emptyBtn;
        [self bringSubviewToFront:emptyBtn];
        emptyBtn.backgroundColor = [UIColor clearColor];
        CGFloat width = GXScreenWidth / 5 - 20;
        CGFloat y =  -20;
        CGRect btnFrame = CGRectMake((width + 20) * 2 + 10, y, width, -y + 20);
        emptyBtn.frame = btnFrame;
        @weakify(self);
        [[emptyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.coverBtnDelegate) {
                [self.coverBtnDelegate tabBarCoverBtnDidClick:self];
            }
        }];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO) {
        CGPoint newP = [self convertPoint:point toView:self.emptyButton];
        if ( [self.emptyButton pointInside:newP withEvent:event]) {
            return self.emptyButton;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}


@end
