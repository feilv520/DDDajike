//
//  PayKeyBoardView.m
//  kyboard_pay
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 swb. All rights reserved.
//

#import "PayKeyBoardView.h"
#import "defines.h"

#define KEYBOARD_BTN_WIDTH ((WIDTH_CONTROLLER_DEFAULT-1)/3)

#define KEYBOARD_BTN_HEIGHT (KEYBOARD_BTN_WIDTH/2)

@implementation PayKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_line_bg;
        [self layoutPayView];
    }
    return self;
}

- (void)layoutPayView
{
    for (int i = 0; i<12; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%3*KEYBOARD_BTN_WIDTH+i%3*0.5, i/3*KEYBOARD_BTN_HEIGHT+i/3*0.5, KEYBOARD_BTN_WIDTH, KEYBOARD_BTN_HEIGHT)];
        btn.backgroundColor = Color_White;
        [btn setTitleColor:Color_Black forState:UIControlStateNormal];
        btn.tag = i+1000;
        
        if (i == 9) {
            NSLog(@"没东西");
        }
        else if (i == 10) {
            [btn setTitle:@"0" forState:UIControlStateNormal];
        }else if (i == 11) {
            NSLog(@"回格");
            [btn setImage:[UIImage imageNamed:@"img_delete"] forState:UIControlStateNormal];
        }else
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(keyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)keyBtnClicked:(UIButton *)button
{
    NSLog(@"%d",[button.titleLabel.text intValue]);
    if (button.tag == 1009) {
        NSLog(@"没东西");
        self.block(@"");
    }else if (button.tag == 1011) {
        NSLog(@"回格");
        self.block(@"回格");
    }else
        self.block(button.titleLabel.text);
}

- (void)callBackNumClicked:(btnClickedBlock)block
{
    self.block = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
