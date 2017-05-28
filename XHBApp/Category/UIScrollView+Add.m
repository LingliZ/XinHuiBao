//
//  UIScrollView+Add.m
//  XHBApp
//
//  Created by WangLinfang on 16/11/9.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "UIScrollView+Add.h"

@implementation UIScrollView (Add)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end
