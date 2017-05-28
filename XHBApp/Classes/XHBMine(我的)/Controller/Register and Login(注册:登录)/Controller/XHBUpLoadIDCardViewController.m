//
//  XHBUpLoadIDCardViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBUpLoadIDCardViewController.h"
#import "XHBAddBankCardViewController.h"

#define isIDCardFrontUpLoadSucess @"isIDCardFrontUpLoadSucess"
#define isIDCardBehindUpLoadSucess @"isIDCardBehindUpLoadSucess"
#define uploadFor @"uploadIDCardFor"
#define forFront @"forIDCardFront"
#define forBehind @"forIDCardBehind"

@interface XHBUpLoadIDCardViewController ()

@end

@implementation XHBUpLoadIDCardViewController
{
    UIImagePickerControllerSourceType currentImagePickSourceType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"上传身份证";
    NSMutableString*name=[[NSMutableString alloc]initWithString:[GXUserInfoTool getUserReallyName]];
    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    self.label_alertToUpload.text=[NSString stringWithFormat:@"请上传%@的身份证正反面照片",name];
    NSMutableAttributedString*nameAttr=[[NSMutableAttributedString alloc]initWithString:self.label_alertToUpload.text];
    [nameAttr addAttribute: NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, name.length)];
    self.label_alertToUpload.attributedText=nameAttr;
    
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(CGRectGetMaxY(self.btn_next.frame)-443+(GXScreenHeight-568)));
    }];
    [self checkStatusOfBtn_next];
}
-(void)checkStatusOfBtn_next
{
    if(self.img_IDFront.image==nil||self.img_IDBehind.image==nil)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
- (IBAction)btnClick_returnToChange:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--选取图片
- (IBAction)btnClick_selectImg:(UIButton *)sender {
    if(sender.tag==0)
    {
        //上传正面
        [GXUserdefult setObject:forFront forKey:uploadFor];
        [GXUserdefult synchronize];
    }
    if(sender.tag==1)
    {
        //上传反面
        [GXUserdefult setObject: forBehind forKey:uploadFor];
        [GXUserdefult synchronize];
    }
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
    }
    actionSheet.tag=100;
    [actionSheet showInView:self.view];
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
            currentImagePickSourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self setHeadImageWithSouceType:currentImagePickSourceType];
        }
        
        if(buttonIndex==1)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //拍照
                currentImagePickSourceType=UIImagePickerControllerSourceTypeCamera;
                [self setHeadImageWithSouceType:currentImagePickSourceType];
            }
            
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
#pragma mark--UIPickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage*image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData*imageData=UIImageJPEGRepresentation(image,0.75);//压缩图片
    if([[GXUserdefult objectForKey:uploadFor]isEqualToString:forFront])
    {
        self.img_IDFront.image=image;
    }
    if([[GXUserdefult objectForKey:uploadFor]isEqualToString:forBehind])
    {
        self.img_IDBehind.image=image;
    }
    [self checkStatusOfBtn_next];
    
   // [self commiteHeadImageWithData:imageData];
    
}
#pragma mark--上传身份证照片
- (IBAction)btnClick_uploadIDCard:(UIButton *)sender {
    self.btn_next.enabled=NO;
    [self uploadFront];
}
#pragma mark--上传正面
-(void)uploadFront
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在上传中……"];
    NSData*imageData=UIImageJPEGRepresentation(self.img_IDFront.image,0.75);//压缩图片
    NSDictionary* URLParameters = @{
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    @"type":@"idcard_front",
                                    @"file":imageData,
                                    };
    //使用时间生成照片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    [GXHttpTool post:XHBUrl_uploadImage image:imageData params:URLParameters name:fileName success:^(id responseObject) {
        if([responseObject[@"success"]intValue]==1)
        {
            GXLog(@"正面上传成功");
            [GXUserdefult setBool:YES forKey:isIDCardFrontUpLoadSucess];
            [self uploadBehind];
        }
        else
        {
            [self.view removeTipView];
            [self.view showFailWithTitle:responseObject[@"message"]];
            [GXUserdefult setBool:NO forKey:isIDCardFrontUpLoadSucess];
        }
        [GXUserdefult synchronize];
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"上传失败，检查网络状况"];
        [GXUserdefult setBool:NO forKey:isIDCardFrontUpLoadSucess];
        [GXUserdefult synchronize];
    }];

}
#pragma mark--上传反面
-(void)uploadBehind
{
    NSData*imageData=UIImageJPEGRepresentation(self.img_IDBehind.image,0.75);//压缩图片
    NSDictionary* URLParameters = @{
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    @"type":@"idcard_behind",
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
            GXLog(@"反面上传成功");
            [GXUserdefult setBool:YES forKey:isIDCardBehindUpLoadSucess];
            
            [self.view showSuccessWithTitle:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int bankStatus=[[GXUserInfoTool getUserBankCardStatus]intValue];
                [self.vc removeFromParentViewController];
                if(bankStatus==1||bankStatus==2)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                XHBAddBankCardViewController*addBankVC=[[XHBAddBankCardViewController alloc]init];
                addBankVC.vc=self;
                [self.navigationController pushViewController:addBankVC animated:YES];
                
                
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
            [GXUserdefult setBool:NO forKey:isIDCardBehindUpLoadSucess];
            self.btn_next.enabled=YES;
        }
        [GXUserdefult synchronize];
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"上传失败，请检查网络状况"];
        self.btn_next.enabled=YES;
        [GXUserdefult setBool:NO forKey:isIDCardBehindUpLoadSucess];
        [GXUserdefult synchronize];
    }];

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
