//
//  GXEmotionKeyboardView.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXEmotionKeyboardView.h"
#import "GXEmotionPackage.h"
#import "GXEmotionCollectionView.h"
#define toobarHeight 40
#define baseTag 100
#define btnWidth 70

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"          // 布局框架



@interface GXEmotionKeyboardView ()
@property (nonatomic,strong) UIPageControl *pageC;
@end
@implementation GXEmotionKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor getColor:@"FFFFFF"];
    }
    return self;
}
- (void)setupUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *sendImage = [UIImage imageNamed:@"send"];
    [btn setBackgroundImage:sendImage forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"send_disabled"] forState:UIControlStateDisabled];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btn addTarget:self action:@selector(btnCliked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.equalTo(@toobarHeight);
        make.width.equalTo(@btnWidth);
    }];
    
    GXEmotionCollectionView *collectionV = [[GXEmotionCollectionView alloc] initWithFrame:CGRectZero];
    [self addSubview:collectionV];
    collectionV.packages = [GXEmotionPackage loadPackages];
    [collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(- toobarHeight);
    }];
    collectionV.scroolDelegate = ^(NSInteger index){
        self.pageC.currentPage = index;
    };
    
    self.pageC.numberOfPages = collectionV.packages.count;
    [self.pageC setValue:[UIImage imageNamed:@"active_page_image"] forKey:@"_pageImage"];
    [self.pageC setValue:[UIImage imageNamed:@"inactive_page_image"] forKey:@"_currentPageImage"];
    [self.pageC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(collectionV).offset(10);
    }];
}

- (void)btnCliked:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:sendBtnClickNotify object:nil];
}
- (UIPageControl *)pageC{
    if (_pageC == nil) {
        _pageC = [[UIPageControl alloc] init];
        _pageC.userInteractionEnabled = false;
        [self addSubview:_pageC];
    }
    return _pageC;
}
@end
