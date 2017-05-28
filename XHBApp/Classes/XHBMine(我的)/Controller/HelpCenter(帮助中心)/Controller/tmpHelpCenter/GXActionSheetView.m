//
//  GXActionSheetView.m
//  GXApp
//
//  Created by 王振 on 16/7/26.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXActionSheetView.h"

#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f

#define ActionSheetW [[UIScreen mainScreen] bounds].size.width
#define ActionSheetH [[UIScreen mainScreen] bounds].size.height

@interface GXActionSheetView ()
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property (nonatomic,strong) NSArray *shareBtnTitleArray;
@property (nonatomic,strong) NSArray *shareBtnImgArray;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) UIView *topsheetView;
@property (nonatomic,strong) UIView *topsheetViewOne;
@property (nonatomic,strong) UIScrollView *scrollowView;
@property (nonatomic,strong) UIButton *cancelBtn;

//头部提示文字Label
@property (nonatomic,strong) UILabel *proL;

@property (nonatomic,copy) NSString *protext;

@property (nonatomic,assign) ShowType showtype;
@end



@implementation GXActionSheetView

- (id)initWithShareHeadOprationWith:(NSArray *)titleArray andImageArry:(NSArray *)imageArr andProTitle:(NSString *)protitle and:(ShowType)type
{
    self = [super init];
    if (self) {
        self.shareBtnImgArray = imageArr;
        self.shareBtnTitleArray = titleArray;
        _protext = protitle;
        _showtype = type;
        
        self.frame = CGRectMake(0, 0, ActionSheetW, ActionSheetH);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (type == ShowTypeIsShareStyle) {
            [self loadUiConfig];
        }
        else if (type == ShowTypeIsActionSheetStyle)
        {
            [self loadActionSheetUi];
        }
        else
        {
            [self loadOneLineUi];
        }
    }
    return self;
}

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor
{
    [_cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}
- (void)setProStr:(NSString *)proStr
{
    _proL.text = proStr;
}

- (void)setOtherBtnColor:(UIColor *)otherBtnColor
{
    for (id res in _backGroundView.subviews) {
        if ([res isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)res;
            if (button.tag>=100) {
                [button setTitleColor:otherBtnColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setOtherBtnFont:(NSInteger)otherBtnFont
{
    for (id res in _backGroundView.subviews) {
        if ([res isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)res;
            if (button.tag>=100) {
                button.titleLabel.font = [UIFont systemFontOfSize:otherBtnFont];
            }
        }
    }
}

-(void)setProFont:(NSInteger)proFont
{
    _proL.font = [UIFont systemFontOfSize:proFont];
}

- (void)setCancelBtnFont:(NSInteger)cancelBtnFont
{
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelBtnFont];
}

- (void)setDuration:(CGFloat)duration
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:duration];
}

//系统每行模式
- (void)loadActionSheetUi
{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.cancelBtn];
    if (_protext.length) {
        [_backGroundView addSubview:self.proL];
    }
    
    for (NSInteger i = 0; i<_shareBtnTitleArray.count; i++) {
        GXVerButton *button =[GXVerButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetHeight(_proL.frame)+50*i, CGRectGetWidth(_backGroundView.frame), 50);
        [button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundView addSubview:button];
    }
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _backGroundView.frame = CGRectMake(0, ActionSheetH-(_shareBtnTitleArray.count*50+50)-7-(_protext.length==0?0:45), ActionSheetW, _shareBtnTitleArray.count*50+50+7+(_protext.length==0?0:45));
    }];
    
}

//九宫格style
- (void)loadUiConfig
{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.topsheetView];
    [_backGroundView addSubview:self.cancelBtn];
    
    _LXActionSheetHeight = CGRectGetHeight(_proL.frame) + 7;
    
    for (NSInteger i = 0; i<_shareBtnImgArray.count; i++)
    {
        GXActionButton *button = [GXActionButton buttonWithType:UIButtonTypeCustom];
        if (_shareBtnImgArray.count%3 == 0) {
            button.frame = CGRectMake(_backGroundView.bounds.size.width/3*(i%3) + 7, _LXActionSheetHeight+(i/3)*100, _backGroundView.bounds.size.width/3 - 14, 70);
        }
        else
        {
            button.frame = CGRectMake(_backGroundView.bounds.size.width/4*(i%4) + 7, _LXActionSheetHeight+(i/4)*100, _backGroundView.bounds.size.width/4 - 14, 70);
        }
        
        [button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_shareBtnImgArray[i]] forState:UIControlStateNormal];
        button.tag = 200+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topsheetView addSubview:button];
    }
    
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _backGroundView.frame = CGRectMake(7, ActionSheetH-CGRectGetHeight(_backGroundView.frame), ActionSheetW-14, CGRectGetHeight(_backGroundView.frame));
    }];
    
}

