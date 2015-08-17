//
//  FilterViewController.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   购物--》筛选
 */

#import "BackNavigationViewController.h"

typedef void (^CallBackFilterBlock)(NSString *minPrice,NSString *maxPrice);

@interface FilterViewController : BackNavigationViewController<BarButtonDelegate>


@property (weak, nonatomic) IBOutlet UITextField *littleTf;
@property (weak, nonatomic) IBOutlet UITextField *bigTf;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;

@property (strong, nonatomic) CallBackFilterBlock block;

- (IBAction)okBtnAction:(id)sender;


- (void)callBackFilter:(CallBackFilterBlock)block;
@end
