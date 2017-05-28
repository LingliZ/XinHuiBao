//
//  XHBWelcomeViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/29.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBWelcomeViewController.h"

@interface XHBWelcomeViewController ()

@end

@implementation XHBWelcomeViewController
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
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d",i+1]];
        [bottomScrollView addSubview:imageView];
        if(i==2)
        {
            UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
            double y;
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
            btn.frame=CGRectMake(GXScreenWidth*i+(GXScreenWidth-125)/2, y, 125, 42);
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goTo) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
            [UIView setBorForView:btn withWidth:0 andColor:nil andCorner:5];
            [bottomScrollView addSubview:btn];
        }
    }
}
#pragma mark--跳转
-(void)goTo
{
    if(self.isFromAbout)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        GXTabBarController*tabVC=[[GXTabBarController alloc]init];
        AppDelegate* appDelagete = [UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController=tabVC;

    }
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
