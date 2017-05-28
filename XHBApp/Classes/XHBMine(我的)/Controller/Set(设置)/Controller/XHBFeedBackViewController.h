//
//  XHBFeedBackViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/20.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBFeedBackViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_BG;

@property (weak, nonatomic) IBOutlet UITextView *TV_content;//提交内容
@property (weak, nonatomic) IBOutlet UILabel *label_numbersOfContent;//字数统计
@property (weak, nonatomic) IBOutlet UILabel *label_placeholder;
@property (weak, nonatomic) IBOutlet UIButton *btn_commite;//提交按钮



@end
