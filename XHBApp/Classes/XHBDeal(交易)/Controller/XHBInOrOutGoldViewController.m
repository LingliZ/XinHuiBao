//
//  XHBInOrOutGoldViewController.m
//  XHBApp
//
//  Created by shenqilong on 16/11/23.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBInOrOutGoldViewController.h"
#import "XHBInGoldViewController.h"
#import "XHBAssetDetailViewController.h"

@interface XHBInOrOutGoldViewController ()

@end

#define telstr @"400-120-9212"

@implementation XHBInOrOutGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:243.0/255.0f alpha:1.0f];;
    
    self.title=@"出入金";
    
    UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-STATUSBAR_HEIGHT-NAVBAR_HEIGHT)];
    scr.contentSize=CGSizeMake(scr.frame.size.width, scr.frame.size.height+1);
    [self.view addSubview:scr];
    
    UIButton *btn_ingold=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth/2.0, 90)];
    btn_ingold.backgroundColor=[UIColor whiteColor];
    [btn_ingold setTitle:@"入金 " forState:UIControlStateNormal];
    [btn_ingold setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
    btn_ingold.titleLabel.font=GXFONT_PingFangSC_Regular(14);
    [btn_ingold setImage:[UIImage imageNamed:@"asset_in"] forState:UIControlStateNormal];
    [btn_ingold setImagePosition:2 spacing:0];
    [btn_ingold addTarget:self action:@selector(btn_inAsset_click) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:btn_ingold];
    
    UIButton *btn_outgold=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 0, GXScreenWidth/2.0, btn_ingold.frame.size.height)];
    btn_outgold.backgroundColor=[UIColor whiteColor];
    [btn_outgold setTitle:@"出金 " forState:UIControlStateNormal];
    [btn_outgold setTitleColor:GXBlack_priceNameColor forState:UIControlStateNormal];
    btn_outgold.titleLabel.font=GXFONT_PingFangSC_Regular(14);
    [btn_outgold setImage:[UIImage imageNamed:@"asset_out"] forState:UIControlStateNormal];
    [btn_outgold setImagePosition:2 spacing:0];
    [btn_outgold addTarget:self action:@selector(btn_outAsset_click) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:btn_outgold];


    UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 5, 1, btn_ingold.frame.size.height-10)];
    lineimg.backgroundColor=GXGrayLineColor;
    [scr addSubview:lineimg];
    
    
    
    //转账明细
    UIButton *btn_changeAsset=[[UIButton alloc]initWithFrame:CGRectMake(0, btn_outgold.frame.origin.y+btn_outgold.frame.size.height+10, GXScreenWidth, 50)];
    btn_changeAsset.backgroundColor=[UIColor whiteColor];
    [btn_changeAsset addTarget:self action:@selector(btn_changeAssetClick) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:btn_changeAsset];
    
    UILabel *lb_tit_changeAsset=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
    lb_tit_changeAsset.textColor=GXBlack_priceNameColor;
    lb_tit_changeAsset.font=GXFONT_PingFangSC_Regular(14);
    lb_tit_changeAsset.text=@"转账明细";
    [btn_changeAsset addSubview:lb_tit_changeAsset];
    
    UIImageView *cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, (50-16)/2.0, 16, 16)];
    cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
    [btn_changeAsset addSubview:cellindimg];

    
    
    
    
    UILabel *lb_tit_card=[[UILabel alloc]initWithFrame:CGRectMake(15, btn_changeAsset.frame.origin.y+btn_changeAsset.frame.size.height, 200, 38)];
    lb_tit_card.textColor=GXGray_priceDetailTrade_TextColor;
    lb_tit_card.font=GXFONT_PingFangSC_Regular(14);
    lb_tit_card.text=@"出金银行卡管理";
    [scr addSubview:lb_tit_card];

    
    UIButton *btn_OutAssetCard=[[UIButton alloc]initWithFrame:CGRectMake(0, lb_tit_card.frame.origin.y+lb_tit_card.frame.size.height, GXScreenWidth, 50)];
    btn_OutAssetCard.backgroundColor=[UIColor whiteColor];
    [btn_OutAssetCard addTarget:self action:@selector(btn_OutAssetCard_click) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:btn_OutAssetCard];
    
    UIImageView *addcardImg=[[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 40, 40)];
    addcardImg.image=[UIImage imageNamed:@"asset_addBankC"];
    [btn_OutAssetCard addSubview:addcardImg];

    UILabel *addcardTit=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 50)];
    addcardTit.textColor=GXBlack_priceNameColor;
    addcardTit.font=GXFONT_PingFangSC_Regular(14);
    addcardTit.text=@"添加出金银行卡";
    [btn_OutAssetCard addSubview:addcardTit];
    
    UILabel *addcardTit2=[[UILabel alloc]init];
    addcardTit2.textColor=GXGray_priceNameColor;
    addcardTit2.font=GXFONT_PingFangSC_Regular(14);
    [btn_OutAssetCard addSubview:addcardTit2];
    
    UILabel *addcardTit3=[[UILabel alloc]init];
    addcardTit3.textColor=GXMainColor;
    addcardTit3.font=GXFONT_PingFangSC_Regular(14);
    [btn_OutAssetCard addSubview:addcardTit3];
    
    
    BOOL isShowCard=YES;
    
    int cardstatus=[[GXUserInfoTool getUserBankCardStatus] intValue];
    switch (cardstatus) {
        case 0://未绑定
            isShowCard=NO;
            break;
        case 1://审核中
            addcardTit3.text=@"审核中";
            break;
        case 2://成功
            break;
        case 3://拒绝
            isShowCard=NO;
            break;
            
        default:
            break;
    }
    
    if(isShowCard)
    {
        btn_OutAssetCard.enabled=NO;
        
        addcardImg.image=nil;
        
        addcardTit.text=[GXUserInfoTool getUserBankName];
        [addcardTit sizeToFit];
        addcardTit.frame=CGRectMake(15, 0, addcardTit.bounds.size.width, 50);
        
        NSString *cards=[NSString stringWithFormat:@"%@",[GXUserInfoTool getUserCardNumber]];
        addcardTit2.text=[NSString stringWithFormat:@"(%@)",(cards.length>=4?[cards substringWithRange:NSMakeRange(cards.length-4, 4)]:cards)];
        [addcardTit2 sizeToFit];
        addcardTit2.frame=CGRectMake(addcardTit.frame.origin.x+addcardTit.frame.size.width+5, 0, addcardTit2.bounds.size.width, 50);
        
        addcardTit3.frame=CGRectMake(addcardTit2.frame.origin.x+addcardTit2.frame.size.width+5, 0, 100, 50);
        
        UIButton *btn_tel=[[UIButton alloc]initWithFrame:CGRectMake(0, btn_OutAssetCard.frame.origin.y+btn_OutAssetCard.frame.size.height, GXScreenWidth, 50)];
        btn_tel.backgroundColor=[UIColor whiteColor];
        [self.view setBorderWithView:btn_tel top:YES left:NO bottom:NO right:NO borderColor:GXGrayLineColor borderWidth:1];
        [btn_tel addTarget:self action:@selector(btn_tel_click) forControlEvents:UIControlEventTouchUpInside];
        [scr addSubview:btn_tel];
        
        UILabel *telText=[[UILabel alloc]init];
        telText.textColor=GXGray_priceNameColor;
        telText.font=GXFONT_PingFangSC_Regular(14);
        telText.text=@"如需更改银行卡，请致电";
        [telText sizeToFit];
        telText.frame=CGRectMake(15, 0, telText.bounds.size.width, 50);
        [btn_tel addSubview:telText];
        
        UILabel *telText2=[[UILabel alloc]init];
        telText2.textColor=GXMainColor;
        telText2.font=GXFONT_PingFangSC_Regular(14);
        telText2.text=telstr;
        telText2.frame=CGRectMake(telText.frame.origin.x+telText.frame.size.width+5, 0, 100, 50);
        [btn_tel addSubview:telText2];

        UIImageView *cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, (50-16)/2.0, 16, 16)];
        cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
        [btn_tel addSubview:cellindimg];
        
    }else
    {
        UIImageView *cellindimg=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth-31, (50-16)/2.0, 16, 16)];
        cellindimg.image=[UIImage imageNamed:@"assetTableCell"];
        [btn_OutAssetCard addSubview:cellindimg];
    }
    
    
    
}

-(void)btn_inAsset_click
{
    XHBInGoldViewController *ingold=[[XHBInGoldViewController alloc]init];
    ingold.homeUrl=[NSString stringWithFormat:@"%@?AppSessionId=%@&random=%ld",GXUrl_depositapp,[GXUserInfoTool getAppSessionId],random()];
    ingold.homeTit=@"入金";
    [self.navigationController pushViewController:ingold animated:YES];
}

-(void)btn_outAsset_click
{
    [GXUserInfoTool turnAboutBankCardForViewController:self];
}

-(void)btn_OutAssetCard_click
{
    [GXUserInfoTool turnAboutBankCardForViewController:self];
}

-(void)btn_tel_click
{
    GXLog(@"btn_tel_click");
//    [UIButton callPhoneWithPhoneNum:XHBServicePhoneNum atView:self.view];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",XHBServicePhoneNum]]];
}

-(void)btn_changeAssetClick
{
    XHBAssetDetailViewController *de=[[XHBAssetDetailViewController alloc]init];
    [self.navigationController pushViewController:de animated:YES];
}
- (void)gxAlertView:(GXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //打电话
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",XHBServicePhoneNum]]];
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
