//
//  RecommendFoodCell.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

@interface RecommendFoodCell : UITableViewCell{
    UIImage *_image;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLab;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property (weak, nonatomic) IBOutlet UIButton *storBtn;

@property (strong, nonatomic) GoodsListModel *goodsListModel;
@end
