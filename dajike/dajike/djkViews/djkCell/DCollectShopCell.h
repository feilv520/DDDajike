//
//  DCollectShopCell.h
//  dajike
//
//  Created by songjw on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessList1Model.h"
@interface DCollectShopCell : UITableViewCell{
@private
    UIImageView*	m_checkImageView;
    BOOL			m_checked;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *fenNumLab;

@property (strong, nonatomic) BunessList1Model *shopModel;

- (void) setChecked:(BOOL)checked;
@end
