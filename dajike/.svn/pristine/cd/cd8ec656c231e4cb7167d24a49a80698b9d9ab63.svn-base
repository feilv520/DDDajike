//
//  DGoodsListTableViewCell.m
//  dajike
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DGoodsListTableViewCell.h"
#import "dDefine.h"
#import "defines.h"

@implementation DGoodsListTableViewCell

- (void)awakeFromNib {
    self.headImageView.layer.masksToBounds= YES;
    [self.headImageView.layer setCornerRadius:8];
    
    [self.titleLabel setFont:DFont_12];
    [self.titleLabel setTextColor:DColor_666666];
    
    [self.moneyLabel setFont:DFont_14];
    [self.moneyLabel setTextColor:DColor_c4291f];
    
    [self.passMoneyLabel setFont:DFont_10];
    [self.passMoneyLabel setTextColor:DColor_808080];
    
    [self.commintLabel setFont:DFont_10];
    [self.commintLabel setTextColor:DColor_999999];
    
    [self.commitNumberLabel setFont:DFont_10];
    [self.commitNumberLabel setTextColor:DColor_999999];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setZiyingTuijianModel:(DReXiaoGoodsModel *)model
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.default_image] placeholderImage:DPlaceholderImage];
    self.titleLabel.text = model.goods_name;
    self.moneyLabel.text = model.price;
//    @property (strong, nonatomic) IBOutlet UILabel *passMoneyLabel;
//    @property (strong, nonatomic) IBOutlet UILabel *commintLabel;
//    @property (strong, nonatomic) IBOutlet UILabel *commitNumberLabel;
    if ([model.yunfei floatValue]<0.0001) {
        self.passMoneyLabel.text = @"免运费";
    }else{
        self.passMoneyLabel.text = [NSString stringWithFormat:@"运费：¥%@",model.yunfei];
    }
    self.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",model.comments];
    if ([model.comments integerValue] > 0) {
        self.commintLabel.text = [NSString stringWithFormat:@"%.f%%好评",([model.haoping floatValue]/[model.comments floatValue])];
    }else{
        self.commintLabel.text = @"0%好评";
    }
    
    
}

@end
