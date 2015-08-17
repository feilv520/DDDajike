//
//  MyOrderCell.m
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MyOrderCell.h"
#import "commonTools.h"
#import "defines.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrderGoodsModel:(orderGoodsModel *)orderGoodsModel{
    self.titleLabel.text = orderGoodsModel.goods_name;
    self.allPrice.text = [NSString stringWithFormat:@"%d",[orderGoodsModel.quantity intValue]*[orderGoodsModel.price intValue]];
    self.numLabel.text = orderGoodsModel.quantity;
    [self.headImageView setImageWithURL:[commonTools getImgURL:orderGoodsModel.goods_image] placeholderImage:PlaceholderImage];
}

- (void)setListModel:(MyOrdersAjaxListModel *)listModel{
    //0取消订单,10已支付,11待支付,20待发货,30已发货,40交易成功完
    int statusTag = [listModel.status intValue];
    self.statusBut0.hidden = NO;
    self.statusBut.hidden = NO;
    switch (statusTag) {
        case 0:
            self.statusLabel.text = @"取消订单";
            self.statusBut0.hidden = YES;
            self.statusBut.hidden = YES;
            break;
        case 10:
            self.statusLabel.text = @"已支付";//<null>img_collect
            self.statusBut.tag = 0;
            self.statusBut0.hidden = YES;
            [self.statusBut setImage:[UIImage imageNamed:@"img_orderCancel_0.png"] forState:UIControlStateNormal];
            break;
        case 11:
            self.statusLabel.text = @"待支付";
            self.statusBut0.hidden = NO;
            self.statusBut.tag = 0;
            self.statusBut0.tag = 3;
            [self.statusBut setImage:[UIImage imageNamed:@"img_orderCancel_0.png"] forState:UIControlStateNormal];
            if ([listModel.yueJine intValue] > 0) {
                [self.statusBut0 setImage:[UIImage imageNamed:@"img_orderLastPay.png"] forState:UIControlStateNormal];
            }else{
                [self.statusBut0 setImage:[UIImage imageNamed:@"Img_orderPay.png"] forState:UIControlStateNormal];
            }
            break;
        case 20:
            self.statusLabel.text = @"待收货";
            self.statusBut0.hidden = YES;
            self.statusBut.tag = 1;
            [self.statusBut setImage:[UIImage imageNamed:@"img_orderSureRecive.png"] forState:UIControlStateNormal];
            break;
        case 30:
            self.statusLabel.text = @"已发货";
            self.statusBut0.hidden = YES;
            self.statusBut.tag = 1;
            [self.statusBut setImage:[UIImage imageNamed:@"img_orderSureRecive.png"] forState:UIControlStateNormal];
        case 40:
            self.statusLabel.text = @"交易已完成";
            self.statusBut0.hidden = YES;
            self.statusBut.tag = 2;
            [self.statusBut setImage:[UIImage imageNamed:@"img_orderEnvalute.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [self.statusBut0 addTarget:self action:@selector(statusButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBut addTarget:self action:@selector(statusButAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)statusButAction:(id)sender{
    // 0 取消订单 1 确认收货 2 评价订单 3 支付／支付余额
    UIButton *but = (UIButton *)sender;
    switch (but.tag) {
        case 0:
            if ([_cellDelegate respondsToSelector:@selector(cancelOrderWithRow:)]) {
                [_cellDelegate cancelOrderWithRow:self.row];
            }
            break;
        case 1:
            if ([_cellDelegate respondsToSelector:@selector(confirmReceiveWithRow:)]) {
                [_cellDelegate confirmReceiveWithRow:self.row];
            }
            break;
        case 2:
            if ([_cellDelegate respondsToSelector:@selector(evaluateOrderGoods:)]) {
                [_cellDelegate evaluateOrderGoods:self.row];
            }
            break;
        case 3:
            if ([_cellDelegate respondsToSelector:@selector(payForOrderGoods:)]) {
                [_cellDelegate payForOrderGoods:self.row];
            }
            break;
        default:
            break;
    }
}



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
