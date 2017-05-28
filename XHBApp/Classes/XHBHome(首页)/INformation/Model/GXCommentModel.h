//
//  GXCommentModel.h
//  GXApp
//
//  Created by GXJF on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXCommentModel : NSObject

@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *created;
//@property (nonatomic,strong)NSString *imgurl;
@property (nonatomic,strong)NSString *metadesc;
@property (nonatomic,strong)NSString *author;

@property (nonatomic,assign)CGFloat cellHeight;


@end
