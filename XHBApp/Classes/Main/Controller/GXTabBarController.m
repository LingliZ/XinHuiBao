//
//  GXTabBarController.m
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabBarController.h"
#import "XHBHomeViewController.h"
#import "XHBPositionViewController.h"
#import "XHBDealViewController.h"
#import "XHBDiscoverViewController.h"
#import "XHBMineViewController.h"
#import "GXCommentsViewController.h"
//#import "GXPriceDetailViewController.h"
//#import "GXPriceMAsetController.h"
#import "GXNavigationController.h"
#import "UIImage+Tabbar.h"
#import "GXTabbarButton.h"
#import "GXTabbar.h"
#import "GXTabBarCoverBtn.h"
#import "ChatViewController.h"
#import <WebKit/WebKit.h>

@interface GXTabBarController ()
{
    UIImageView *navBarHairlineIamgeView;
}

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation GXTabBarController


- (NSMutableArray *)items {
    
    if (_items == nil) {
    
        _items = [NSMutableArray array];
    }
    
    return _items;
    
    
}


// 设置颜色
+(void)initialize {
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attrubute = [NSMutableDictionary dictionary];
    attrubute[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [item setTitleTextAttributes:attrubute forState:UIControlStateSelected];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    for (UIView *item in self.tabBar.subviews) {
        
        if ([item isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [item removeFromSuperview];
        }
    }
    
    
    
}


#pragma mark - GXTabBarCoverBtnDelegate
- (void)tabBarCoverBtnDidClick:(GXTabBarCoverBtn *)btn{
    self.selectedIndex = 2;
    [self.gxTabBar setSelectedIndex:2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    GXTabBarCoverBtn *coverBtn = [[GXTabBarCoverBtn alloc] init];
    coverBtn.coverBtnDelegate = self;
    
    [self setValue:coverBtn forKey:@"tabBar"];
    // 添加所有的子控制器
    [self setUpAllChirldControllers];
    // 添加tabbar
    [self setUpTabBar];


    
    //清除wk缓存
    if(IS_OS_9_OR_LATER)
    {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    }
}

- (void)setUpAllChirldControllers {
    // 管理子控制器
    // 首页
    XHBHomeViewController *home = [[XHBHomeViewController alloc] init];
    
    [self setUpChirldVC:home image:[UIImage imageNamed:@"more_icon_pre_"] selecImage:[UIImage imageWithOriginalName:@""] title:@"首页"];
    // 交易
    XHBDealViewController *price = [[XHBDealViewController alloc] init];
    [self setUpChirldVC:price image:[UIImage imageNamed:@"more_icon_pre_"] selecImage:[UIImage imageWithOriginalName:@""] title:@"交易"];
    // 直播-->日评
    XHBPositionViewController *discover = [[XHBPositionViewController alloc] init];
    GXCommentsViewController*infoVC=[[GXCommentsViewController alloc]init];
    infoVC.title=@"日评";
    infoVC.type=@"14";
    infoVC.isTmp=YES;
    [self setUpChirldVC:infoVC image:[UIImage imageNamed:@"more_icon_pre_"] selecImage:[UIImage imageWithOriginalName:@""] title:@"日评"];
    //发现--->>客服
    XHBDiscoverViewController *deal = [[XHBDiscoverViewController alloc] init];
    ChatViewController*onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self setUpChirldVC:onlineVC image:[UIImage imageNamed:@"more_icon_pre_"] selecImage:[UIImage imageWithOriginalName:@""] title:@"客服"];
    deal.view.backgroundColor = [UIColor whiteColor];
    
    
    XHBMineViewController *profile = [[XHBMineViewController alloc] init];
    [self setUpChirldVC:profile image:[UIImage imageNamed:@"more_icon_pre_"] selecImage:[UIImage imageWithOriginalName:@""] title:@"我的"];
}

- (void)setUpChirldVC:(UIViewController *)viewController image:(UIImage *)image selecImage:(UIImage *)selecImage title:(NSString *)title {
    
    viewController.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selecImage;
//    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    [self.items addObject:viewController.tabBarItem];
    // 添加导航控制器
    GXNavigationController *nav = [[GXNavigationController alloc] initWithRootViewController:viewController];
    navBarHairlineIamgeView = [self findHairlineImageViewUnder:viewController.navigationController.navigationBar];
    navBarHairlineIamgeView.hidden = YES;

    [self addChildViewController:nav];
    
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



- (void)setUpTabBar {
    
    GXTabbar *gxTabbar = [[GXTabbar alloc] initWithFrame:self.tabBar.bounds];
    gxTabbar.delegate = self;
    self.gxTabBar = gxTabbar;
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    gxTabbar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle : @"首页",kLLTabBarItemAttributeNormalImageName : @"tab_home_normal", kLLTabBarItemAttributeSelectedImageName : @"tab_home_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                      @{kLLTabBarItemAttributeTitle : @"交易", kLLTabBarItemAttributeNormalImageName : @"tab_deal_normal", kLLTabBarItemAttributeSelectedImageName : @"tab_deal_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                      @{kLLTabBarItemAttributeTitle : @"日评", kLLTabBarItemAttributeNormalImageName : @"tab_riping_normal", kLLTabBarItemAttributeSelectedImageName : @"tab_riping_selected", kLLTabBarItemAttributeType : @(LLTabBarItemRise)},
                                      @{kLLTabBarItemAttributeTitle : @"客服", kLLTabBarItemAttributeNormalImageName : @"tab_onlineService_normal", kLLTabBarItemAttributeSelectedImageName : @"tab_onlineService_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                      @{kLLTabBarItemAttributeTitle : @"我的", kLLTabBarItemAttributeNormalImageName : @"tab_mine_normal", kLLTabBarItemAttributeSelectedImageName : @"tab_mine_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
    
    [self.tabBar addSubview:gxTabbar];
    gxTabbar.ItemsArray = self.items;
    
}
#pragma mark - GXTabbarDelegate
- (void)tabbar:(GXTabbar *)Tabbar didselectIndex:(NSInteger)index {
    self.selectedIndex = index;
}

- (BOOL)shouldAutorotate {
    /*
    for (GXNavigationController *na in self.viewControllers) {
        
        if ([na.topViewController isKindOfClass:[GXPriceDetailViewController  class]]) {
            
            return na.topViewController.shouldAutorotate;
        }
    
    }
    */
    return NO;
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}




@end
