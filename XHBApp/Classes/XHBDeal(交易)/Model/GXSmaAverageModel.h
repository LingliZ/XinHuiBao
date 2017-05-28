//
//  GXSmaAverageModel.h
//  GXApp
//
//  Created by yangfutang on 16/6/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSSMAParam.h"
#import "CCSKLineWithIndexChart.h"

@interface GXSmaAverageModel : NSObject

@property (nonatomic, strong) NSArray *paramArray;
@property (nonatomic, assign) KLineChartIndexBottomType kLineChartIndexBottomType;
@property (nonatomic, assign) KLineChartIndexTopType kLineChartIndexTopType;

@end
