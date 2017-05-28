//
//  GXFirstViewController.h
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "FCChildBaseViewController.h"

@interface GXFirstViewController : FCChildBaseViewController
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *dateStr;

- (void)refreshData;

@end
