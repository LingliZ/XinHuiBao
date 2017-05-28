//
//  AssetTableViewCell.h
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol assetTableviewCellDelegate <NSObject>

-(void)assetCellDelegateBtnClick:(UIButton *)sender;

@end

@interface AssetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_Tit1;

@property (weak, nonatomic) IBOutlet UILabel *lb_Tit2;
@property (weak, nonatomic) IBOutlet UIButton *btn_question;
- (IBAction)btn_ques_click:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *view_right2_lb;

@property (nonatomic,assign)id<assetTableviewCellDelegate>delegate;

@end
