//
//  UITextField+GXTextFieldSelectedRange.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (GXTextFieldSelectedRange)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
