//
//  BuyNeedKnowCell.m
//  jibaobao
//
//  Created by swb on 15/5/25.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BuyNeedKnowCell.h"
#import "defines.h"

@implementation BuyNeedKnowCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(GoodsDetailModel *)model
{
    if ([commonTools isNull:model.im_qq]) {
        self.QQLb.text = @"QQ：暂无";
    }else
        self.QQLb.text          = [NSString stringWithFormat:@"QQ:%@",model.im_qq];
    if ([commonTools isNull:model.tel]) {
        self.phoneLb.text = @"电话：暂无";
    }else
        self.phoneLb.text       = [NSString stringWithFormat:@"电话:%@",model.tel];
    if ([commonTools isNull:model.yye_time]) {
        self.contactTimeLb.text = @"暂无";
    }else
        self.contactTimeLb.text     = model.yye_time;
    
}

- (void)setKuaidiModel:(KuaidiModel *)kuaidiModel
{
    self.sendTimeLb.text        = [commonTools isNull:kuaidiModel.shijian]?@"暂无":kuaidiModel.shijian;
    CGRect rect1 = [self contentAdaptionLabel:self.sendTimeLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
    self.fanweiCon.constant = rect1.size.height+5;
    self.costLb.text            = [commonTools isNull:kuaidiModel.feiyong]?@"暂无":[NSString stringWithFormat:@"%d",[kuaidiModel.feiyong intValue]];
    CGRect rect2 = [self contentAdaptionLabel:self.costLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
    self.fanweiCon.constant = rect2.size.height+5;
    self.expressCompanyLb.text  = [commonTools isNull:kuaidiModel.kuaidi]?@"暂无":kuaidiModel.kuaidi;
    CGRect rect3 = [self contentAdaptionLabel:self.expressCompanyLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
    self.fanweiCon.constant = rect3.size.height+5;
    self.deliveryLb.text        = [commonTools isNull:kuaidiModel.fanwei]?@"暂无":kuaidiModel.fanwei;
    CGRect rect4 = [self contentAdaptionLabel:self.deliveryLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
    self.fanweiCon.constant = rect4.size.height+5;
    self.saleAfterLb.text       = [commonTools isNull:kuaidiModel.shouhou]?@"暂无":kuaidiModel.shouhou;
    CGRect rect5 = [self contentAdaptionLabel:self.saleAfterLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
    self.fanweiCon.constant = rect5.size.height+5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
