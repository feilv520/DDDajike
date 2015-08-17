//
//  PayPopView.h
//  kyboard_pay
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 swb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClickLb.h"

typedef void (^HiddenPayViewBlock)(int flag,NSString *password);

@interface PayPopView : UIView

@property (strong, nonatomic) UILabel *jineLb;
@property (strong, nonatomic) MyClickLb *mimaLb;

@property (strong, nonatomic) HiddenPayViewBlock block;

- (void)callbackHidden:(HiddenPayViewBlock)block;

@end
