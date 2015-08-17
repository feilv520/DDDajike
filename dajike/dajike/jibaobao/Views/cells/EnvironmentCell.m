//
//  EnvironmentCell.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "EnvironmentCell.h"

@implementation EnvironmentCell

- (void)awakeFromNib {
    // Initialization code
}


+(EnvironmentCell *)cellFromNib
{
    
    EnvironmentCell *customCell = (EnvironmentCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
    
//    customCell-> _egoImgView = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 120, 80)];
//    customCell-> _egoImgView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    [customCell->_myImageView addSubview:customCell->_egoImgView];
//    customCell->_myImageView.clipsToBounds = YES;
//    customCell->_egoImgView.clipsToBounds = YES;
//    
//    //    [customCell addSubview:customCell-> _egoImgView];
//    
//    if (type == 1) {
//        customCell.reuseIdentifier = @"identifier";
//    }else  customCell.reuseIdentifier = @"identifier1";
    
    
    return customCell;
}

@end
