//
//  JShouyeaButton.m
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeaButton.h"
#import "defines.h"

@implementation JShouyeaButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setButtonImage:(UIImage *)image andButtonTitle:(NSString *)title
{
//    CGFloat width = self.frame.size.width;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-20)/4;
    CGFloat height = self.frame.size.height;
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((17/75)*width, 10, (40/75)*width, (40/75)*width)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*(17/75.0)+((38/75.0)*width-38), 10, 38, 38)];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+5+(30/80)*width, width, 30)];
    [imageView setImage:image];
//    [imageView setImage:[UIImage imageNamed:@"img_shouye_01.png"]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageView];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (10+5)+(40/75)*width, width, (14/69)*height)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, width, 20)];
    [label setText:title];
    [label setFont:Font_Default];
    [label setTextColor:Color_Black];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
