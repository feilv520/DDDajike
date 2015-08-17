//
//  DiscountCouponCell.m
//  jibaobao
//
//  Created by dajike on 15/4/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DiscountCouponCell.h"
//#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "defines.h"
#import "UIImageView+WebCache.h"

@implementation DiscountCouponCell


- (void)config:(CollectModel *)model
{
    if ([model.sales isEqualToString:@""]||
        [model.sales isEqualToString:@"(null)"]||
        model.sales == nil) {
        self.SoldNumberLabel.text = @"已售:0";
    }else{
        self.SoldNumberLabel.text = [NSString stringWithFormat:@"已售:%@",model.sales];
    }
    if ([model.choujiang_bili isEqualToString:@""]||
        [model.choujiang_bili isEqualToString:@"(null)"]||
        model.choujiang_bili == nil) {
        self.ProbabilityLabel.text = @"0%%累计抽奖";
    }else{
        self.ProbabilityLabel.text = [NSString stringWithFormat:@"%d%%累计抽奖",[model.choujiang_bili intValue]*100];//model.choujiang_bili;

    }
    if ([model.tags isEqualToString:@""]) {
        self.DistanceLabel.text = @"";
    }else{
        self.DistanceLabel.text = model.tags;
    }
    self.JIanjieLabel.text = model.goods_name;
    self.TitleLabel.text = model.store_name;
    
    self.NewPriceLabel.text     = [NSString stringWithFormat:@"%d",[model.price intValue]];
    self.OldPriceLabel.text     = [NSString stringWithFormat:@"%d",[model.market_price intValue]];
    if ([model.type isEqualToString:@"material"]) {//商品
        [self.HeadImageView setImageWithURL:[commonTools getImgURL:model.default_image] placeholderImage:PlaceholderImage];
    }else if ([model.type isEqualToString:@"coupon"]){//代金券
        [self.HeadImageView setImageWithURL:[commonTools getImgURL:model.store_logo] placeholderImage:PlaceholderImage];
    }
    
}
/*
 返回参数	返回类型	描述
 page	json	起始页
 pageSize	json	分页条数
 totalCount	json	总记录数
 totalPage	json	总页数
 price	json	价格
 market_price	json	市场价(原价)
 sales	json	销量
 goods_desc	json	商品描述
 goods_id	json	商品ID
 goods_name	json	商品名称
 user_id	json	用户ID
 store_logo	json	商家LOGO
 tags	json	标签
 store_name	json	商家名称
 tags	json	抽奖比例
 msg	json	信息
 */

- (void)awakeFromNib {
    // Initialization code
}




