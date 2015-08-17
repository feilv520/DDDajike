//
//  SelectCityView.h
//  jibaobao
//
//  Created by dajike on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectCityViewDelegate;


@interface SelectCityView : UIView
@property (weak, nonatomic) id<SelectCityViewDelegate>myDelegate;
@property (assign, nonatomic) NSInteger selectCityTag;

- (void) addSubViewsWithCity:(NSString *)cityname;
@end


@protocol SelectCityViewDelegate <NSObject>

@optional
-(void)selectView:(SelectCityView *)mSelectView selectedIndex:(int)index;
- (void) changeCity;
//- (NSString *) currentSelectCity;

@end