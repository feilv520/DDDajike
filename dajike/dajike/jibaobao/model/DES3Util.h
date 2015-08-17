//
//  DES3Util.h
//  jibaobao
//
//  Created by dajike on 15/5/7.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;



@end
