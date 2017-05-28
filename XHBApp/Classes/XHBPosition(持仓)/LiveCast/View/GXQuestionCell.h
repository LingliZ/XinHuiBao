//
//  GXQuestionCell.h
//  GXApp
//
//  Created by zhudong on 16/7/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface GXQuestionCell : UITableViewCell
@property (nonatomic,strong) GSQuestion *question;
@property (nonatomic,copy) void (^delegate)(GXQuestionCell *cell);
@property (nonatomic,strong) UILabel *nameLable;
@end
