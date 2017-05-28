//
//  GXTabbar.m
//  demo
//
//  Created by yangfutang on 16/5/10.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabbar.h"
#import "GXTabbarButton.h"



@interface GXTabbar ()

@property (nonatomic, strong) NSMutableArray *buttons;



@property (strong, nonatomic) NSMutableArray *tabBarItems;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *emptyButton;


@end



@implementation GXTabbar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)config {
    //
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 0.5, GXScreenWidth, 0.5)];
    //topLine.image = [UIImage imageNamed:@"tapbar_top_line"];
    //topLine.image = [UIImage imageNamed:@"mine_defaultSelectIndex"];
    topLine.backgroundColor = [UIColor grayColor];
    topLine.alpha = 0.2;
    [self addSubview:topLine];
}

- (void)setSelectedIndex:(NSInteger)index {
    for (GXTabbarButton *item in self.tabBarItems) {
        if (item.tag == index) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
    
    //if(index==2)
//        [MobClick event:@"menu_live"];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
    if (tabBarController) {
        tabBarController.selectedIndex = index;
    }
}

#pragma mark - Touch Event

- (void)itemSelected:(GXTabbarButton *)sender {
    
    switch (sender.tag) {
        case 0:
//            [MobClick event:@"menu_home"];
            break;
        case 1:
//            [MobClick event:@"menu_market"];
            break;
        case 2:
//            [MobClick event:@"menu_live"];
            break;
        case 3:
//            [MobClick event:@"menu_trading"];
            break;
        case 4:
//            [MobClick event:@"menu_uc"];
            break;
        default:
            break;
    }
    
    
    [self setSelectedIndex:sender.tag];
    if (self.delegate) {
        [self.delegate tabbar:self didselectIndex:sender.tag];
    }
}

#pragma mark - Setter

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
    _tabBarItemAttributes = tabBarItemAttributes.copy;
    
    NSAssert(_tabBarItemAttributes.count > 2, @"TabBar item count must greet than two.");
    
    CGFloat normalItemWidth = GXScreenWidth/5;
    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
    CGFloat publishItemWidth = (GXScreenWidth / 4);
    
    NSInteger itemTag = 0;
    BOOL passedRiseItem = NO;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    
    for (id item in _tabBarItemAttributes) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            LLTabBarItemType type = [itemDict[kLLTabBarItemAttributeType] integerValue];
            
            CGRect frame = CGRectMake(normalItemWidth*itemTag, 0,normalItemWidth, tabBarHeight);
            CGRect frame1 = CGRectMake(normalItemWidth*itemTag, 0,normalItemWidth, tabBarHeight + 6);
            GXTabbarButton *tabBarItem = [self tabBarItemWithFrame:frame
                                                             title:itemDict[kLLTabBarItemAttributeTitle]
                                                   normalImageName:itemDict[kLLTabBarItemAttributeNormalImageName]
                                                 selectedImageName:itemDict[kLLTabBarItemAttributeSelectedImageName] tabBarItemType:type];
            if (itemTag == 0) {
                tabBarItem.selected = YES;
            }
            if (itemTag == 2) {
                tabBarItem.frame = frame1;
            }
            [tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            //            if (tabBarItem.tabBarItemType == LLTabBarItemRise) {
            //                passedRiseItem = YES;
            //            }
            tabBarItem.tag = itemTag;
            itemTag++;
            
            [_tabBarItems addObject:tabBarItem];
            [self addSubview:tabBarItem];
            
        }
    }
    
}

- (GXTabbarButton *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    GXTabbarButton *item = [[GXTabbarButton alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:10];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}





@end
