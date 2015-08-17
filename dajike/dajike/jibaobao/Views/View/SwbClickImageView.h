//
//  SwbClickImageView.h
//  jibaobao
//
//  Created by swb on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwbClickImageView : UIImageView

typedef void (^CallbackClickedBlock)(SwbClickImageView *clickImgView);

@property (strong, nonatomic) CallbackClickedBlock block;
@property (nonatomic, strong) id identifier;

- (void)callBackImgViewClicked:(CallbackClickedBlock)block;

@end
