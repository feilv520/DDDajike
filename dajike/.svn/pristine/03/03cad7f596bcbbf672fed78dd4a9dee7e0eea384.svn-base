//
//  MySelectView.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

//   全部晒图，，全部评论  选择view

#import <UIKit/UIKit.h>
#import "TwoSelectViews.h"
@protocol ViewSelectDelegate;

@interface MySelectView : UIView<SelectedViewDelegate>
{
//    UIView          *_selectView;
    NSMutableArray  *_selectItemArr;
    int             _nItemWidth;
    int             _nCurSelIndex;
}

@property (assign, nonatomic) int nItemWidth;

@property (assign, nonatomic) id<ViewSelectDelegate>myDelegate;

- (void)setSelectedIndex:(int)index;
- (int)getSelectedIndex;
- (void)setTitle:(NSMutableArray *)titleArray;

@end

@protocol ViewSelectDelegate <NSObject>

@optional
-(void)selectView:(MySelectView *)mSelectView selectedIndex:(int)index;

@end