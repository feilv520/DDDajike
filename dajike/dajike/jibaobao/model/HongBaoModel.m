//
//  HongBaoModel.m
//  jibaobao
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "HongBaoModel.h"

@implementation HongBaoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"jine"]) {
        self.jin_e = value;
    }
}

@end
