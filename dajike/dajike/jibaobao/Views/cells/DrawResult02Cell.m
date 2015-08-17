//
//  DrawResult02Cell.m
//  jibaobao
//
//  Created by dajike on 15/6/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DrawResult02Cell.h"
#import "commonTools.h"

@implementation DrawResult02Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setJiangjinModel:(JIangjinModel *)model
{
    if ([model.poolType integerValue] == 0) {
        self.label01.text = [NSString stringWithFormat:@"%@元",model.jine];
        self.label02.text = @"现金";
    }else{
        self.label01.text = [NSString stringWithFormat:@"%@积分",model.jine];
        self.label02.text = @"积分";
    }
    self.label03.text = [NSString stringWithFormat:@"%@",model.choujiangDate];
    //        self.label03.text = [NSString stringWithFormat:@"%@",[commonTools timeAndDateFromStamp:model.choujiangDate]];
}
@end
