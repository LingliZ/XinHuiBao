//
//  GXHelpCenterCatalogView.h
//  GXApp
//
//  Created by 王淼 on 16/7/11.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHelperCatalogModel.h"

@interface GXHelpCenterCatalogView : UIView

@property (nonatomic, strong) UIImageView *imageView; // 分类图片
@property (nonatomic, strong) UILabel *title; // 帮助中心一分类名称

-(void) setModel:(GXHelperCatalogModel* ) model;
@end
