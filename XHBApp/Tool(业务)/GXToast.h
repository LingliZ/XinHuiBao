//
//  GXToast.h
//  GXApp
//
//  Created by 王淼 on 16/8/11.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToastLabel : UILabel
-(void) setMessageText:(NSString*) text;
@end


@interface GXToast : NSObject{

     ToastLabel* toastLabel;
     NSTimer * countTimer;
     int changeCount;

}

+(instancetype) shareInstance;

-(void) makeToast:(NSString*) message;

@end
