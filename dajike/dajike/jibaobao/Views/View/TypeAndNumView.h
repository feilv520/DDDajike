//
//  TypeAndNumView.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickedBlock)(UIButton *btn);

@interface TypeAndNumView : UIView

@property (strong, nonatomic) UILabel   *typeLb;
@property (strong, nonatomic) UILabel   *numLb;

@property (strong, nonatomic) UIButton  *jiaBtn;
@property (strong, nonatomic) UIButton  *jianBtn;

@property (strong, nonatomic) UITextField *numTf;

@property (strong, nonatomic) BtnClickedBlock block;

- (void)callBackBtnClicked:(BtnClickedBlock)block;


@end
