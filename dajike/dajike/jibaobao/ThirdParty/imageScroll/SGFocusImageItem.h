//
//  SGFocusImageItem.h
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

//封装广告视图相关
#import <Foundation/Foundation.h>

@interface SGFocusImageItem : NSObject


@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString     *title1;
@property (nonatomic, retain)  NSString     *title2;
@property (nonatomic, retain)  NSString      *image;
@property (nonatomic, assign)  NSInteger     tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;
- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag;
@end
