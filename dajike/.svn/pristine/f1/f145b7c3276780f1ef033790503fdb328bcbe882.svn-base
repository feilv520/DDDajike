//
//  SGFocusImageItem.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize image = _image;
@synthesize tag = _tag;

- (void)dealloc
{
    self.title = nil;
    self.image = nil;
    self.title1 = nil;
    self.title2 = nil;
}
- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            
            self.title = [dict objectForKey:@"title"];
            self.title1 = [dict objectForKey:@"title1"];
            self.title2 = [dict objectForKey:@"title2"];
            self.image = [dict objectForKey:@"image"];
            //...
        }
    }
    return self;
}
@end
