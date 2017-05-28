//
//  GXXHBHomeAboutUsController.m
//  XHBApp
//
//  Created by 王振 on 2016/11/25.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "GXXHBHomeAboutUsController.h"
#import "NinaPagerView.h"
#import "UIParameter.h"
#import "GXXHBAboutUsBaseController.h"
#import "GXXHBAboutUsChildController.h"

@interface GXXHBHomeAboutUsController ()<NinaPagerViewDelegate>

//保存页数的值
@property (nonatomic,assign)NSInteger index;

@end
//关于我们
//-公司介绍
//http://www.91pme.com/zhuanti/app/about/introduce.html
//
//-监管牌照
//http://www.91pme.com/zhuanti/app/about/photo.html
//
//-公司优势
//http://www.91pme.com/zhuanti/app/about/strengths.html
//
//-软件下载
//http://www.91pme.com/zhuanti/app/about/download.html
//
//-联系我们
//http://www.91pme.com/zhuanti/app/about/contact.html

@implementation GXXHBHomeAboutUsController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    NSArray *titleArray = @[
                            @"公司介绍",
                            @"监管牌照",
                            @"公司优势",
                            @"软件下载",
                            @"联系我们"
                            ];
    NSArray *urlArray =@[
                         @"http://www.91pme.com/zhuanti/app/about/introduce.html",
                          @"http://www.91pme.com/zhuanti/app/about/photo.html",
                          @"http://www.91pme.com/zhuanti/app/about/strengths.html",
                          @"http://www.91pme.com/zhuanti/app/about/download.html",
                          @"http://www.91pme.com/zhuanti/app/about/contact.html"
                          ];
    NSMutableArray *ClassArray=[[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        GXXHBAboutUsChildController *comment=[[GXXHBAboutUsChildController alloc] init];
        comment.type = urlArray[i];
        [ClassArray addObject:comment];
        
    }
    /**  标题选中的颜色(默认为黑色)、未选中的颜色(默认为灰色)\下划线的颜色(默认为色值是ff6262)，上方菜单栏背景色(默认为白色)  **/
    NSArray *InColorArray = @[[UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000],
                              [UIColor colorWithWhite:0.608 alpha:1.000],
                              [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000],
                              [UIColor whiteColor],
                              ];
//   NSString *pageCount = [GXUserdefult objectForKey:@"savePage"];
//    if (pageCount == nil) {
//        self.index = 0;
//    }else{
//        self.index = [titleArray indexOfObject:pageCount];
//        
//    }
    
    NinaPagerView *inPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:titleArray WithVCs:ClassArray WithColorArrays:InColorArray WithDefaultIndex:0];
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

    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.


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
