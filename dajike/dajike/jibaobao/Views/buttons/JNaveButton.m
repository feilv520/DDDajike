//
//  JNaveButton.m
//  jibaobao
//
//  Created by dajike on 15/5/5.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JNaveButton.h"
#import "defines.h"

@implementation JNaveButton
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
- (void)setButtonImage:(UIImage *)image andButtonNumber:(NSInteger)number
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //    CGFloat height = self.frame.size.height;
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((25/80)*width, 10, (30/80)*width, (30/80)*width)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+5+(30/80)*width, width, 30)];
    [imageView setImage:image];
//    [imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageView];
    
    if (number > 0) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width/3*2, 0, width/3*2, width/3*2)];
        //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+5+(30/80)*width, width, 30)];
        [imageView1 setImage:[UIImage imageNamed:@"img_y_bg.png"]];
        //    [imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imageView1];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, 1, width/2, width/2)];
        [label setText:[NSString stringWithFormat:@"%d",number]];
        [label setFont:Font_Default];
//        [label setTextColor:Color_cheng1];
        [label setTextColor:Color_White];
        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_y_by.png"]]];
        [imageView1 addSubview:label];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
