//
//  GXCalendarBaseModelCell.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarBaseModelCell.h"

@implementation GXCalendarBaseModelCell

+(instancetype)cellWithTableView:(UITableView *)tableView Model:(GXCalendarBaseModel *)model IndexPath:(NSIndexPath *)indexPath{
    NSString *modeName = NSStringFromClass([model class]);
   GXCalendarBaseModelCell *baseCell = [tableView dequeueReusableCellWithIdentifier:modeName forIndexPath:indexPath];
    [baseCell setModel:model];
    return baseCell;
}
-(void)setModel:(GXCalendarBaseModel *)model{
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
