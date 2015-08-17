//
//  Choujiang02Cell.m
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "Choujiang02Cell.h"
@interface Choujiang02Cell()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end
@implementation Choujiang02Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopModel:(ZhongJiangTopModel *)model
{
    NSMutableString *userPhone = [[NSMutableString alloc]initWithString:model.userName];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@****%@",[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.jine floatValue]];
}

@end
