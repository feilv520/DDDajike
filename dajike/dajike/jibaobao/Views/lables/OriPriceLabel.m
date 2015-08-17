//
//  OriPriceLabel.m
//  jibaobao
//
//  Created by dajike on 15/4/27.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "OriPriceLabel.h"

@implementation OriPriceLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef context    = UIGraphicsGetCurrentContext(); //获取画布
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor); //线条颜色
    CGContextSetShouldAntialias(context, NO);//设置线条平滑，不需要两边像素宽
    CGContextSetLineWidth(context, 0.7f);//设置线条宽度
    CGContextMoveToPoint(context, self.frame.size.width/9,self.frame.size.height/2);  //线条起始点
    CGContextAddLineToPoint(context, self.frame.size.width/9*8, self.frame.size.height/2);//线条结束点
    CGContextStrokePath(context);//结束，也就是开始画
    CGContextClosePath(context);
    
}


@end
