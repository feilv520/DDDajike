//
//  DProduceCommentCell.m
//  dajike
//
//  Created by swb on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DProduceCommentCell.h"
#import "dDefine.h"

@implementation DProduceCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(orderGoodsModel *)model
{
    self.goodNameLb.text = model.goods_name;
    self.goodPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
    CGRect rect = [self contentAdaptionLabel:self.goodPriceLb.text withSize:CGSizeMake(500, 30) withTextFont:13.0f];
    self.goodPriceCon.constant = rect.size.width+5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
