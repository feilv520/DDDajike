//
//  MyClickLb.m
//  jibaobao
//
//  Created by swb on 15/6/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 *****  带有点击事件的Lb
 */

#import "MyClickLb.h"

@implementation MyClickLb

//手动代码创建
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
//从nib创建
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUI];
}

- (void)setUI
{
    self.userInteractionEnabled = YES;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [btn addTarget:self action:@selector(lbClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)lbClicked
{
    self.block(self);
}
- (void)callbackClickedLb:(ClickLabelBlock)block
{
    self.block = [block copy];
//    self.userInteractionEnabled = YES;
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