//一行style
- (void)loadOneLineUi{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.scrollowView];
    [self.scrollowView addSubview:self.topsheetViewOne];
    [_backGroundView addSubview:self.cancelBtn];
    
    _LXActionSheetHeight = CGRectGetHeight(_proL.frame);
    
    for (NSInteger i = 0; i<_shareBtnImgArray.count; i++)
    {
        GXActionButton *button = [GXActionButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_backGroundView.bounds.size.width/4.5 * i, _LXActionSheetHeight + 18 , _backGroundView.bounds.size.width/4, 86);
        
        [button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_shareBtnImgArray[i]] forState:UIControlStateNormal];
        button.tag = 200+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topsheetViewOne addSubview:button];
    }
    
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _backGroundView.frame = CGRectMake(0, ActionSheetH-CGRectGetHeight(_backGroundView.frame), ActionSheetW, CGRectGetHeight(_backGroundView.frame));
    }];
    
    
}


//分享按钮回调
- (void)BtnClick:(UIButton *)btn
{
    [self tappedCancel];
    if (btn.tag<200) {
        _btnClick(btn.tag-100);
    }
    else
    {
        _btnClick(btn.tag-200);
    }
}

- (void)noTap
{
}

#pragma mark -------- getter
- (UIView *)backGroundView
{
    if (_backGroundView == nil) {
        _backGroundView = [[UIView alloc] init];
        
        if (_showtype == ShowTypeIsShareStyle) {
            if (_shareBtnImgArray.count<5) {
                _backGroundView.frame = CGRectMake(7, ActionSheetH, ActionSheetW - 14, 64+(_protext.length==0?0:45)+76+44);
            }else
            {
                NSInteger index;
                if (_shareBtnTitleArray.count%4 ==0) {
                    index =_shareBtnTitleArray.count/4;
                }
                else
                {
                    index = _shareBtnTitleArray.count/4 + 1;
                }
                _backGroundView.frame = CGRectMake(7, ActionSheetH, ActionSheetW - 14, 64+(_protext.length==0?0:45)+76*index+64);
            }
        }else if (_showtype == ShowTypeIsActionSheetStyle)
        {
            _backGroundView.frame = CGRectMake(0, ActionSheetH, ActionSheetW, _shareBtnTitleArray.count*50+50+7+(_protext.length==0?0:45));
            _backGroundView.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
            
        }else
        {
            
            _backGroundView.frame = CGRectMake(0, ActionSheetH, ActionSheetW , 64+(_protext.length==0?0:45)+72);
            _backGroundView.backgroundColor = [UIColor whiteColor]
            ;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetHeight(_backGroundView.frame)-49, _backGroundView.frame.size.width - 60, 0.5)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
            [_backGroundView addSubview:lineView];
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTap)];
        [_backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
}
//scrollow
-(UIScrollView *)scrollowView{
    if (_scrollowView == nil) {
        _scrollowView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame)-50)];
        _scrollowView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 4.5 * 8 + 20, 0);
        _scrollowView.showsVerticalScrollIndicator = NO;
        _scrollowView.showsHorizontalScrollIndicator = NO;
        _scrollowView.bounces = NO;
    }
    return _scrollowView;
}
//展示一行的视图
-(UIView *)topsheetViewOne{
    if (_topsheetViewOne == nil) {
        _topsheetViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame) / 4.5 * 8 + 20, CGRectGetHeight(_backGroundView.frame)-50)];
       // _topsheetViewOne.backgroundColor = UIColorFromRGB(0xF8F8F8);
        //_topsheetViewOne.backgroundColor = [UIColor colorWithRed:1.000 green:0.259 blue:1.000 alpha:1.000];

        //        if (_protext.length) {
        //            [_topsheetViewOne addSubview:self.proL];
        //        }
        
    }
    return _topsheetViewOne;
}

//展示分享按钮的视图
- (UIView *)topsheetView
{
    if (_topsheetView == nil) {
        _topsheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame)-64)];
        _topsheetView.backgroundColor = [UIColor whiteColor];
        _topsheetView.layer.cornerRadius = 4;
        _topsheetView.clipsToBounds = YES;
        if (_protext.length) {
            [_topsheetView addSubview:self.proL];
        }
    }
    return _topsheetView;
}

//分享到label
- (UILabel *)proL
{
    if (_proL == nil) {
        _proL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), 45)];
        _proL.text = @"分享到";
        _proL.textColor = [UIColor grayColor];
        _proL.backgroundColor = [UIColor whiteColor];
        _proL.textAlignment = NSTextAlignmentCenter;
    }
    return _proL;
}
//取消按钮
- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_showtype == ShowTypeIsShareStyle) {
            _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-57, CGRectGetWidth(_backGroundView.frame), 50);
            _cancelBtn.layer.cornerRadius = 4;
            _cancelBtn.clipsToBounds = YES;
            _cancelBtn.backgroundColor = [UIColor whiteColor];

        }
        else if (_showtype == ShowTypeIsActionSheetStyle)
        {
            _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-50, CGRectGetWidth(_backGroundView.frame), 50);
        }
        else{
            _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-49, CGRectGetWidth(_backGroundView.frame), 49);
            _cancelBtn.layer.cornerRadius = 4;
            _cancelBtn.clipsToBounds = YES;
         //   [_cancelBtn setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            _cancelBtn.titleLabel.font = GXFONTPingFangSC_Regular(GXFONT_SIZE17);
            
        }
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithWhite:0.290 alpha:1.000] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
//取消按钮事件
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, ActionSheetH, ActionSheetW, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
