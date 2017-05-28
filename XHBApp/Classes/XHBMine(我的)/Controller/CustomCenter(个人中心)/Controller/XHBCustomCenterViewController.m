//
//  XHBCustomCenterViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/16.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBCustomCenterViewController.h"
#import "XHBRealNameVertyViewController.h"
#import "XHBAddBankCardViewController.h"
#import "XHBuserIdentityInfoViewController.h"
#import "XHBAccountDetailViewController.h"
@interface XHBCustomCenterViewController ()

@end

@implementation XHBCustomCenterViewController
{
    UIImagePickerControllerSourceType currentImagePickerSourceType;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"个人信息";
    [UIView setBorForView:self.img_head withWidth:0 andColor:nil andCorner:22];
    [UIView setBorForView:self.label_accountType withWidth:0 andColor:nil andCorner:2];
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63));
    }];
    
    [self.view_NickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(WidthScale_IOS6(52)));
    }];
}
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //头像
        UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册获取", nil];
        }
        actionSheet.tag=100;
        [actionSheet showInView:self.view];
    }
    if(sender.tag==1)
    {
        //昵称
    }
    if(sender.tag==2)
    {
        //交易实盘号
        XHBAccountDetailViewController*detailVC=[[XHBAccountDetailViewController alloc]init];
        detailVC.account=[GXUserInfoTool getLoginAccount];
        detailVC.acconutLevel=[GXUserInfoTool getLoginAccountLevel];
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    if(sender.tag==3)
    {
        [GXUserInfoTool turnAboutVertyNameForViewController:self];
    }
    if(sender.tag==4)
    {
        //手机号码
    }
    if(sender.tag==5)
    {
        //出金银行卡
        [GXUserdefult setBool:YES forKey:IsSkip];
        [GXUserdefult synchronize];
        [GXUserInfoTool turnAboutBankCardForViewController:self];
    }
    GXLog(@"-------%d",(int)sender.tag);
}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==100)
    {
        //换头像
        if(buttonIndex==0)
        {
            //相册里选择
            currentImagePickerSourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self setHeadImageWithSouceType:currentImagePickerSourceType];

        }
        if(buttonIndex==1)
        {
            //拍照
            currentImagePickerSourceType=UIImagePickerControllerSourceTypeCamera;
            [self setHeadImageWithSouceType:currentImagePickerSourceType];

        }
    }
}
-(void)setHeadImageWithSouceType:(UIImagePickerControllerSourceType)souceType
{
    UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    imagePicker.sourceType=souceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark--UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage*image=[info objectForKey:UIImagePickerControllerEditedImage];
  //  self.img_head.image=image;
    NSData*imageData=UIImageJPEGRepresentation(image, 0.75);//压缩图片
    [self commtiHeadImagWithImageData:imageData];
}
#pragma mark--提交头像
-(void)commtiHeadImagWithImageData:(NSData*)imageData
{
    [self.view showLoadingWithTitle:@"正在上传……"];
    NSDictionary* URLParameters = @{
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    @"type":@"uc_avatar",
                                    @"file":imageData,
                                    };
    //使用时间生成照片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    [GXHttpTool post:XHBUrl_uploadImage image:imageData params:URLParameters name:fileName success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"头像上传成功");
            
            [self.view showSuccessWithTitle:@"头像上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.img_head.image=[UIImage imageWithData:imageData];
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"上传失败，请检查网络状况"];
    }];
    
}

