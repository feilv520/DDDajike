//
//  DZhutijie02Cell.h
//  dajike
//
//  Created by dajike on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

//主题街 右边图片

#import <UIKit/UIKit.h>
#import "ShouyeBannerModel.h"

@interface DZhutijie02Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel01;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel02;

@property (retain, nonatomic) ShouyeBannerModel *zhutijiemodel;
@end
