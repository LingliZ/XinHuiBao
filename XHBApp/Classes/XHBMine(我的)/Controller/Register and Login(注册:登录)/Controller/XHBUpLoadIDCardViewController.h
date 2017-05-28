//
//  XHBUpLoadIDCardViewController.h
//  XHBApp
//
//  Created by WangLinfang on 16/11/14.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//
//上传身份证
#import <UIKit/UIKit.h>

@interface XHBUpLoadIDCardViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (weak, nonatomic) IBOutlet UIView *view_BG;
@property (weak, nonatomic) IBOutlet UIImageView *img_IDFront;//正面
@property (weak, nonatomic) IBOutlet UIImageView *img_IDBehind;//反面
@property (weak, nonatomic) IBOutlet UILabel *label_alertToUpload;


@property(nonatomic,strong)UIViewController *vc;



@end
