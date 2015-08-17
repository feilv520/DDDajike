//
//  BunessList1CellEditCell.m
//  jibaobao
//
//  Created by dajike on 15/5/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BunessList1CellEditCell.h"
#import "UIImageView+WebCache.h"
#import "CommentStarView.h"
@implementation BunessList1CellEditCell

- (void)config:(BunessList1Model *)model
{
    // [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.store_logo]];//图片
    self.titleLabel.text = model.store_name;//店面
    self.placeLabel.text = model.address;//归属地
    [self.quanImageView sd_setImageWithURL:[NSURL URLWithString:model.couponNum]];//代金券
    self.fenLabel.text = [NSString stringWithFormat:@"%@分",model.avgxingji];
    self.pingjiaLabel.text = [NSString stringWithFormat:@"%@人评价",model.commentCount];//;//评价个数；
    self.distenceLabel.text = model.distance;//距离
    self.title1LAbel.text = model.tag;
    CommentStarView *tmpView = [[CommentStarView alloc]init];
    tmpView.frame = CGRectMake(100, 30,110, 20);
    [tmpView layoutCommentStar:[NSString stringWithFormat:@"%@",model.avgxingji]];
    [self.contentView addSubview:tmpView];
    self.headImageView.image = [UIImage imageNamed:@"img_jiazai"];//代替图片
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
