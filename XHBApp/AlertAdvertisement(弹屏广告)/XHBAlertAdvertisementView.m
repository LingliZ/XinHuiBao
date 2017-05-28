//
//  XHBAlertAdvertisementView.m
//  XHBApp
//
//  Created by WangLinfang on 17/2/27.
//  Copyright © 2017年 WangLinfang. All rights reserved.
//

#import "XHBAlertAdvertisementView.h"

@implementation XHBAlertAdvertisementView
{
    NSString*clickUrl;
    NSString*name;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.hidden=YES;
    [self createUI];
    [self loadDataForAdvertise];
}
-(void)createUI
{
    [self.img_content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@60);
        make.left.mas_equalTo(@50);
        make.right.mas_equalTo(@(-50));
    }];
    
    self.img_content.userInteractionEnabled=YES;
    UITapGestureRecognizer*imgTapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgDidTouched)];
    [self.img_content addGestureRecognizer:imgTapRecognizer];
}
- (IBAction)btnClick_close:(UIButton *)sender {
    self.hidden=YES;
}
-(void)imgDidTouched
{
    if(clickUrl.length)
    {
        self.growingAttributesValue=clickUrl;
    }
    self.hidden=YES;
    self.turn(clickUrl,name);
}
-(void)loadDataForAdvertise
{
    [GXHttpTool POST:@"http://www.91pme.com/api/bannerlist/catid/112/limit/5/type/2" parameters:nil success:^(id responseObject) {
        NSArray*resultArr=(NSArray*)responseObject[@"value"];
        if([responseObject[@"success"]integerValue]==1)
        {
            self.hidden=NO;
            NSDictionary*resulDic=resultArr[0];
            clickUrl=resulDic[@"clickurl"];
            name=resulDic[@"name"];
            dispatch_async(dispatch_get_main_queue(), ^{
          
                [self.img_content sd_setImageWithURL:[NSURL URLWithString:resulDic[@"imgurl"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(error==nil)
                    {
                        self.img_content.image=[self imageCompressForWidth:self.img_content.image targetWidth:self.img_content.frame.size.width];
                    }
                }];
            });
        }
        else
        {
            self.hidden=YES;
        }
    } failure:^(NSError *error) {
        
        
    }];
}
#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
