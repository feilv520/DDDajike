//
//  AllProductSortCell.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AllProductBlock)(int btnTag);

@interface AllProductSortCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCon;
@property (strong, nonatomic) AllProductBlock block;

- (IBAction)seachAllBtnAction:(id)sender;

- (void)callBackAllProduct:(AllProductBlock)blcok;


@end
