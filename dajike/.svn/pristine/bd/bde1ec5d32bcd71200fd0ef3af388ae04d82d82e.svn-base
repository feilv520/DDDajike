//
//  DOrderFourthCell.m
//  dajike
//
//  Created by swb on 15/8/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderFourthCell.h"
#import "dDefine.h"

@implementation DOrderFourthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OrdersDetailModel *)model
{
    self.xiadanTime.text = [commonTools isNull:[NSString stringWithFormat:@"%@",model.addTime]]?@"暂无":[NSString stringWithFormat:@"%@",model.addTime];
    self.fahuoTime.text = [commonTools isNull:[NSString stringWithFormat:@"%@",model.shipTime]]?@"暂无":[NSString stringWithFormat:@"%@",model.shipTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
