//
//  DShouyeButtonsaView.h
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JShouyeButtonsaViewDelegate <NSObject>

@optional
- (void)ShouyeButtonClicked:(id)sender;
@end
@interface JShouyeButtonsaView : UIView
@property (nonatomic, weak) id<JShouyeButtonsaViewDelegate> delegate;
@end
