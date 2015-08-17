//
//  WriteIndentCell.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOverViewModel.h"

typedef void (^SelectPayTypeBlock)(int btnTag);

@interface WriteIndentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shouyiImg;
@property (weak, nonatomic) IBOutlet UIImageView *chongzhiImg;
@property (weak, nonatomic) IBOutlet UIImageView *jifenImg;
@property (weak, nonatomic) IBOutlet UIButton *shouyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouyiLb;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiLb;
@property (weak, nonatomic) IBOutlet UILabel *jifenLb;

@property (strong, nonatomic) SelectPayTypeBlock block;

//@property (strong, nonatomic) AccountOverViewModel *model;

- (IBAction)selectPayAction:(id)sender;


- (void)callBackSelectPayType:(SelectPayTypeBlock)block;

@end
