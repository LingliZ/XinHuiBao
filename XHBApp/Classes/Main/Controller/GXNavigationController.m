//
//  GXNavigationController.m
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXNavigationController.h"
#import "UIBarButtonItem+item.h"
//#import "GXPriceMAsetController.h"



@interface GXNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id GestureRecognizerDelegate;

@end

@implementation GXNavigationController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.GestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, GXScreenWidth, 1)];
    lineView.backgroundColor=[UIColor getColor:@"e7e7e7"];
    [self.navigationBar addSubview:lineView];
    
}





- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = _GestureRecognizerDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UITabBarController *tabBarController = (UITabBarController*)self.view.window.rootViewController;
        for (UIView *item in tabBarController.tabBar.subviews) {
            if ([item isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [item removeFromSuperview];
            }
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


#pragma mark - 屏幕旋转
-(BOOL)shouldAutorotate {
    /*
    if ([self.topViewController isKindOfClass:[GXPriceMAsetController class]]) {
        return YES;
    }
     */
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