- (void)setModel:(GoodsListModel *)model
{
    self.TitleLabel.text        = model.goods_name;
    self.DistanceLabel.textColor = Color_mainColor;
    self.DistanceLabel.text = model.tags;
    CGRect rect = [self contentAdaptionLabel:self.DistanceLabel.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.distanceWidthCon.constant = rect.size.width+5;
    
    self.JIanjieLabel.text = model.store_name;
    
    self.NewPriceLabel.text     = [NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
    CGRect rect1 = [self contentAdaptionLabel:self.NewPriceLabel.text withSize:CGSizeMake(100, 28) withTextFont:17.0f];
    self.priceWidthCon.constant = rect1.size.width+5;
    if ([model.market_price floatValue]>0) {
        self.OldPriceLabel.text     = [NSString stringWithFormat:@"%.2f",[model.market_price floatValue]];
        CGRect rect2 = [self contentAdaptionLabel:self.OldPriceLabel.text withSize:CGSizeMake(100, 19) withTextFont:12.0f];
        self.oldPriceWidthCon.constant = rect2.size.width+5;
        self.OldPriceLabel.hidden = NO;
    }else {
        self.oldPriceWidthCon.constant = 1;
        self.OldPriceLabel.hidden = YES;
    }
    
    
    self.ProbabilityLabel.text  = [NSString stringWithFormat:@"%.0f%%累计抽奖",[model.choujiang_bili floatValue]*100];
    
    self.SoldNumberLabel.text   = [NSString stringWithFormat:@"已售%d",[model.sales intValue]];
    CGRect rect3 = [self contentAdaptionLabel:self.SoldNumberLabel.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.salesWidthCon.constant = rect3.size.width+5;
     [self.HeadImageView setImageWithURL:[commonTools getImgURL:model.default_image] placeholderImage:PlaceholderImage];
    NSLog(@"default_image = %@",[commonTools getImgURL:model.default_image]);
}

- (void)setNearbyYouhuiModel:(NearPrivilegeModel *)model
{
    self.TitleLabel.text        = model.store_name;
    self.JIanjieLabel.text      = model.goods_name;
    self.ProbabilityLabel.text  = [NSString stringWithFormat:@"%.0f%%累计抽奖",[model.choujiang_bili floatValue]*100];
   
    CGRect rect = [self contentAdaptionLabel:self.DistanceLabel.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.distanceWidthCon.constant = rect.size.width+5;
    
    self.NewPriceLabel.text     = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
    CGRect rect1 = [self contentAdaptionLabel:self.NewPriceLabel.text withSize:CGSizeMake(100, 28) withTextFont:17.0f];
    self.priceWidthCon.constant = rect1.size.width+5;
    self.OldPriceLabel.text     = [NSString stringWithFormat:@"%.2f",[model.market_price floatValue]];
    CGRect rect2 = [self contentAdaptionLabel:self.OldPriceLabel.text withSize:CGSizeMake(100, 19) withTextFont:12.0f];
    self.oldPriceWidthCon.constant = rect2.size.width+5;
    self.SoldNumberLabel.text   = [NSString stringWithFormat:@"已售%d",[model.sales intValue]];
    CGRect rect3 = [self contentAdaptionLabel:self.SoldNumberLabel.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.salesWidthCon.constant = rect3.size.width+5;
    [self.HeadImageView setImageWithURL:[commonTools getImgURL:model.store_logo] placeholderImage:PlaceholderImage];
    CGFloat distance = [model.distance floatValue];
   
    if (distance < 500.0) {
        self.DistanceLabel.text     = @"<500m";
        return;
    }
    if (distance < 1000.0) {
        self.DistanceLabel.text     = @"<1km";
        return;
    }
    if (distance < 2000.0) {
        self.DistanceLabel.text     = @"<2km";
        return;
    }
    if (distance < 5000.0) {
        self.DistanceLabel.text     = @"<5km";
        return;
    }
    if (distance < 10000.0) {
        self.DistanceLabel.text     = @"<10km";
        return;
    }
    if (distance >= 10000.0) {
        self.DistanceLabel.text     = @">10km";
    }
}


- (void)setCollectModel:(CollectModel *)CollectModel
{
    self.SoldNumberLabel.text = [NSString stringWithFormat:@"%d",[CollectModel.sales intValue]];
    self.NewPriceLabel.text = [NSString stringWithFormat:@"%d",[CollectModel.market_price intValue]];
    self.OldPriceLabel.text = [NSString stringWithFormat:@"%d",[CollectModel.price intValue]];
    [self.imageView setImageWithURL:[commonTools getImgURL:CollectModel.store_logo] placeholderImage:PlaceholderImage];
     self.JIanjieLabel.text = CollectModel.goods_name;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void) moveToRight
//{
//    for (UIView *view in self.contentView.subviews) {
//        CGRect frame = view.frame;
//        frame.origin.x = view.frame.origin.x + 150;
//        [view setFrame:frame];
//    }
//}

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
    }
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        if (m_checkImageView == nil)
        {
            m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_selected.png"]];
            [self addSubview:m_checkImageView];
        }
        
        [self setChecked:m_checked];
        m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                              CGRectGetHeight(self.bounds) * 0.5);
        m_checkImageView.alpha = 0.0;
        CGRect frame = m_checkImageView.frame;
        frame.size.width = 16;
        frame.size.height = 15;
        m_checkImageView.frame = frame;
        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
                                alpha:1.0 animated:animated];
    }
    else
    {
        m_checked = NO;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundView = nil;
        
        if (m_checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                                      CGRectGetHeight(self.bounds) * 0.5)
                                    alpha:0.0
                                 animated:animated];
        }
    }
}


- (void) setChecked:(BOOL)checked
{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"img_selected.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"img_no_selected.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
}

@end
