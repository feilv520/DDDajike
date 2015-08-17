//
//  DShouyeButtonsaView.m
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeButtonsaView.h"
#import "JShouyeaButton.h"
#import "defines.h"

@implementation JShouyeButtonsaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self addButtons];
    }
    return self;
}

- (void)addButtons
{
    CGFloat width = self.frame.size.width;
    CGFloat Height = self.frame.size.height;
    NSArray *imageNarry = [NSArray arrayWithObjects:[UIImage imageNamed:imageMeishi],[UIImage imageNamed:imageJiudian],[UIImage imageNamed:imageXiuxian],[UIImage imageNamed:imageLiren],[UIImage imageNamed:imageLvse],[UIImage imageNamed:imageJiaju],[UIImage imageNamed:imageGouwu],[UIImage imageNamed:imageShenghuo], nil];
    NSArray *titleNrray = [NSArray arrayWithObjects:@"美食",@"酒店",@"休闲娱乐",@"丽人",@"绿色特产",@"家居家纺",@"购物",@"生活服务", nil];
    for (int i = 0; i < 8; i++) {
        JShouyeaButton *Btn = [[JShouyeaButton alloc]initWithFrame:CGRectMake((i%4)*(width/4), (i/4)*(Height/2), width/4, Height)];
        [Btn setButtonImage:(UIImage *)[imageNarry objectAtIndex:i] andButtonTitle:[titleNrray objectAtIndex:i]];
        [Btn setTag:i];
        [Btn addTarget:self action:@selector(toBtns:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Btn];
    }
//    JShouyeaButton *Btn0 = [JShouyeaButton alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
}

- (void)toBtns:(id)sender
{
    if (self.delegate) {
        [self.delegate ShouyeButtonClicked:sender];
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
