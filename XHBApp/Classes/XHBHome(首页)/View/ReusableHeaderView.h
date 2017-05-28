//
//  ReusableHeaderView.h
//  GXApp
//
//  Created by GXJF on 16/6/30.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReusableHeaderViewDelegate <NSObject>
- (void)headerViewDidClickMoreBtn:(NSInteger)tag;
@end
@interface ReusableHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWihtTableView:(UITableView *)tableView;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)UIButton *moreBtn;
@property (nonatomic,assign)id<ReusableHeaderViewDelegate> delegate;

@end
