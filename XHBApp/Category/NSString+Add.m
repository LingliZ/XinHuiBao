//
//  NSString+Add.m
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (CGSize)boundingWithSize:(CGSize)size FontSize:(CGFloat)fontsize {
    
    CGSize stringSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return stringSize;
}

- (BOOL)validatePositiveNumber:(NSString *)String {
    
    if(![self isPureInt:String])
    {
        return NO;
    }
    return YES;
}



- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(BOOL)isChinese
{
    NSString*str=[self copy];
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
-(NSString*)checkName
{
    if(self.length==0)
    {
        return @"请输入姓名";
    }
    if(![[self stringByReplacingOccurrencesOfString:@"·" withString:@""] isChinese])
    {
        return @"姓名中不得包含除汉字和·之外的其他字符";
    }
    if([[self stringByReplacingOccurrencesOfString:@"·" withString:@""] length]<2)
    {
        return @"姓名不得少于2个汉字";
    }
    if(self.length>15)
    {
        return @"姓名长度不得大于15位";
    }
    return Check_Name_Qualified;
}
-(NSString*)checkPassword
{
    BOOL isContainSymbol=NO;
    BOOL isContainNum=NO;
    BOOL isContainLetter = NO;
    NSMutableString*psStr=[[NSMutableString alloc]init];
    
    if(self.length<6)
    {
        return @"密码长度不得小于6位";
    }
    if(self.length>20)
    {
        return @"密码长度不得大于20";
    }
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if((character>=21&&character<=47)||(character>=58&&character<=64)||(character>=91&&character<=96)||(character>=123&&character<=126))
        {
            isContainSymbol=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if(character>=48&&character<=57)
        {
            isContainNum=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            isContainLetter=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
    }
    if(![psStr isEqualToString:self])
    {
        return @"密码中含有非法字符";
    }
    if(!((isContainLetter&&isContainNum)||(isContainLetter&&isContainSymbol)||(isContainNum&&isContainSymbol)))
    {
        return @"密码需要包含字母、数字、常用符号中的至少两种组合";
    }
    return Check_Password_Qualified;
}
-(BOOL)checkPay_password
{
    BOOL isConfirm=YES;
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if(!((character>=48&&character<=57)||(character>=65&&character<=90)||(character>=97&&character<=122)))
        {
            isConfirm=NO;
        }
    }
    return isConfirm;
}
-(NSString*)checkNickName
{
    if(self.length==0)
    {
        return @"昵称不可以为空";
    }
    if(self.length<2)
    {
        return @"昵称的长度不得小于2位";
    }
    if(self.length>16)
    {
        return @"昵称的长度不得大于16位";
    }
    BOOL isContainNum=NO;
    BOOL isContainLetter = NO;

    int numberOfNum=0;
    NSString*nickStr=[self copy];
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if(character>=48&&character<=57)
        {
            isContainNum=YES;
            numberOfNum++;
            nickStr=[nickStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",character] withString:@""];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            isContainLetter=YES;
            nickStr=[nickStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",character] withString:@""];
        }
    }
    if(numberOfNum>=5)
    {
        return @"昵称中数字的个数不得大于等于5";
    }
    if(![nickStr isChinese]&&nickStr.length)
    {
        return @"昵称只能由字母、数字、汉字组成";
    }
    if(!isContainLetter&&!nickStr.length)
    {
        return @"昵称不能只由数字组成";
    }
    return @"checkNickName_ok";
}
-(NSString*)checkContactForFeedBack
{
    NSMutableString*psStr=[[NSMutableString alloc]init];
    
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if((character>=21&&character<=47)||(character>=58&&character<=64)||(character>=91&&character<=96)||(character>=123&&character<=126))
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if(character>=48&&character<=57)
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
    }
    if(![psStr isEqualToString:self])
    {
        return @"联系方式中含有非法字符，只能够包含字母，数字，常用字符";
    }
    
    return @"checkContactForFeedBack_ok";
}
/**
 *  校验身份证格式是否合格
 *
 *  @return 校验结果
 */
-(BOOL)checkIDCardNum
{
    if (self.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[self substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;

}
+ (NSString *)StringFromquoteTime:(NSString *)quoteTime {
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[quoteTime longLongValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
+ (NSString *)StringFromquoteTime_notYMD:(NSString *)quoteTime {
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[quoteTime longLongValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
+ (NSString *)StringFromquoteTime_notHMM:(NSString *)quoteTime {
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[quoteTime longLongValue]/1000];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//+ (NSString *)getKlineValue:(CGFloat )floatValue {
//    
//    
//    
//}
+ (NSString *)stringToFloat:(float )fv Code:(NSString *)code
{
    if([[code lowercaseString]isEqualToString:@"lls"])
    {
        return [NSString stringWithFormat:@"%.3f",fv];
    }else
    {
        return [NSString stringWithFormat:@"%.2f",fv];
    }
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


@end
