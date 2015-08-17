//
//  DMyCenterViewController.h
//  dajike
//
//  Created by songjw on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseViewController.h"

@interface DMyCenterViewController :DBaseViewController <UITableViewDataSource,UITableViewDelegate>{
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;
@property (weak, nonatomic) IBOutlet UIButton *loginBut;
@property (weak, nonatomic) IBOutlet UILabel *loginLab;
@property (weak, nonatomic) IBOutlet UIButton *but_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *nunLab_1;
@property (weak, nonatomic) IBOutlet UIButton *but_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *numLab_2;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImg;
- (IBAction)DLoginButtonClip:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@end
