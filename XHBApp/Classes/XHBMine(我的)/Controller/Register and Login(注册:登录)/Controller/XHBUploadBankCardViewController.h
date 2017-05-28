//
//  XHBUploadBankCardViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//
//上传银行卡
#import <UIKit/UIKit.h>

@interface XHBUploadBankCardViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF_userName;
@property (weak, nonatomic) IBOutlet UITextField *TF_partBank;
@property (weak, nonatomic) IBOutlet UIImageView *image_bankCard;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirmAdd;
@property (weak, nonatomic) IBOutlet UIView *view_BG;
@property(nonatomic,strong)id responseObject;
@property(nonatomic,strong)NSString*bankCardNum;

@property (weak, nonatomic) IBOutlet UILabel *label_bankName;
@property (weak, nonatomic) IBOutlet UILabel *label_bankNumAndType;

@property(nonatomic,strong)UIViewController *vc;

@end
