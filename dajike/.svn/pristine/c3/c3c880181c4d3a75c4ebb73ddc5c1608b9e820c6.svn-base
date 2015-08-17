//
//  SwbCell3.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCell3.h"
#import "defines.h"

@implementation SwbCell3

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(GoodsCommentModel *)model
{
    if ([model.is_anony intValue] == 1) {
        if ([commonTools isEmpty:model.buyerName]) {
            self.label1.text = model.buyerName;
        }else
            self.label1.text = [NSString stringWithFormat:@"%@**%@",[model.buyerName substringToIndex:1],[model.buyerName substringFromIndex:model.buyerName.length-1]];
    }else
        self.label1.text = model.buyerName;
    
    CGRect rect1 = [self contentAdaptionLabel:self.label1.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.label1.frame = CGRectMake(10, 8, rect1.size.width, 21);
    NSRange range = [model.commentTime rangeOfString:@" "];
    self.label2.text = [model.commentTime substringToIndex:range.location];
    self.descriptionLb.text = model.content;
    
    CGRect rect = [self contentAdaptionLabel:self.descriptionLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
    NSLog(@"%f",rect.size.height);
    if ((int)rect.size.height > 43) {
        self.arrowImg.hidden = NO;
        self.descriptionCon.constant = 49;
    }else {
        self.arrowImg.hidden = YES;
        self.descriptionCon.constant = rect.size.height+5;
    }
    
    
    
    
    
    
    UIView *scoreBaseView = (UIView *)[self.contentView viewWithTag:301];
    if (!scoreBaseView) {
        scoreBaseView = [[UIView alloc]init];
        scoreBaseView.frame = CGRectMake(WIDTH_CONTROLLER_DEFAULT-110, 5, 100, 30);
        scoreBaseView.tag = 301;
        [self.contentView addSubview:scoreBaseView];
    }
    
    for (UIView *tmpview in scoreBaseView.subviews) {
        [tmpview removeFromSuperview];
    }
    //星星评分
    for(int i = 0;i<5;i++)
    {
        UIImageView *iv = [[UIImageView alloc]init];
        iv.frame = CGRectMake(19*i, 5, 15, 15);
        iv.image = [UIImage imageNamed:@"img_xingxing_03"];
        [scoreBaseView addSubview:iv];
        if (i<[model.xingji intValue]) {
            iv.image = [UIImage imageNamed:@"img_xingxing_02"];
        }
        NSLog(@"%@",[NSString stringWithFormat:@"%@",model.xingji]);
        if (![commonTools isPureInt:[NSString stringWithFormat:@"%@",model.xingji]]) {
            if (i == [model.xingji intValue]) {
                iv.image = [UIImage imageNamed:@"img_xingxing_04"];
            }
        }
    }
    
}

- (void)setShopModel:(ShopCommentModel *)shopModel
{
    
    if ([shopModel.is_anony intValue] == 1) {
        self.label1.text = [NSString stringWithFormat:@"%@**%@",[shopModel.user_name substringToIndex:1],[shopModel.user_name substringFromIndex:shopModel.user_name.length-1]];
    }else
        self.label1.text = shopModel.user_name;
    CGRect rect1 = [self contentAdaptionLabel:self.label1.text withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    self.label1.frame = CGRectMake(10, 8, rect1.size.width, 21);
//    NSString *timeStr = [commonTools timesToDate:[NSString stringWithFormat:@"%@",shopModel.time_comment]];
    NSRange range = [shopModel.time_comment rangeOfString:@" "];
    self.label2.text = [shopModel.time_comment substringToIndex:range.location];
    self.descriptionLb.text = shopModel.comments;
    
    
    CGRect rect = [self contentAdaptionLabel:self.descriptionLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
    NSLog(@"%f",rect.size.height);
    if ((int)rect.size.height >43) {
        self.arrowImg.hidden = NO;
        self.descriptionCon.constant = 49;
    }else {
        self.arrowImg.hidden = YES;
        self.descriptionCon.constant = rect.size.height+5;
    }
    
    
    
    
    UIView *scoreBaseView = (UIView *)[self.contentView viewWithTag:301];
    if (!scoreBaseView) {
        scoreBaseView = [[UIView alloc]init];
        scoreBaseView.frame = CGRectMake(WIDTH_CONTROLLER_DEFAULT-110, 5, 100, 30);
        scoreBaseView.tag = 301;
        [self.contentView addSubview:scoreBaseView];
    }
    
    for (UIView *tmpview in scoreBaseView.subviews) {
        [tmpview removeFromSuperview];
    }
    //星星评分
    for(int i = 0;i<5;i++)
    {
        UIImageView *iv = [[UIImageView alloc]init];
        iv.frame = CGRectMake(19*i, 5, 15, 15);
        iv.image = [UIImage imageNamed:@"img_xingxing_03"];
        [scoreBaseView addSubview:iv];
        if (i<[shopModel.xingji intValue]) {
            iv.image = [UIImage imageNamed:@"img_xingxing_02"];
        }
        NSLog(@"%@",[NSString stringWithFormat:@"%@",shopModel.xingji]);
        if (![commonTools isPureInt:[NSString stringWithFormat:@"%@",shopModel.xingji]]) {
            if (i == [shopModel.xingji intValue]) {
                iv.image = [UIImage imageNamed:@"img_xingxing_04"];
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
