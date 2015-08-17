//
//  DShouye01Cell.h
//  dajike
//
//  Created by dajike on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

//大集客自营  集宝宝  区域直营 我要抽奖 cell
#import <UIKit/UIKit.h>
@protocol DShouye01CellDelegate <NSObject>

@optional
- (void)shouyeButtonClipAtIndex:(NSInteger) index;
@end

@interface DShouye01Cell : UITableViewCell

@property (nonatomic, weak) id<DShouye01CellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel01;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel02;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel03;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel04;

@end
