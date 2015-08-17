//
//  BunessList1Cell.h
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"
#import "BunessList1Model.h"

@interface BunessList1Cell : UITableViewCell{
@private
    UIImageView*	m_checkImageView;
    BOOL			m_checked;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quanImageView;
@property (weak, nonatomic) IBOutlet UILabel *distenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *title1LAbel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenLabel;
@property (strong, nonatomic) ShopListModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWidthCon;


@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)config:(BunessList1Model *)model;

- (void) setChecked:(BOOL)checked;
@end
