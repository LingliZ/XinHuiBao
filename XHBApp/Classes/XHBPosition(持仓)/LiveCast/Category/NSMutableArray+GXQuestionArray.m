//
//  NSMutableArray+GXQuestionArray.m
//  GXApp
//
//  Created by zhudong on 16/8/23.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSMutableArray+GXQuestionArray.h"

@implementation NSMutableArray (GXQuestionArray)
- (id)newObjectAt:(NSUInteger)index{
    if (index < self.count) {
        return self[index];
    }else{
        return nil;
    }
}
@end
