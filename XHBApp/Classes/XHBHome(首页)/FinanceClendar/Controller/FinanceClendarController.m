//
//  FinanceClendarController.m
//  GXApp
//
//  Created by GXJF on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "FinanceClendarController.h"
#import "NinaPagerView.h"
#import "UIParameter.h"
#import "FCChildBaseViewController.h"
#import "GXFirstViewController.h"
#import "GXCalendarPickerView.h"
#import "GXAdaptiveHeightTool.h"
//#import "GXCalendarPickerController.h"
@interface FinanceClendarController ()<NinaPagerViewDelegate,GXCalendarPickerViewDelegate>
//保存标题日期的数组
@property (nonatomic,strong)NSMutableArray *dateTitlesArray;
@property (nonatomic,strong)NSDate *customDate;
@property (nonatomic,strong)NinaPagerView *ninaPagerView;
@property (nonatomic,strong)NSMutableArray *colorArray;
@property (nonatomic,strong)NSMutableArray *controllerArray;
@property (nonatomic,strong)NSMutableArray *titlesArray;
@property (nonatomic,strong)GXCalendarPickerView *pickView;
@property (nonatomic,assign)NSInteger days;
@property (nonatomic,strong)NSString *weekDay1;
@property (nonatomic,strong)NSMutableArray *netDateArray;
@property (nonatomic,assign)CGFloat clendarLine;

@end

@implementation FinanceClendarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}
//获取当前的控制器页数
-(void)ninaCurrentPageIndex:(NSString *)currentPage{

//    NSLog(@"点击的日期是%@",str);
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.000];
    self.dateTitlesArray = [NSMutableArray new];
    self.netDateArray = [NSMutableArray new];
    self.title = @"财经日历";
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.clendarLine = [@"08.08" boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    //循环创建日期标题数组
    for (int i = -7; i < 8; i++) {
        NSString *getDate = [self getnDay:i];
        NSString *getDateStr = [self getnNetworkDate:i];
        [self.netDateArray addObject:getDateStr];
        [self.dateTitlesArray addObject: getDate];
    }
    self.titlesArray = self.dateTitlesArray;
    //Controller数组循环创建
    self.controllerArray = [NSMutableArray new];
    
    for (int i = -7 ; i < 8; i++) {
        GXFirstViewController *financeVC = [GXFirstViewController new];
        [_controllerArray addObject:financeVC];
        financeVC.type = i;
    }
    //颜色数组
    self.colorArray = @[[UIColor colorWithRed:1.000 green:0.592 blue:0.110 alpha:1.000],//选中标题颜色
                            [UIColor colorWithWhite:0.290 alpha:1.000],//未被选中标题颜色
                            [UIColor colorWithRed:1.000 green:0.592 blue:0.110 alpha:1.000],//下划线颜色
                            [UIColor whiteColor],//标题栏背景颜色
                            ].mutableCopy;
    NinaPagerView *ninaPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:self.titlesArray WithVCs:self.controllerArray WithColorArrays:self.colorArray WithDefaultIndex:self.titlesArray.count / 2 WithTitleFontSize:12];
    //NinaPagerView *ninaPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:self.titlesArray WithVCs:self.controllerArray WithColorArrays:self.colorArray WithDefaultIndex:_titlesArray.count / 2];
    ninaPagerView.titleScale = 1;
    ninaPagerView.customBottomLinePer = self.clendarLine;
    self.ninaPagerView = ninaPagerView;
    [self.view addSubview:ninaPagerView];
    self.ninaPagerView.delegate = self;