#pragma mark--获取用户基本信息
-(void)getUserInfo
{
    NSDictionary*urlParams=@{
                             @"AppSessionId":[GXUserInfoTool getAppSessionId],
                             };
    [GXHttpTool POST:XHBUrl_getUserInfo parameters:urlParams success:^(id responseObject) {
        if([responseObject[@"success"]integerValue]==1)
        {
            [GXUserInfoTool saveAppSessionId:responseObject[@"value"][@"AppSessionId"]];//保存AppSessionId
            [GXUserInfoTool saveLoginAccount:responseObject[@"value"][@"SpNumber"]];//保存实盘账号
            [GXUserInfoTool savePhoneNum:responseObject[@"value"][@"Mobile"]];//保存手机号
            [GXUserInfoTool saveUserReallyName:responseObject[@"value"][@"Name"]];//保存用户真实姓名
            [GXUserInfoTool saveUserIDCardNum:responseObject[@"value"][@"IDNumber"]];//保存用户身份证号码
            [GXUserInfoTool saveIdentifyStatusWithStatus:responseObject[@"value"][@"Identity_Result"]];//保存用户实名认证状态
            [GXUserInfoTool saveUserBankCardStatus:responseObject[@"value"][@"Bank_Attest_Result"]];//保存用户银行卡状态
            [GXUserInfoTool saveUserCardNumber:responseObject[@"value"][@"CardNumber"]];//保存用户银行卡号
            [GXUserInfoTool saveUserBankName:responseObject[@"value"][@"BankName"]];//保存银行卡名字
            NSMutableString*nickName=[[NSMutableString alloc]initWithString:responseObject[@"value"][@"SpNumber"]];
            [nickName replaceCharactersInRange:NSMakeRange(2, 3) withString:@"***"];
            self.label_nickName.text=nickName;
            [self.img_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl_mine,responseObject[@"value"][@"Avatar"]]] placeholderImage:[UIImage imageNamed:@"mine_head"]];
            self.label_account.text=responseObject[@"value"][@"SpNumber"];
            self.label_name.text=responseObject[@"value"][@"Name"];
            self.label_accountType.text=responseObject[@"value"][@"Account_Level"];
            NSMutableString*phoneNum=[[NSMutableString alloc]initWithString:responseObject[@"value"][@"Mobile"]];
            [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.label_phoneNum.text=phoneNum;
            
            switch ([responseObject[@"value"][@"Identity_Result"]intValue]) {
                case 0:
                    self.label_name.text=@"点击认证";
                    self.label_name.textColor=[UIColor orangeColor];
                    self.img_next_realName.hidden=NO;
                    break;
                case 1:
                {
                    self.label_name.text=[NSString stringWithFormat:@"%@ 审核中",responseObject[@"value"][@"Name"]];
                    NSMutableAttributedString*attrStr=[[NSMutableAttributedString alloc]initWithString:self.label_name.text];
                    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(attrStr.length-3, 3)];
                    self.label_name.attributedText=attrStr;
                    self.img_next_realName.hidden=YES;
                }
                    break;
                case 2:
                    self.label_name.text=responseObject[@"value"][@"Name"];
                    self.img_next_realName.hidden=NO;
                    break;
                case 3:
                    self.label_name.text=@"认证失败，点击认证";
                    self.label_name.textColor=[UIColor orangeColor];
                    self.img_next_realName.hidden=NO;
                    break;
                default:
                    break;
            }
            NSMutableString*bankStr=[[NSMutableString alloc]initWithString:responseObject[@"value"][@"CardNumber"]];
            switch ([responseObject[@"value"][@"Bank_Attest_Result"]intValue]) {
                case 0:
                    self.label_bankCard.text=@"点击绑定";
                    self.label_bankCard.textColor=[UIColor orangeColor];
                    self.img_next_bankNum.hidden=NO;
                    break;
                case 1:
                {
                    self.label_bankCard.text=[NSString stringWithFormat:@"%@(%@) 审核中",responseObject[@"value"][@"BankName"],[bankStr substringWithRange:NSMakeRange(bankStr.length-4, 4)]];
                    NSMutableAttributedString*attrStr=[[NSMutableAttributedString alloc]initWithString:self.label_bankCard.text];
                    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(attrStr.length-3, 3)];
                    self.label_bankCard.attributedText=attrStr;
                    self.img_next_bankNum.hidden=YES;
                }
                    break;
                case 2:
                    self.label_bankCard.text=[NSString stringWithFormat:@"%@(%@)",responseObject[@"value"][@"BankName"],[bankStr substringWithRange:NSMakeRange(bankStr.length-4, 4)]];
                    self.img_next_bankNum.hidden=YES;
                    break;
                case 3:
                    self.label_bankCard.text=@"绑定失败，点击绑定";
                    self.label_bankCard.textColor=[UIColor orangeColor];
                    self.img_next_bankNum.hidden=NO;
                    break;
                default:
                    break;
            }
            
          
        }
        
    } failure:^(NSError *error) {
        
        // [self getUserInfo];
    }];
}


@end
