//
//  DSelectCityView.h
//  dajike
//
//  Created by dajike on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DSelectCityViewDelegate;
@interface DSelectCityView : UIView

@property (weak, nonatomic) id<DSelectCityViewDelegate>myDelegate;
//@property (assign, nonatomic) NSInteger selectCityTag;

- (void) addSubViewsWithCity:(NSDictionary *)cityDic;
@end


@protocol DSelectCityViewDelegate <NSObject>

@optional
-(void)selectView:(DSelectCityView *)mSelectView selectedIndex:(int)index;
- (void) changeCity;
@end