//
//  DZiyingCell.m
//  dajike
//
//  Created by dajike on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DZiyingCell.h"
#import "dDefine.h"
#import "defines.h"

@implementation DZiyingCell

- (void)awakeFromNib {
    // Initialization code
    [self.label1 setFont:DFont_14];
    [self.label1 setTextColor:DColor_666666];
    
    [self.label2 setFont:DFont_11];
    [self.label2 setTextColor:DColor_999999];
    
    [self.label3 setFont:DFont_11];
    [self.label3 setTextColor:DColor_999999];
    
    [self.label4 setFont:DFont_11];
    [self.label4 setTextColor:DColor_999999];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setZiyingCateModel:(DZiyingCateModel *)model
{ 
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:DPlaceholderImage];
    self.label1.text = model.title;
    
    NSArray *titleArr = [model.subcate componentsSeparatedByString:@" "];
    if (titleArr.count > 0) {
        self.label2.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:0]];
    }
    if (titleArr.count > 1) {
        self.label3.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:1]];
    }
    if (titleArr.count > 2) {
        self.label4.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:2]];
    }
    
}

@end
