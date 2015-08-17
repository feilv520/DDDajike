//
//  DMyOrderCell.m
//  dajike
//
//  Created by swb on 15/7/14.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyOrderCell.h"
#import "dDefine.h"

#define BTN_CORNERDADIU 2.0f
#define BTN_BORDERWIDTH 0.6f

@implementation DMyOrderCell

- (void)awakeFromNib {
    // Initialization code
    self.userInteractionEnabled = YES;
    self.lineView1Con.constant = 0.5f;
    self.lineView2Con.constant = 0.5f;
    self.lineView3Con.constant = 0.5f;
    
    [self setBtnLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMyOrderModel:(DMyOrderModel *)myOrderModel
{
    if ([myOrderModel.is_ziying intValue] == 1) {
        self.storeLb.text = @"大集客自营";
    }else
        self.storeLb.text = myOrderModel.seller_name;
    
    self.lbLeft.hidden = YES;
    self.lbCenter.hidden = YES;
    self.lbRight.hidden = YES;
    self.lbCenterCon.constant = 76;
    
    switch ([myOrderModel.status intValue]) {
        case 0:{
            self.statusLb.text = @"已取消";
            self.lbCenter.text = @"删除订单";
            self.lbCenter.hidden = NO;
            self.lbCenterCon.constant = 8;}
            break;
        case 10:{
            self.statusLb.text = @"已支付";
            self.lbCenter.text = @"取消订单";
            self.lbCenter.hidden = NO;
            self.lbCenterCon.constant = 8;}
            break;
        case 11:{
            self.statusLb.text = @"待付款";
            self.lbCenter.text = @"取消订单";
            self.lbCenter.hidden = NO;
            self.lbRight.text = @"付款";
            self.lbRight.hidden = NO;}
            break;
        case 20:{
            self.statusLb.text = @"待发货";
            self.lbCenter.text = @"取消订单";
            self.lbCenter.hidden = NO;
            self.lbCenterCon.constant = 8;}
            break;
        case 30:{
            self.statusLb.text = @"待收货";
            self.lbLeft.text = @"查看物流";
            self.lbLeft.hidden = NO;
            self.lbCenter.text = @"确认收货";
            self.lbCenter.hidden = NO;
            self.lbCenterCon.constant = 8;}
            break;
        case 40:{
            if (myOrderModel.isCommented) {
                self.statusLb.text = @"交易成功";
                self.lbLeft.text = @"删除订单";
                self.lbLeft.hidden = NO;
                self.lbCenter.text = @"查看物流";
                self.lbCenter.hidden = NO;
                self.lbCenterCon.constant = 8;
            }else {
                self.statusLb.text = @"交易成功";
                self.lbLeft.text = @"删除订单";
                self.lbLeft.hidden = NO;
                self.lbCenter.text = @"查看物流";
                self.lbCenter.hidden = NO;
                self.lbRight.text = @"评价";
                self.lbRight.hidden = NO;
            }}
            break;
            
        default:
            break;
    }
    [self.lbCenter callbackClickedLb:^(MyClickLb *clickLb) {
        self.block(clickLb.text);
    }];
    [self.lbLeft callbackClickedLb:^(MyClickLb *clickLb) {
        self.block(clickLb.text);
    }];
    [self.lbRight callbackClickedLb:^(MyClickLb *clickLb) {
        self.block(clickLb.text);
    }];
    self.productNumLb.text = [NSString stringWithFormat:@"共%d件商品",myOrderModel.buyNum];
    self.shifukuanLb.text = [NSString stringWithFormat:@"实付款：¥%.2f",[myOrderModel.yueJine floatValue]];
    CGRect rect = [self contentAdaptionLabel:self.shifukuanLb.text withSize:CGSizeMake(500, 15) withTextFont:12.0f];
    self.productNumCon.constant = rect.size.width+5;
}

- (void)setBtnLayer
{
    self.lbLeft.layer.cornerRadius = BTN_CORNERDADIU;
    self.lbLeft.layer.masksToBounds = YES;
    self.lbLeft.layer.borderColor = DColor_line_bg.CGColor;
    self.lbLeft.layer.borderWidth = BTN_BORDERWIDTH;
    
    self.lbCenter.layer.cornerRadius = BTN_CORNERDADIU;
    self.lbCenter.layer.masksToBounds = YES;
    self.lbCenter.layer.borderColor = DColor_line_bg.CGColor;
    self.lbCenter.layer.borderWidth = BTN_BORDERWIDTH;
    
    self.lbRight.layer.cornerRadius = BTN_CORNERDADIU;
    self.lbRight.layer.masksToBounds = YES;
}
//btn们的点击事件集合  tag=1001  cell
- (IBAction)btnClicked:(id)sender {
    self.block(@"");
}
- (void)callBackBtnClicked:(CallBackMyOrderBlock)block
{
    self.block = block;
}
@end
