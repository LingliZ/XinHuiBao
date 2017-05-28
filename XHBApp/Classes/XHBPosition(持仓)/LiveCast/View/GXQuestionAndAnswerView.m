//
//  GXQuestionAndAnswerView.m
//  GXApp
//
//  Created by zhudong on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXQuestionAndAnswerView.h"
#import "GXTextView.h"
#import "GXEmotionKeyboardView.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#import "GXQuestionCell.h"
#import "GXAskView.h"
#import "GXLiveCastCommonSize.h"
#import "NSMutableArray+GXQuestionArray.h"
#import "NSDateFormatter+GXDateFormatter.h"

#define bottomViewH 49
#define margin 8
#define screenSize [UIScreen mainScreen].bounds.size
#define keyBoardH 216
#define notifyName @"GXEmotionBtnDidClicked"
#define questionCell @"GXQuestionCell"
#define answerCell @"GXAnswerCell"
#define SpecialTextColor [UIColor colorWithRed:80 / 255.0 green:140 / 255.0 blue:210 / 255.0 alpha:1]

@interface GXQuestionAndAnswerView ()<YYTextViewDelegate,UITableViewDelegate,UITableViewDataSource,GXAskViewDelegate>
{
    MBProgressHUD *_progressHUD;
}
@property (nonatomic,weak) GXTextView *textView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSString *questionId;
@end
@implementation GXQuestionAndAnswerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor getColor:@"F8F8F8"];
    }
    return self;
}
- (void)setupUI{
     GXAskView *askView = [[GXAskView alloc] initWithFrame:CGRectZero];
    [self addSubview:askView];
    [askView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@bottomViewH);
    }];
    askView.delegate = self;
    self.textView = askView.textView;
    
    UITableView *tableV = [[UITableView alloc] init];
    [self addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(askView.mas_top);
    }];
    tableV.delegate = self;
    tableV.dataSource = self;
    
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.backgroundColor = [UIColor getColor:@"F8F8F8"];
    self.tableView = tableV;
    UIView *view = [[UIView alloc] init];
    tableV.tableFooterView = view;

    tableV.rowHeight = UITableViewAutomaticDimension;
    tableV.estimatedRowHeight = 100;
    [tableV registerClass:[GXQuestionCell class] forCellReuseIdentifier:questionCell];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tableV addGestureRecognizer:tapGesture];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.questionsArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXQuestionCell *questionC = [tableView dequeueReusableCellWithIdentifier:questionCell forIndexPath:indexPath];
    GSQuestion *question = [self.questionsArrayM newObjectAt:indexPath.row];
    if (question == nil) {
        [questionC.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return questionC;
    }
    questionC.selectionStyle = UITableViewCellSelectionStyleNone;
    questionC.question = question;
    __weak typeof(self) weakSelf = self;
    questionC.delegate = ^(GXQuestionCell *cell){
        weakSelf.textView.text = [NSString stringWithFormat:@"@%@ ",cell.nameLable.text];
        [weakSelf.textView becomeFirstResponder];
    };
    return  questionC;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [super hitTest:point withEvent:event];
}
//手动拖拽开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.questionViewDelegate) {
        self.questionViewDelegate(false);
    }
}

//手动拖拽结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.questionViewDelegate) {
        self.questionViewDelegate(true);
    }
}


#pragma mark - GXAskViewDelegate
- (void)sendBtnDidClick:(GXAskView *)askView{
    NSString *content = askView.textView.fullText;
    if (content.length > 0) {
        [self.broadcastManager askQuestion:content];
        askView.textView.text = nil;
        [askView.textView endEditing:YES];
    }else{
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
    }
}
- (void)tapGesture:(UIGestureRecognizer *)tapGesture{
    [self.textView endEditing:YES];
}

#pragma mark - refreshQuestionData
- (void)setQuestionsArrayM:(NSMutableArray *)questionsArrayM{
    _questionsArrayM = questionsArrayM;
    if(questionsArrayM.count > 30){
        NSRange range = NSMakeRange(0, questionsArrayM.count - 30);
        [_questionsArrayM removeObjectsInRange:range];
    }
    [self.tableView reloadData];
    if (questionsArrayM.count > 3) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:(_questionsArrayM.count - 1) inSection:0];
        if ([self.questionId isEqualToString:((GSQuestion *)questionsArrayM.lastObject).questionID]) {
            return;
        }
        self.questionId = ((GSQuestion *)questionsArrayM.lastObject).questionID;
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
    if (self.questionsArrayM.count == 0) {
        UILabel *tipL = [[UILabel alloc] init];
        tipL.text = @"暂无最新消息";
        tipL.textColor = GXGrayColor;
        tipL.textAlignment = NSTextAlignmentCenter;
        tipL.frame = CGRectMake(0, 0, screenSize.width, 50);
        self.tableView.backgroundView = tipL;
        return ;
    }else{
        self.tableView.backgroundView = nil;
    }
}

@end
