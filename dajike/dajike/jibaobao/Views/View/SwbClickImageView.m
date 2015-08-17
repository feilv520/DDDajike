//
//  SwbClickImageView.m
//  jibaobao
//
//  Created by swb on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbClickImageView.h"

@implementation SwbClickImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUI];
}

- (void)setUI
{
    self.userInteractionEnabled = YES;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [btn addTarget:self action:@selector(imgClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)callBackImgViewClicked:(CallbackClickedBlock)block
{
    self.block = [block copy];
//    self.userInteractionEnabled = YES;
}

- (void)imgClicked
{
    self.block(self);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.block(self);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
