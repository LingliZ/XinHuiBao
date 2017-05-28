//
//  InformationController.m
//  GXApp
//
//  Created by GXJF on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "InformationController.h"
#import "NinaPagerView.h"
#import "UIParameter.h"

#import "ChildBaseViewController.h"
#import "GXCommentsViewController.h"


@interface InformationController ()<NinaPagerViewDelegate>

@end

@interface InformationController ()

@property (nonatomic,strong)NSArray *InTitleArray;


//保存页数的值
@property (nonatomic,assign)NSInteger index;
@end

@implementation InformationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载数据
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"财经新闻";
//    self.nameArray = [NSMutableArray new];
//    self.valueArray = [NSMutableArray new];
    self.InTitleArray = @[@"金银日评",@"国际财经",@"市场动态",@"机构观点",@"策略研究",@"即时播报"];
    NSArray *typeArr = @[@"14",@"10",@"11",@"12",@"16",@"17"];
    NSMutableArray *InClassArray=[[NSMutableArray alloc] init];
    for (int i = 0; i < typeArr.count; i++) {
        GXCommentsViewController *comment=[[GXCommentsViewController alloc] init];
        comment.type = typeArr[i];
        [InClassArray addObject:comment];

    }
    /**  标题选中的颜色(默认为黑色)、未选中的颜色(默认为灰色)\下划线的颜色(默认为色值是ff6262)，上方菜单栏背景色(默认为白色)  **/
    NSArray *InColorArray = @[[UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000],
                              [UIColor colorWithWhite:0.608 alpha:1.000],
                              [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000],
                              [UIColor whiteColor],
                              ];
    NSString *pageCount = [GXUserdefult objectForKey:@"savePage"];
    if (pageCount == nil) {
        self.index = 0;
    }else{
        self.index = [typeArr indexOfObject:pageCount];
        
    }
    
    NinaPagerView *inPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.InTitleArray WithVCs:InClassArray WithColorArrays:InColorArray WithDefaultIndex:self.index];
    //InColorArrayNinaPagerView *inPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:self.InTitleArray WithVCs:InClassArray WithColorArrays:InColorArray];
    inPagerView.titleScale = 1;
    inPagerView.delegate = self;
    [self.view addSubview:inPagerView];
    inPagerView.pushEnabled = YES;



}

- (void)ninaCurrentPageIndex:(NSString *)currentPage{


}



-(BOOL)deallocVCsIfUnnecessary{
    return YES;
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
