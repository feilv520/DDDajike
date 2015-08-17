//
//  JShouyeLimitDiscountButton.m
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeLimitDiscountButton.h"
#import "OriPriceLabel.h"
#import "defines.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+MyView.h"
//图片高度
#define image_Ht 45
//标题高度
#define title_Ht 20+10+15
//价格高度
#define price_Ht 20

@implementation JShouyeLimitDiscountButton
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

- (void)setImageStr:(NSString *)imageStr andTitle:(NSString *)title andNewPrice:(CGFloat)newPrice andOldPrice:(CGFloat)oldPrice
{
    UIImageView *imageV;
    if (!imageV) {
//        imageV = [[UIImageView alloc]initWithFrame:CGRectMake((15/100)*WIDTH_VIEW_DEFAULT, 20, (70/100)*WIDTH_VIEW_DEFAULT, image_Ht)];
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, image_Ht+10+5, image_Ht+10+5)];
    }
    imageV.backgroundColor = [UIColor clearColor];
//    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [imageV setImageWithURL:[commonTools getImgURL:imageStr] placeholderImage:PlaceholderImage];
    
    UILabel *Titlelabel;
    if (!Titlelabel) {
        Titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, imageV.frame.origin.y+10+image_Ht+5+5, 100-10, title_Ht)];
        [Titlelabel setFont:Font_Default_12];
        [Titlelabel setTextColor:Color_Gray_LimitDiscount];
        [Titlelabel setTextAlignment:NSTextAlignmentCenter];
        [Titlelabel setBackgroundColor:Color_Clear];
        [Titlelabel setNumberOfLines:3];
        Titlelabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    [Titlelabel setText:title];
    
    UILabel *newPriceLabel;
    if (!newPriceLabel) {
        newPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Titlelabel.frame.origin.y+title_Ht-5+5, 60, price_Ht)];
        [newPriceLabel setFont:Font_Default];
        [newPriceLabel setTextColor:Color_Orange_newPrice];
        [newPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [newPriceLabel setBackgroundColor:Color_Clear];
    }
//    CGRect newframe_new = [self contentAdaptionLabel:[NSString stringWithFormat:@"￥%0.f",newPrice] withSize:CGSizeMake(80, 20) withTextFont:10];
//    [newPriceLabel setFrame:CGRectMake(0, Titlelabel.frame.origin.y+title_Ht-5, newframe_new.size.width, price_Ht)];
    [newPriceLabel setText:[NSString stringWithFormat:@"￥%0.f",newPrice]];
    
//    UILabel *yuanLabel;
//    if (!yuanLabel) {
//        yuanLabel = [[UILabel alloc]initWithFrame:CGRectMake((40/100)*WIDTH_VIEW_DEFAULT, Titlelabel.frame.origin.y+title_Ht+5+5, (10/100)*WIDTH_VIEW_DEFAULT, price_Ht)];
//        [yuanLabel setFont:Font_Default_11];
//        [yuanLabel setTextColor:Color_Orange_newPrice];
//        [yuanLabel setTextAlignment:NSTextAlignmentLeft];
//        [yuanLabel setBackgroundColor:Color_Clear];
//        [yuanLabel setText:@"元"];
//    }
    
    OriPriceLabel *oldPriceLabel;
    if (!oldPriceLabel) {
//        oldPriceLabel = [[OriPriceLabel alloc]initWithFrame:CGRectMake(50, Titlelabel.frame.origin.y+title_Ht-5, 40, price_Ht)];
        CGRect newframe_old = [self contentAdaptionLabel:[NSString stringWithFormat:@"%0.f",oldPrice] withSize:CGSizeMake(60, 20) withTextFont:10];
        oldPriceLabel = [[OriPriceLabel alloc]initWithFrame:CGRectMake(60, Titlelabel.frame.origin.y+title_Ht-5+5, newframe_old.size.width+2, price_Ht)];
        [oldPriceLabel setFont:Font_Default_10];
        [oldPriceLabel setTextColor:Color_Green_oldPrice_];
        [oldPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [oldPriceLabel setBackgroundColor:Color_Clear];
    }
//    CGRect newframe_old = [self contentAdaptionLabel:[NSString stringWithFormat:@"%0.f",oldPrice] withSize:CGSizeMake(60, 20) withTextFont:10];
//    [newPriceLabel setFrame:CGRectMake(50, Titlelabel.frame.origin.y+title_Ht-5, newframe_old.size.width, price_Ht)];
    [oldPriceLabel setText:[NSString stringWithFormat:@"%0.f",oldPrice]];
    [oldPriceLabel drawRect:oldPriceLabel.frame];
    
    for (UIView *vi in self.subviews) {
        [vi removeFromSuperview];
    }
    
    //添加视图
    [self addSubview:imageV];
    [self addSubview:Titlelabel];
    [self addSubview:newPriceLabel];
//    [self addSubview:yuanLabel];
    [self addSubview:oldPriceLabel];
}

- (void) setTimeLimitModel:(ShouyeBannerModel *)model
{
    [self setImageStr:model.img andTitle:model.title andNewPrice:[model.price floatValue] andOldPrice:[model.marketPrice floatValue]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
