//
//  XHBIndexViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/12/8.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBIndexViewController.h"
#import "XHBLoginViewController.h"
#import "XHBRegisterViewController.h"
@interface XHBIndexViewController ()

@end

@implementation XHBIndexViewController
{
    UIScrollView*bottomScrollView;
}
-(void)viewWillAppear:(BOOL)animated
{
    // [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    bottomScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
    bottomScrollView.pagingEnabled=YES;
    bottomScrollView.bounces=NO;
    bottomScrollView.showsHorizontalScrollIndicator=NO;
    bottomScrollView.contentSize=CGSizeMake(GXScreenWidth*3, GXScreenHeight-64);
    [self.view addSubview:bottomScrollView];
    
    for(int i=0;i<3;i++)
    {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*GXScreenWidth, -20, GXScreenWidth, GXScreenHeight)];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"index_%d",i+1]];
        [bottomScrollView addSubview:imageView];
        if(i==2)
        {
            UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
            double y=0.0;
            if(GXScreenWidth<375)
            {
                y= imageView.frame.size.height-(245+(GXScreenHeight+40-667)/2)-18;
            }
            if(GXScreenWidth==375)
            {
                y= imageView.frame.size.height-(245+(GXScreenHeight+40-667)/2);
            }
            if(GXScreenWidth>375)
            {
                y= imageView.frame.size.height-(245+(GXScreenHeight+40-667)/2)+10;
            }
            btn.frame=CGRectMake(GXScreenWidth*i+GXScreenWidth/2+WidthScale_IOS6(27), y, WidthScale_IOS6(100), 42);
          //  [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            btn.tag=0;
            [btn addTarget:self action:@selector(goTo:) forControlEvents:UIControlEventTouchUpInside];
          //  [btn setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
            [bottomScrollView addSubview:btn];
            
            UIButton*bt2=[UIButton buttonWithType:UIButtonTypeCustom];
            bt2.frame=CGRectMake(GXScreenWidth*i+GXScreenWidth/2-WidthScale_IOS6(53), y, WidthScale_IOS6(72), 42);
           // [bt2 setTitle:@"注册" forState:UIControlStateNormal];
            bt2.tag=1;
            [bt2 addTarget:self action:@selector(goTo:) forControlEvents:UIControlEventTouchUpInside];
            [bottomScrollView addSubview:bt2];
            
            UIButton*bt3=[UIButton buttonWithType:UIButtonTypeCustom];
            bt3.frame=CGRectMake(GXScreenWidth*i+GXScreenWidth/2-WidthScale_IOS6(53)-WidthScale_IOS6(72), y, WidthScale_IOS6(72), 42);
           // [bt3 setTitle:@"登录" forState:UIControlStateNormal];
            bt3.tag=2;
            [bt3 addTarget:self action:@selector(goTo:) forControlEvents:UIControlEventTouchUpInside];
            [bottomScrollView addSubview:bt3];
        }
    }
}
-(void)goTo:(UIButton*)sender
{
    if(sender.tag==0)
    {
        //立即体验
        [GXUserdefult setBool:NO forKey:IsFromIndex];
        GXTabBarController*tabVC=[[GXTabBarController alloc]init];
        AppDelegate* appDelagete = [UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController=tabVC;
    }
    if(sender.tag==1)
    {
        //注册
        [GXUserdefult setBool:YES forKey:IsFromIndex];
        XHBRegisterViewController*registerVC=[[XHBRegisterViewController alloc]init
                                              ];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    if(sender.tag==2)
    {
        //登录
        [GXUserdefult setBool:YES forKey:IsFromIndex];
        XHBLoginViewController*logVC=[[XHBLoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
    }

}

@end
