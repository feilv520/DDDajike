//
//  DrawResultView.h
//  jibaobao
//
//  Created by dajike on 15/6/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawResultView : UIView
@property (retain, nonatomic) UIButton * closeButton;
//+ (DrawResultView *) sharedDrawResultView;
//- (void) show;
//- (void) close;
- (void) setResultWithArr:(NSArray *)resultArr;
@end