//    NSInteger index = self.ninaPagerView.pagerView.currentPage;
//    GXFirstViewController *vc = self.controllerArray[index];
//    [vc refreshData];
    _ninaPagerView.pushEnabled = YES;
    UIImage *calendar = [[UIImage imageNamed:@"calendar_pic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:calendar style:UIBarButtonItemStylePlain target:self action:@selector(didClickCalendarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}



//搜索日期
- (void)didClickCalendarItemAction:(UIBarButtonItem *)sender{
    [self.pickView remove];
    NSDate *date=[NSDate date];
    self.pickView =[[GXCalendarPickerView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    self.pickView.delegate = self;
    [self.pickView show];
}

//日期选择器代理
-(void)toobarDonBtnHaveClick:(GXCalendarPickerView *)pickView resultString:(NSString *)resultString{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyyMMdd"]; // 年-月-日 时:分:秒
    self.customDate = [formatter dateFromString:resultString];
    self.days = [GXAdaptiveHeightTool getDaysFrom:[NSDate date] To:self.customDate];

    self.ninaPagerView = nil;
    [self.colorArray removeAllObjects];
    [self.titlesArray removeAllObjects];
    [self.controllerArray removeAllObjects];
    //自选日期标题
    for (int i = -7; i <  8; i++) {
        NSString *customDate = [self getnCustomDay:i];
        [self.titlesArray addObject:customDate];
    }
    //Controller数组
    for (NSInteger i = self.days - 7; i < self.days + 8; i++) {
        GXFirstViewController *financeVC = [GXFirstViewController new];
        [_controllerArray addObject:financeVC];
        financeVC.type = i;
    }
    //颜色数组
    self.colorArray = @[[UIColor colorWithRed:1.000 green:0.592 blue:0.110 alpha:1.000],//选中标题颜色
                        [UIColor colorWithWhite:0.290 alpha:1.000],//未被选中标题颜色
                        [UIColor colorWithRed:1.000 green:0.592 blue:0.110 alpha:1.000],//下划线颜色
                        [UIColor whiteColor],//标题栏北京颜色
                        ].mutableCopy;
    self.ninaPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:self.titlesArray WithVCs:self.controllerArray WithColorArrays:self.colorArray WithDefaultIndex:_titlesArray.count / 2 WithTitleFontSize:12];
    //self.ninaPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:self.titlesArray WithVCs:self.controllerArray WithColorArrays:self.colorArray WithDefaultIndex:_titlesArray.count / 2];
    self.ninaPagerView.titleScale = 1;
    self.ninaPagerView.customBottomLinePer = self.clendarLine;

    [self.view addSubview:self.ninaPagerView];
    //设定默认显示
    self.ninaPagerView.delegate = self;

    self.ninaPagerView.pushEnabled = YES;
    
}

- (NSString *)getnCustomDay:(NSInteger)n{
    NSDate *theDate1;
    if (n != 0) {
        NSTimeInterval oneDay = 24 * 60 * 60 *1;
        theDate1 = [self.customDate initWithTimeInterval:oneDay * n sinceDate:self.customDate];
    }else{
        theDate1 = self.customDate;
    }
    NSDateFormatter *date_formatter1 = [[NSDateFormatter alloc]init];
    [date_formatter1 setDateFormat:@"MM.dd"];
    NSString *the_date_str1 = [date_formatter1 stringFromDate:theDate1];
    NSDateComponents *components1 = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:theDate1];
    NSInteger weekday1 = [components1 weekday];//a就是星期几,1是星期日,2是星期一,后面依次后推
    NSArray *weekArray1 = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekStr1 = weekArray1[weekday1 - 1];
    if ((self.days > -8 && self.days < 8) && n == -self.days) {
        NSString *todayStr = @"今天";
        self.weekDay1 = [[todayStr stringByAppendingString:@"\n"]stringByAppendingString:the_date_str1];
        return self.weekDay1;
    }
    else{
        NSString *weekDay1 = [[weekStr1 stringByAppendingString:@"\n"] stringByAppendingString:the_date_str1];
        return weekDay1;
    }

}

//当Controller大于5时,会只用五个,其他的释放掉,知道滑到相应位置,则被重新加载
-(BOOL)deallocVCsIfUnnecessary{
    return YES;
}
//获取请求的日期格式
- (NSString *)getnNetworkDate:(NSInteger)n{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(n != 0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay * n];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}
//获取N天的日期
- (NSString *)getnDay:(NSInteger)n{
        //现在时间
        NSDate *nowDate = [NSDate date];
        NSDate *theDate;
        if (n != 0) {
            //1天的长度
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            //从现在往后推的秒数
            theDate = [nowDate initWithTimeIntervalSinceNow:oneDay * n];
        }else{
            theDate = nowDate;
        }
        NSDateFormatter *date_formatter = [[NSDateFormatter alloc]init];
        [date_formatter setDateFormat:@"MM.dd"];
        NSString *the_date_str = [date_formatter stringFromDate:theDate];
        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:theDate];
        NSInteger weekday = [components weekday];//a就是星期几,1是星期日,2是星期一,后面依次后推
        NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        NSString *weekStr = weekArray[weekday - 1];
    if (n == 0) {
        NSString *todayStr = @"今天";
        NSString *weekDay = [[todayStr stringByAppendingString:@"\n"]stringByAppendingString:the_date_str];
        return weekDay;
    }else{
        NSString *weekDay = [[weekStr stringByAppendingString:@"\n"] stringByAppendingString:the_date_str];
        return weekDay;

    }
}
//返回方法
- (void)disMissBackMethod{
    UIImage *xuanran = [[UIImage imageNamed:@"navigationbar_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:xuanran style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackAction:)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
- (void)didClickBackAction:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
