//
//  GXXHBHomePriceCell.h
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXCustomPageControl.h"

@interface GXXHBHomePriceCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger porsection;
    UITableView *tableViewIn;
    UILabel *labelCustom;
}
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, weak) NSTimer *timer; // 定时器
@property (nonatomic, assign) BOOL isRefesh; // 是否已经开始请求了
@property (nonatomic, strong) NSMutableArray *priceListArray; // 行情一级数据
@property (nonatomic, strong) RACSubject *SignalAddClick;

- (void) initData;
-(void) timerInv;

@property (nonatomic, strong) RACSubject *SignalCellClick;
@property (nonatomic,strong)UIView *indicateView;
@property (nonatomic,strong)UIImageView *rightView;
//@property (nonatomic,strong)UIPageControl *priceControl;
@property (nonatomic,strong)GXCustomPageControl *priceControl;
- (void)userCustomCellReloadData;


@end
