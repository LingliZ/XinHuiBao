//
//  GXQuestionAndAnswerView.h
//  GXApp
//
//  Created by zhudong on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface GXQuestionAndAnswerView : UIView
@property (nonatomic,strong) NSMutableArray *questionsArrayM;
@property (strong, nonatomic) GSBroadcastManager *broadcastManager;
@property (nonatomic,copy) void (^questionViewDelegate)(BOOL isOpen);
@end
