//
//  XHBBaseModel.m
//  XHBApp
//
//  Created by WangLinfang on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBBaseModel.h"

@implementation XHBBaseModel

-(CGFloat)getHeightWithContent:(NSString *)content andFontSize:(int)fontSize andWidth:(double)width
{
    NSMutableParagraphStyle *paragphStyle=[[NSMutableParagraphStyle alloc]init];
    paragphStyle.lineSpacing=0;//设置行距为0
    paragphStyle.firstLineHeadIndent=0.0;
    paragphStyle.hyphenationFactor=0.0;
    paragphStyle.paragraphSpacingBefore=0.0;
    NSDictionary *dic=@{
                        NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragphStyle, NSKernAttributeName:@1.0f
                        };
    CGSize size=[content boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}

-(NSString *)description{
    unsigned int count;
    const char *clasName = object_getClassName(self);
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%s: %p>:[ \n",clasName, self];
    Class clas = NSClassFromString([NSString stringWithCString:clasName encoding:NSUTF8StringEncoding]);
    Ivar *ivars = class_copyIvarList(clas, &count);
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            //得到类型
            NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:key];
            //确保BOOL 值输出的是YES 或 NO，这里的B是我打印属性类型得到的……
            if ([type isEqualToString:@"B"]) {
                value = (value == 0 ? @"NO" : @"YES");
            }
            [string appendFormat:@"\t%@: %@\n",[self delLine:key], value];
        }
    }
    [string appendFormat:@"]"];
    return string;
}
//因为ivar_getName得到的是一个带有下划线的名字，去掉下划线看起来更漂亮
-(NSString *)delLine:(NSString *)string{
    if ([string hasPrefix:@"_"]) {
        return [string substringFromIndex:1];
    }
    return string;
}

@end
