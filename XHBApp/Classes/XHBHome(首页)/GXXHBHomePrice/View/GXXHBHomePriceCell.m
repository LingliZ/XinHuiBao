//
//  GXXHBHomePriceCell.m
//  XHBApp
//
//  Created by 王振 on 2016/11/21.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomePriceCell.h"
#import "PriceMarketModel.h"
#import "GXSimplePriceCell.h"

#define IntervalRefesh 2.0


@implementation GXXHBHomePriceCell

- (RACSubject *)SignalAddClick {
    if (!_SignalAddClick) {
        _SignalAddClick = [RACSubject subject];
    }
    return _SignalAddClick;
}

- (RACSubject *)SignalCellClick {
    
    if (!_SignalCellClick) {
        _SignalCellClick = [RACSubject subject];
    }
    return _SignalCellClick;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        tableViewIn = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, HeightScale_IOS6(100), GXScreenWidth) style:UITableViewStylePlain];
        tableViewIn.backgroundColor = UIColorFromRGB(0xFFFFFF);
        tableViewIn.dataSource = self;
        tableViewIn.delegate = self;
        tableViewIn.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableViewIn.separatorColor=[UIColor clearColor];
        tableViewIn.center = CGPointMake(GXScreenWidth / 2, HeightScale_IOS6(50));
        tableViewIn.showsVerticalScrollIndicator = NO;
        tableViewIn.transform = CGAffineTransformMakeRotation(M_PI / 2 * 3);
        
        self.indicateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HeightScale_IOS6(90), 23.4)];
        self.indicateView.backgroundColor = [UIColor whiteColor];
        self.indicateView .transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.indicateView .center = CGPointMake(GXScreenWidth - 11.7, HeightScale_IOS6(45));
        [self addSubview:tableViewIn];
        
        
        self.priceControl = [[GXCustomPageControl alloc]initWithFrame:CGRectMake(0,HeightScale_IOS6(85),self.width, 10)];

        self.priceControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000];
        self.priceControl.pageIndicatorTintColor = UIColorFromRGB(0xEEEEEE);
        self.priceControl.numberOfPages = 2;

        [self insertSubview:self.priceControl aboveSubview:tableViewIn];
        
        
    }return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scrollView.pagingEnabled = YES;
    self.priceControl.currentPage = (scrollView.contentOffset.y + 0.9* self.width) / self.width;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.priceListArray.count;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void) initData{
    
    [self loadData];
    if (_isRefesh == YES) {
        GXLog(@"didload已经请求");
    } else if (_isRefesh == NO) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:IntervalRefesh target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
}

-(void) timerInv
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer =nil;
    }
}


//- (void)userCustomCellReloadData {
//    
//    NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
//    long count=array.count+1;
//    if (count < 4) {
//        self.priceControl.hidden = YES;
//        
//    }else{
//        self.priceControl.hidden = NO;
//        
//        
//    }
//    if (count % 3 == 0) {
//        self.priceControl.numberOfPages = count / 3;
//    }else{
//        self.priceControl.numberOfPages = count / 3 + 1;
//    }
//    
//    [tableViewIn reloadData];
//}





- (void)loadData {
    
#warning yang的改动
    _isRefesh = NO;
    

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = @"llg,lls,$dxy,hf_CL";
    [GXHttpTool POSTCache:GXUrl_quotation parameters:param  success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            self.priceListArray = [PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            [tableViewIn reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    GXSimplePriceCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GXSimplePriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PriceMarketModel *marketModel=self.priceListArray[indexPath.row];
    [cell setModel:marketModel];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathk{
    return GXScreenWidth / 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.SignalCellClick sendNext:self.priceListArray[indexPath.row]];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor greenColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
