//
//  TwoSelectViews.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedViewDelegate;

@interface TwoSelectViews : UIView<UIGestureRecognizerDelegate>
{
    int         _index;
    UILabel     *_lbTitle;
}
@property (assign, nonatomic) id<SelectedViewDelegate>mDelegate;
@property (assign, nonatomic) int index;
@property (strong, nonatomic) UILabel *lbTitle;

- (void)setTitle:(NSString *)title;
//- (void)setIcon:(NSString *)iconStr;
- (void)setSeleted:(BOOL)flag;


@end

@protocol SelectedViewDelegate <NSObject>

@optional

- (void)selectedView:(TwoSelectViews *)twoSelectView selectedIndex:(int)index;

@end