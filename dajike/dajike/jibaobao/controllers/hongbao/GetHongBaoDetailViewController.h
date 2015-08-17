//
//  GetHongBaoDetailViewController.h
//  jibaobao
//
//  Created by swb on 15/6/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 ****  红包详情   收到的红包
 */

#import "BackNavigationViewController.h"

@interface GetHongBaoDetailViewController : BackNavigationViewController<BarButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb1;

@property (weak, nonatomic) IBOutlet UILabel *lb2;

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) IBOutlet UILabel *jineLb;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
- (IBAction)sendHongBaoBtnAction:(id)sender;

@property (nonatomic, strong) NSString *jinEString;
@property (nonatomic, strong) NSString *hongbao_id;
@property (nonatomic, strong) NSString *send_nick_name;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, assign) double dataDouble;
@end
