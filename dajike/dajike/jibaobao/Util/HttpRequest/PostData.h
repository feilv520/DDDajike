//
//  PostData.h
//  jibaobao
//
//  Created by dajike on 15/5/20.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject
@property (nonatomic) BOOL succeed;
@property (assign, nonatomic) NSInteger code;
@property (retain, nonatomic) NSString *msg;
@property (retain, nonatomic) id result;
@end
