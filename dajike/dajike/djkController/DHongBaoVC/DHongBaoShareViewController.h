//
//  DHongBaoShareViewController.h
//  dajike
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"

@interface DHongBaoShareViewController : DBackNavigationViewController

@property (weak, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet UIView *pyView;

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIView *littleViewBg;

@property (nonatomic, strong) NSString *hongBaoId;
@property (nonatomic, strong) NSString *hongbaoZhufu;

- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)okBtnAction:(id)sender;
- (IBAction)wxBtnAction:(id)sender;
- (IBAction)pyBtnAction:(id)sender;

- (IBAction)tapClicked:(id)sender;

@end
