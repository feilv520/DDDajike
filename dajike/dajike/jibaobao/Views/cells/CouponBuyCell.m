//
//  CouponBuyCell.m
//  jibaobao
//
//  Created by swb on 15/6/26.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponBuyCell.h"
#import "defines.h"

@implementation CouponBuyCell

- (void)awakeFromNib {
    // Initialization code
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(10, 35, WIDTH_CONTROLLER_DEFAULT-20, 0.5)];
    viewLine.backgroundColor = Color_line_bg;
    [self.contentView addSubview:viewLine];
}

- (void)setCouponArr:(NSMutableArray *)couponArr
{
    UIView *viewBg = [self createViewWithFrame:CGRectMake(0, 40, WIDTH_CONTROLLER_DEFAULT, couponArr.count*20+(couponArr.count+1)*5) andBackgroundColor:Color_Clear];
    [self.contentView addSubview:viewBg];
    for (UIView *tmpView in viewBg.subviews) {
        [tmpView removeFromSuperview];
    }
    for (int i=0; i<couponArr.count; i++) {
        UILabel *ll = [[UILabel alloc]initWithFrame:CGRectMake(10, i*20+i*5, 100, 20)];
        if (couponArr.count == 1) {
            ll.text = @"代金券";
        }else
            ll.text = [NSString stringWithFormat:@"代金券%d",i+1];
        ll.textColor = Color_word_bg;
        ll.font = [UIFont systemFontOfSize:15.0f];
        [viewBg addSubview:ll];
        
        UILabel *bb = [self creatLabelWithFrame:CGRectMake(150, CGRectGetMinY(ll.frame), WIDTH_CONTROLLER_DEFAULT-160, 20) AndFont:15.0f AndBackgroundColor:Color_Clear AndText:nil AndTextAlignment:NSTextAlignmentRight AndTextColor:Color_word_bg andCornerRadius:0.0f];
        bb.text = [NSString stringWithFormat:@"%@",[couponArr objectAtIndex:i]];
        [viewBg addSubview:bb];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
