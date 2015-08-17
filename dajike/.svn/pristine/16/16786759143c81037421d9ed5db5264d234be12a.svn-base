//
//  SegmentButtonsView.h
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SegmentButtonsViewDelegate <NSObject>

@optional
- (void)SegmentButtonsClicked:(id)sender;
@end

@interface SegmentButtonsView : UIView
@property (nonatomic, weak) id<SegmentButtonsViewDelegate> delegate;
@property (nonatomic, weak) UIColor * selectColor;
@property (nonatomic, weak) UIColor * defaultColor;
- (void) drawSegmentButtonsWithArrs:(NSArray*)titleArr andSelectColor:(UIColor*)selectColor andUnSelectColor:(UIColor*)defaultColor andSelectIndex:(NSInteger)selectIndex;
@end
