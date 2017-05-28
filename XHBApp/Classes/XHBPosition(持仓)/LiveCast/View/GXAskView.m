//
//  GXAskView.m
//  GXApp
//
//  Created by zhudong on 16/8/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAskView.h"
#import "GXLiveCastCommonSize.h"
#import "GXEmotionKeyboardView.h"

#define keyBoardH 216
#define notifyName @"GXEmotionBtnDidClicked"
#define sendBtnClickNotify @"sendBtnClick"
#define SeperateHeight 0.5
#define borderWidth 0.5
#define SeperatorColor [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1]
#define KeyboardBorderColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1]

@interface GXAskView ()<YYTextViewDelegate>
@property (nonatomic,strong) UIButton *keyboardBtn;
@property (nonatomic,assign) BOOL isEmot;
@property (nonatomic,strong) UIView *superView;
@end
@implementation GXAskView
- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
//        [self initialDeal];
        self.backgroundColor = [UIColor getColor:@"FFFFFF"];
        self.isEmot = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialDeal];
        [self setupUI];
    }
    return self;
}
- (void)initialDeal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionBtnDidClicked:) name:notifyName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBtnDidClicked) name:sendBtnClickNotify object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sendBtnClickNotify object:nil];
}
- (void)sendBtnDidClicked{
    if ([self.delegate respondsToSelector:@selector(sendBtnDidClick:)]) {
        [self.delegate sendBtnDidClick:self];
    }
}
- (void)emotionBtnDidClicked:(NSNotification *)notify{
    GXEmotion *emotion = notify.object;
    [self.textView insertEmotion:emotion];
}
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify{
    NSDictionary *keyboardDict = notify.userInfo;
    CGRect keyboardFrame = [keyboardDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ;
    CGFloat offsetY = keyboardFrame.origin.y - kScreenSize.height;
    if (offsetY == 0) {
        if (self.isEmot) {
            [self changeEmot];
        }
    }
    if ([self.superview isKindOfClass:NSClassFromString(@"GXQuestionAndAnswerView")]) {
        return;
    }
    self.superview.transform = CGAffineTransformMakeTranslation(0, offsetY);
}

- (void)setupUI{
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = SeperatorColor.CGColor;
    layer.frame = CGRectMake(0, 0, kScreenSize.width, SeperateHeight);
    [self.layer addSublayer:layer];
    
    GXTextView *textView = [[GXTextView alloc] init];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE15);
    [self addSubview:textView];
//    textView.autocorrectionType =  UITextAutocorrectionTypeNo;
    UIButton *keyboardBtn = [[UIButton alloc] init];
    [keyboardBtn setImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    [self addSubview:keyboardBtn];
    [keyboardBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardBtn = keyboardBtn;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((0.5 * kMargin + 1.5));
        make.left.equalTo(self).offset(2 * kMargin);
        make.bottom.equalTo(self).offset((- 0.5 * kMargin - 1.5));
        make.right.equalTo(keyboardBtn.mas_left);
        
    }];

    [UIView setBorForView:textView withWidth:borderWidth andColor:KeyboardBorderColor andCorner:1.5];
    self.textView = textView;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.textView addGestureRecognizer:tapGesture];
    [keyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.mas_right).offset(WidthScale_IOS6(-27));
//        make.right.equalTo(self).offset(- 2 * kMargin);
        make.width.equalTo(@WidthScale_IOS6(54));
    }];

}
- (void)tapGesture{
    [self.textView becomeFirstResponder];
    if (self.isEmot == NO) return;
    NSString *textStr = self.textView.fullText;
    if (textStr.length > 7) {
        NSString *str = [textStr substringWithRange:NSMakeRange(textStr.length - 7, 7)];
        if ([str isEqualToString:@"[/EMOT]"]) {
            [self btnClicked];
        }
    }else if (textStr.length == 0){
        [self btnClicked];
    }
}

#pragma mark - YYTextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnDidClicked];
        return NO;
    }
    return YES;
}
- (void)changeEmot{
    if (self.textView.inputView == nil) {
        GXEmotionKeyboardView *keyBoardView = [[GXEmotionKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 0, keyBoardH)];
        self.textView.inputView = keyBoardView;
        [self.keyboardBtn setImage:[UIImage imageNamed:@"board_system"] forState:
         UIControlStateNormal];
        self.isEmot = YES;
    }else{
        self.textView.inputView = nil;
        [self.keyboardBtn setImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
        self.isEmot = NO;
    }
}
- (void)btnClicked{
//    if (self.textView.inputView == nil) {
//        GXEmotionKeyboardView *keyBoardView = [[GXEmotionKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 0, keyBoardH)];
//        self.textView.inputView = keyBoardView;
//        [self.keyboardBtn setImage:[UIImage imageNamed:@"board_system"] forState:
//         UIControlStateNormal];
//        self.isEmot = YES;
//    }else{
//        self.textView.inputView = nil;
//        [self.keyboardBtn setImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
//        self.isEmot = NO;
//    }
    [self changeEmot];
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}
@end
