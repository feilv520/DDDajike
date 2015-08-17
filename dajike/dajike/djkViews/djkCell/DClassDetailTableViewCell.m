//
//  DClassDetailTableViewCell.m
//  dajike
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DClassDetailTableViewCell.h"
#import "dDefine.h"

@implementation DClassDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.classLabel setFont:DFont_14];
    [self.classLabel setTextColor:DColor_666666];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
