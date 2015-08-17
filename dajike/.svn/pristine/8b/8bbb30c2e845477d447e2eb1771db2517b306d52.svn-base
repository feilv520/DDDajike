 //
//  AccountDetail2Cell.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountDetail2Cell.h"
#import "commonTools.h"

@implementation AccountDetail2Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setAccountDetailModel:(AccountDetailModel *)model
{
    self.mainLabel.text = model.beizhu;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[commonTools moneyTolayout:model.jine]];
    self.dayLabel.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.create_time]];
}

@end
