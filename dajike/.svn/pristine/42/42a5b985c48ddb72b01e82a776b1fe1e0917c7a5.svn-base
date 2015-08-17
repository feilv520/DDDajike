//
//  MyOrderCell.h
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderGoodsModel.h"
#import "MyOrdersAjaxListModel.h"
@protocol MyOrderCellDelegate <NSObject>

@required

@optional
- (void)payForOrderGoods:(NSInteger)row;
- (void)evaluateOrderGoods:(NSInteger)row;
- (void)confirmReceiveWithRow:(NSInteger)row;
- (void)cancelOrderWithRow:(NSInteger)row;

@end

@interface MyOrderCell : UITableViewCell{
    UIImage *_image;
@private
    UIImageView*	m_checkImageView;
    BOOL			m_checked;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *statusBut;
@property (weak, nonatomic) IBOutlet UIButton *statusBut0;

@property (nonatomic, retain) id<MyOrderCellDelegate> cellDelegate;
@property (nonatomic) NSInteger row;
@property (strong, nonatomic) orderGoodsModel *orderGoodsModel;
@property (strong, nonatomic) MyOrdersAjaxListModel *listModel;

- (void) setChecked:(BOOL)checked;

@end
