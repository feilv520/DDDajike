//
//  DImgButton.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DImgButton.h"
#import "dDefine.h"

@implementation DImgButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 25)];
    }
    return self;
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return DRect(15, 12, 20, 20);
//}
- (void) setNavBarImage:(NSString *)imageName andimageFrame:(CGRect)frame;
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:frame];
    [imageV setImage:[UIImage imageNamed:imageName]];
    [imageV setContentMode:UIViewContentModeScaleAspectFit];
//    [imageV setContentMode:UIViewContentModeCenter];
    [self addSubview:imageV];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
