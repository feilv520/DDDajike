//
//  PayKeyBoardView.h
//  kyboard_pay
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 swb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnClickedBlock)(NSString *num);

@interface PayKeyBoardView : UIView

@property (strong, nonatomic) btnClickedBlock block;

- (void)callBackNumClicked:(btnClickedBlock)block;

@end
