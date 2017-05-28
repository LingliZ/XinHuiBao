//
//  XHBTradeTextFieldView.h
//  XHBApp
//
//  Created by shenqilong on 17/3/1.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, tradeTfStyle) {
    tfNothing,
    haveSeleButton//带对号
};


@protocol tradeTextFieldDelegate <NSObject>

-(void)tradeTextField:(UITextField *)tf;

@end
@interface XHBTradeTextFieldView : UIView
@property(nonatomic,assign)id<tradeTextFieldDelegate>delegate;
- (instancetype)initWithTfText:(NSString *)str y:(float)y tradeTfStyle:(tradeTfStyle)type;

@property(nonatomic,assign)int tfTag;
@property(nonatomic,weak)UITextField *customTf;
@property(nonatomic,copy)NSString *tradeCode;



@property(nonatomic,weak)UIButton *cusSelectButton;
-(void)seleButton:(UIButton *)sender;

@property(nonatomic,copy)NSString *tfActivateValue;//设置tf激活时默认显示的内容

@end
