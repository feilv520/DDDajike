//
//  mineMainCell1.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "mineMainCell1.h"
#import "commonTools.h"
#import "defines.h"
@implementation mineMainCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(UserInfoModel *)model
{
    if ([commonTools isEmpty:model.portrait]||[model.portrait isEqualToString:@""]||[model.portrait isEqual:[NSNull null]]||[model.portrait isEqualToString:@"<null>"]) {
        if ([model.gender isEqualToString:@"2"]) {
            [self.HeadImageView setImage:[UIImage imageNamed:@"nv.png"]];
        }else{
            [self.HeadImageView setImage:[UIImage imageNamed:@"nan.png"]];
        }
    }else{
        NSURL *imgUrl = [commonTools getImgURL:model.portrait];
        [self.HeadImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"nan.png"]];
        self.HeadImageView.layer.masksToBounds = YES;
        self.HeadImageView.backgroundColor = [UIColor whiteColor];
        self.HeadImageView.layer.cornerRadius = 27.0;
        self.HeadImageView.layer.borderColor = [[UIColor colorWithRed:212 green:192 blue:161 alpha:1]CGColor];
        self.HeadImageView.layer.borderWidth = 2.0;
    }
    if ([commonTools isEmpty:model.nickName]||[model.nickName isEqualToString:@""]||[model.nickName isEqual:[NSNull null]]||[model.nickName isEqualToString:@"<null>"]) {
        self.userNameLabel.text = @"无";
    }else{
        self.userNameLabel.text = model.nickName;
    }
    
    self.userNameLabel.textColor = [UIColor blackColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
