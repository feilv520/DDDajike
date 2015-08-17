//
//  Choujiang02Cell.h
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhongJiangTopModel.h"

@interface Choujiang02Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (retain, nonatomic) ZhongJiangTopModel *topModel;

@end
