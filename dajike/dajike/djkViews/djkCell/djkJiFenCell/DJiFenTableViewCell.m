//
//  DJiFenTableViewCell.m
//  dajike
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DJiFenTableViewCell.h"

@implementation DJiFenTableViewCell

- (void)awakeFromNib {
    self.rectImageView.layer.masksToBounds = YES;
    self.rectImageView.backgroundColor = [UIColor whiteColor];
    self.rectImageView.layer.cornerRadius = 42.0;
    self.rectImageView.layer.borderColor = [[UIColor colorWithRed:212 green:192 blue:161 alpha:1]CGColor];
    self.rectImageView.layer.borderWidth = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
