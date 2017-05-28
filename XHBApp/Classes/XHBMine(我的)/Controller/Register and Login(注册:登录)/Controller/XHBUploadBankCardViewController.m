//
//  XHBUploadBankCardViewController.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "XHBUploadBankCardViewController.h"
#import "XHBAddCountSuccessVertifiedViewController.h"
@interface XHBUploadBankCardViewController ()

@end

@implementation XHBUploadBankCardViewController
{
    UITextField*currentTF;
    UIImagePickerControllerSourceType currentImagePickerSourceType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddObserver_EditingState_changeBtnState
    [self createUI];
}

-(void)createUI
{
    self.title=@"上传银行卡";
    [UIView setBorForView:self.btn_confirmAdd withWidth:0 andColor:nil andCorner:5];
    [self.btn_confirmAdd setBackgroundImage:ImageFromHex(Color_btn_next_normal) forState:UIControlStateNormal];
    [self.btn_confirmAdd setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    self.TF_partBank.delegate=self;
    self.TF_userName.delegate=self;
    self.TF_userName.text=[GXUserInfoTool getUserReallyName];
    self.TF_userName.enabled=NO;
    self.label_bankName.text=self.responseObject[@"value"][@"bankName"];
    self.label_bankNumAndType.text=[NSString stringWithFormat:@"%@(%@)",self.responseObject[@"value"][@"bankCardType"],[self.bankCardNum  substringWithRange:NSMakeRange(self.bankCardNum.length-4, 4)]];
    [self.view_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(GXScreenWidth));
        make.height.mas_equalTo(@(GXScreenHeight-63+20));
    }];
    

    
    [self.label_bankName mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.height.mas_equalTo(@21);
        make.centerY.mas_equalTo(@0);
    }];
    [self.label_bankNumAndType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_bankName.mas_right).offset(8);
        make.height.mas_equalTo(@21);
        make.centerY.mas_equalTo(@0);
        
    }];
    [self editClick];
}
-(void)editClick
{
    if(self.TF_userName.text.length==0||self.image_bankCard.image==nil)
    {
        self.btn_confirmAdd.enabled=NO;
    }
    else
    {
        self.btn_confirmAdd.enabled=YES;
    }
}
#pragma mark--确认添加
- (IBAction)btnClick_confirmAdd:(UIButton *)sender {
    [currentTF resignFirstResponder];
    [self commitBankCardPic];
}
#pragma mark--UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTF=textField;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [currentTF resignFirstResponder];
}
- (IBAction)btnCick_SelectImage:(UIButton *)sender {
    
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册获取", nil];
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
    self.image_bankCard.image=image;
    [self editClick];
    NSData*imageData=UIImageJPEGRepresentation(image, 0.75);//压缩图片
   // [self commtiHeadImagWithImageData:imageData];
}
#pragma mark--提交银行卡照片
-(void)commitBankCardPic
{
    [self.view banClickView];
    [self.view showLoadingWithTitle:@"正在上传……"];
    NSData*imageData=UIImageJPEGRepresentation(self.image_bankCard.image,0.75);//压缩图片
    NSDictionary* URLParameters = @{
                                    @"AppSessionId":[GXUserInfoTool getAppSessionId],
                                    @"type":@"bankcard",
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
            GXLog(@"银行卡上传成功");
            
            [self.view showSuccessWithTitle:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                if([GXUserdefult boolForKey:IsSkip])
                {
                    [self.vc removeFromParentViewController];
                    self.vc=nil;
//                     [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                XHBAddCountSuccessVertifiedViewController*addBankSuccessVC=[[XHBAddCountSuccessVertifiedViewController alloc]init];
                                [self.navigationController pushViewController:addBankSuccessVC animated:YES];
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
