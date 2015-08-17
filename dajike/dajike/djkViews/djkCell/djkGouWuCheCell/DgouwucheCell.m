//
//  DgouwucheCell.m
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DgouwucheCell.h"
#import "dDefine.h"

@implementation DgouwucheCell

- (void)awakeFromNib {
    // Initialization code
    self.selectBtn.selected = NO;
    [self.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(21, 10, 22, 10)];
    [self.jianBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    [self.jiaBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    self.buyNumLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyNumLb.layer.borderWidth = 0.5f;
    [self.selectBtn setImage:[UIImage imageNamed:@"img_car_04"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"img_car_02"] forState:UIControlStateSelected];
    self.productLogoImg.layer.cornerRadius = 6.0f;
    self.productLogoImg.layer.masksToBounds = YES;
}

- (void)setMDic:(NSMutableDictionary *)mDic
{
    [self.productLogoImg setImageWithURL:[commonTools getImgURL:[mDic objectForKey:@"goodsDefaultImage"]] placeholderImage:DPlaceholderImage];
    self.productDescLb.text = [mDic objectForKey:@"goodsName"];
    if ([commonTools isNull:[mDic objectForKey:@"spec1"]] && [commonTools isNull:[mDic objectForKey:@"specName1"]] && [commonTools isNull:[mDic objectForKey:@"specName2"]] && [commonTools isNull:[mDic objectForKey:@"spec2"]]) {
        self.productGuiGeLb.text = @"";
    }else if ([commonTools isNull:[mDic objectForKey:@"specName1"]]) {
        self.productGuiGeLb.text = [NSString stringWithFormat:@"%@:%@",[mDic objectForKey:@"specName2"],[mDic objectForKey:@"spec2"]];
    }else if ([commonTools isNull:[mDic objectForKey:@"specName2"]]) {
        self.productGuiGeLb.text = [NSString stringWithFormat:@"%@:%@",[mDic objectForKey:@"specName1"],[mDic objectForKey:@"spec1"]];
    }else {
        self.productGuiGeLb.text = [NSString stringWithFormat:@"%@:%@   %@:%@",[mDic objectForKey:@"specName1"],[mDic objectForKey:@"spec1"],[mDic objectForKey:@"specName2"],[mDic objectForKey:@"spec2"]];
    }
    self.productPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[[mDic objectForKey:@"goodsPrice"]floatValue]];
    self.buyNumLb.text = [NSString stringWithFormat:@"%d",[self.buyNum intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
//    btn.selected = !btn.selected;
    self.block((int)btn.tag);
}
- (void)callBtnClicked:(CallBtnClicked)block
{
    self.block = block;
}
@end