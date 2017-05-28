//
//  XHBAlertAdvertisementView.h
//  XHBApp
//
//  Created by WangLinfang on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBBaseView.h"

typedef void(^myBlock)(NSString*urlStr,NSString*name) ;
@interface XHBAlertAdvertisementView : XHBBaseView
@property (weak, nonatomic) IBOutlet UIImageView *img_content;
@property(nonatomic,copy)myBlock turn;
@end
