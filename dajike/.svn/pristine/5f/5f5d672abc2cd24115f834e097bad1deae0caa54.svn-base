//
//  mineMainCell4.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "mineMainCell4.h"

@implementation mineMainCell4

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUserInfoModel:(UserInfoModel *)userInfoModel{
    if ([userInfoModel.phoneMobBindStatus intValue]==0) {
        self.phoneStatusLab.hidden = NO;
    }else{
        self.phoneStatusLab.hidden = YES;
    }
    if ([userInfoModel.bankCount intValue] == 0) {
        self.bankStatusLab.hidden = NO;
    }else{
        self.bankStatusLab.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
