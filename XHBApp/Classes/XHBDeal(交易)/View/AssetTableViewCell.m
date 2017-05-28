//
//  AssetTableViewCell.m
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "AssetTableViewCell.h"

@implementation AssetTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btn_ques_click:(id)sender {
    
    [delegate assetCellDelegateBtnClick:sender];
}
@end
