//
//  SegmentButtonsView.m
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SegmentButtonsView.h"
#import "defines.h"

@interface SegmentButtonsView()

@end
@implementation SegmentButtonsView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.5f;
        self.defaultColor = Color_gray1;
        self.selectColor = [UIColor colorWithRed:203/255.0 green:20/255.0 blue:72/255.0 alpha:1];
    }
    return self;
}
//分段按钮
- (void) drawSegmentButtonsWithArrs:(NSArray*)titleArr andSelectColor:(UIColor*)selectColor andUnSelectColor:(UIColor*)defaultColor andSelectIndex:(NSInteger)selectIndex
{
    CGFloat width = self.frame.size.width/(titleArr.count);
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        button.tag = i;
        if (i == selectIndex) {
            button.backgroundColor = selectColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = defaultColor;
            [button setTitleColor:Color_gray4 forState:UIControlStateNormal];
        }
        [button setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.defaultColor = defaultColor;
        self.selectColor = selectColor;
    }
    
}
//分段按钮响应时间，代理
- (void) toButtons:(id) sender
{
    for (UIButton *btn in self.subviews) {
        btn.backgroundColor = self.defaultColor;
        [btn setTitleColor:Color_gray4 forState:UIControlStateNormal];
    }
    UIButton *btn0 = (UIButton *)sender;
    [btn0 setBackgroundColor:self.selectColor];
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate SegmentButtonsClicked:sender];
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
