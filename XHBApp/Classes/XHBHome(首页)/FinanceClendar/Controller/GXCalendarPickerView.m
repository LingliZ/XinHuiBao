//
//  GXCalendarPickerView.m
//  
//
//  Created by GXJF on 16/7/12.
//  Copyright © 2016年 wangzhen. All rights reserved.
//
#define ZHToobarHeight 40
#import "GXCalendarPickerView.h"
///获取当前屏幕的高度
#define kMainScreenHeight ([UIScreen mainScreen].bounds.size.height)
///获取当前屏幕的宽度
#define KCalMianScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface GXCalendarPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIView * backView1;

@end

@implementation GXCalendarPickerView

-(BOOL)isShow{
    if (_pickerView.frame.size.width > 0) {
        return YES;
    }return NO;
}

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{
    
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}
-(void)setUpPickView{

    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor lightGrayColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, pickView.frame.size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    //NSDate *minDate = [[NSDate alloc]initWithString:@"2000-01-01 00:00:00 -0500"];
    //NSDate* maxDate = [NSDate date];
    //datePicker.minimumDate = minDate;
    //datePicker.maximumDate = maxDate;
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(10, ZHToobarHeight, KCalMianScreenWidth - 20, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    _backView1 = [[UIView alloc]init];
    _backView1.frame = CGRectMake(0, ZHToobarHeight, [UIScreen mainScreen].bounds.size.width, _pickeviewHeight);
    _backView1.backgroundColor = UIColorFromRGB(0xF8F9FA);
    [self addSubview:_backView1];
    [self addSubview:datePicker];
    [self sendSubviewToBack:_backView1];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
//    UIBarButtonItem *barbutton = [UIBarButtonItem appearance];
//    NSMutableDictionary *att = [NSMutableDictionary dictionary];
//    att[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [barbutton setTitleTextAttributes:att forState:UIControlStateNormal];
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    //UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0, 50, ZHToobarHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE15);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth - 100), 0, 100, ZHToobarHeight)];
    chooseLabel.text = @"选择日期";
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *centerSpace1 = [[UIBarButtonItem alloc]initWithCustomView:chooseLabel];
    //UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(GXScreenWidth - 60, 0, 50, ZHToobarHeight);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFONT_SIZE15);
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    toolbar.items=@[leftItem,centerSpace,centerSpace1,centerSpace ,rightItem];
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , ZHToobarHeight);
    _toolbar.barTintColor = [UIColor whiteColor];
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)show{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.backView = [[UIView alloc]initWithFrame:screenRect];
    
    //self.backView.backgroundColor=[UIColor colorWithRed:103.0/255.0 green:104.0/255.0 blue:106.0/255.0 alpha:.5];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [self.backView addGestureRecognizer:tap];
    [GXKeyWindow addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)remove{
    
    [self removeFromSuperview];
    [self.backView removeFromSuperview];
}

-(void)dismissAction{
    [self remove];
}
-(void)doneClick
{
    NSDate *pickerDate = [_datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
//    [pickerFormatter setDateFormat:@"yyyy年MM月dd日(EEEE)   HH:mm:ss"];
    [pickerFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    //_resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    _resultString = dateString;
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self removeFromSuperview];
    [self.backView removeFromSuperview];
}
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    _toolbar.tintColor = color;
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
