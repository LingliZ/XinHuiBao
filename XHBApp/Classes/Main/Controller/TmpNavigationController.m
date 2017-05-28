//
//  TmpNavigationController.m
//  XHBApp
//
//  Created by WangLinfang on 16/12/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "TmpNavigationController.h"
#import "UIBarButtonItem+item.h"

@interface TmpNavigationController ()

@end

@implementation TmpNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.GestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, GXScreenWidth, 1)];
    lineView.backgroundColor=[UIColor getColor:@"e7e7e7"];
    [self.navigationBar addSubview:lineView];
}
+ (void)initialize {
    
    //    UIBarButtonItem *barbutton = [UIBarButtonItem appearance];
    //    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    //    att[NSForegroundColorAttributeName] = GXNavigationBarTitleColor;
    //    att[NSFontAttributeName] = GXFONT_PingFangSC_Light(GXFONT_SIZE14);
    //    [barbutton setTitleTextAttributes:att forState:UIControlStateNormal];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor getColor:@"ffffff"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFONT_SIZE20),NSForegroundColorAttributeName:[UIColor getColor:@"333333"]}];
    [[UINavigationBar appearance]setTintColor:[UIColor getColor:@"333333"]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
}
#pragma mark--滑动返回
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = _GestureRecognizerDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 不是根视图控制器
    if (self.viewControllers.count != 0) {
        // 设置导航条的按钮
        UIBarButtonItem *left = [UIBarButtonItem MyBarButtonItem:[UIImage imageNamed:@"navigationbar_back"] helited:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(popToPre) forcontroEvent:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = left;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (void)popToRoot {
    [self popToRootViewControllerAnimated:YES];
}


- (void)popToPre {
    [self popViewControllerAnimated:YES];
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
