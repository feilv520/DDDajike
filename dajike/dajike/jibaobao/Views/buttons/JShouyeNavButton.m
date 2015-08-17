//
//  JShouyeNavButton.m
//  jibaobao
//
//  Created by dajike on 15/4/27.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeNavButton.h"

#import "defines.h"


@interface JShouyeNavButton ()


@property UIImageView *updownImageView;


@end
@implementation JShouyeNavButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.cityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/4*3+3, self.frame.size.height)];
        self.cityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-15, self.frame.size.height)];
        [self.cityTitleLabel setTextColor:Color_mainColor];
//        self.cityTitleLabel.text = @"上海";
        self.cityTitleLabel.backgroundColor = [UIColor clearColor];
        [self.cityTitleLabel setFont:Font_Default];
//        self.cityTitleLabel.nuiClass = @"ShouyeNavLabel";
        [self.cityTitleLabel setNumberOfLines:1];
        [self addSubview:self.cityTitleLabel];
        
//        self.updownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/4*3-3, 6, self.frame.size.width/4-3, self.frame.size.height-12)];
        self.updownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-17, 6, 13, self.frame.size.height-12)];
        [self.updownImageView setImage:[UIImage imageNamed:imageDown]];
        [self addSubview:self.updownImageView];
    }
    return self;
}

//展开
- (void)setupWithTitle:(NSString *)string
{
    [self.updownImageView setFrame:CGRectMake(self.frame.size.width-17, 6, 13, self.frame.size.height-12)];
    [self.cityTitleLabel setFrame:CGRectMake(0, 0, self.frame.size.width-15, self.frame.size.height)];
    [self.updownImageView setImage:[UIImage imageNamed:imageDown]];
//    [self.cityTitleLabel setText:string];
}
//收起
- (void)setdownWithTitle:(NSString *)string
{
    [self.updownImageView setFrame:CGRectMake(self.frame.size.width-17, 6, 13, self.frame.size.height-12)];
    [self.cityTitleLabel setFrame:CGRectMake(0, 0, self.frame.size.width-15, self.frame.size.height)];
    [self.updownImageView setImage:[UIImage imageNamed:imageUp]];
//    [self.cityTitleLabel setText:string];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
