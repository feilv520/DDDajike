//
//  DTabView.h
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//



//自定义tabBar上每个按钮

#import <UIKit/UIKit.h>

@interface DTabView : UIView

typedef void (^DTabViewClickedBlock)(DTabView *tabView);

@property (strong, nonatomic) UIImageView   *tabImgView;
@property (strong, nonatomic) UILabel       *tabLb;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *selectImgArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (strong, nonatomic) UILabel *numLb;

@property (strong, nonatomic) DTabViewClickedBlock block;

- (void)callBackTabViewClicked:(DTabViewClickedBlock)block;

- (void)setMainView:(NSInteger)selectIndex;

@end
