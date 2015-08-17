//
//  JShouyeLimitDiscountView.m
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeLimitDiscountView.h"
#import "JShouyeLimitDiscountButton.h"
#import "defines.h"

@implementation JShouyeLimitDiscountView

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
- (void)setImageWithArray:(NSArray *)imageArray andtitles:(NSArray *)titleArr andNewPrices:(NSArray *)newPriceArr andOldPriceArray:(NSArray *)oldPriceArr
{
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    if (imageArray.count > 0) {
        for (int i = 0; i < imageArray.count; i++) {
            JShouyeLimitDiscountButton *btn = [[JShouyeLimitDiscountButton alloc]initWithFrame:CGRectMake(i*(WIDTH_VIEW_DEFAULT/imageArray.count), 0, WIDTH_VIEW_DEFAULT/imageArray.count, HEIGHT_VIEW_DEFAULT)];
            btn.tag = i;
            NSString *imageStr = [imageArray objectAtIndex:i];
            NSString *titleStr = [NSString stringWithString:[titleArr objectAtIndex:i]];
            CGFloat newPrice = [[newPriceArr objectAtIndex:i] floatValue];
            CGFloat oldPrice = [[oldPriceArr objectAtIndex:i] floatValue];
            [btn setImageStr:imageStr andTitle:titleStr andNewPrice:newPrice andOldPrice:oldPrice];
//            [btn setImage:image andTitle:titleStr andNewPrice:newPrice andOldPrice:oldPrice];
            [btn addTarget:self action:@selector(limitButtonClip:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }

    }
   }

- (void)limitButtonClip:(id)sender
{
    if (self.delegate) {
        [self.delegate ShouyeLimitDiscounButtonClicked:sender];
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
