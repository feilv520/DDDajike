//
//  PYTabbar.h
//  eBPMApp
//
//  Created by Apple on 14-7-17.
//  Copyright (c) 2014年 haixia. All rights reserved.
//


//导航栏下方tabbar的封装
#import <UIKit/UIKit.h>
extern const CGFloat kFilterViewHeight;
extern const CGFloat kAnimationSpeed;

@class PYTabbar;
@protocol PYTabbarDelegate <NSObject>
@required
//The delegare must implement this method to perform actions regarding the newly selected index
- (void)filterView:(PYTabbar *)filterView didSelectedAtIndex:(NSInteger)index;

@optional
//If the delegate implement this method it can return a custom animation speed for the hide/unhide
- (CGFloat)filterViewDisplayAnimatioSpeed:(PYTabbar *)filterView;
//If the delegate implement this methid it can return a custom animation speed for the selection
- (CGFloat)filterViewSelectionAnimationSpeed:(PYTabbar *)filterView;
//Implement this method to know when the selection animation begin
- (void)filterViewSelectionAnimationDidBegin:(PYTabbar *)filterView;
//Implement this method to know when the selection animation end
- (void)filterViewSelectionAnimationDidEnd:(PYTabbar *)filterView;
@end

@interface PYTabbar : UIView
{
    id<PYTabbarDelegate> __unsafe_unretained  _delegate;
}

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, unsafe_unretained) id<PYTabbarDelegate>delegate;

@property (nonatomic, readonly, assign) UIView *containerView;
//You can set a background image, the background image will remove the background color.
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;
//The selected background image behind the selected button.
//The selected background color is set to nil if you set an image
@property (nonatomic, strong) UIImage *selectedItemBackgroundImage;
//The selected background color behind the selected button
//The selected background image is set to nil if you set a color
@property (nonatomic, strong) UIColor *selectedItemBackgroundColor;
//The selected background color at the top of the selected item
//Is set to nil if you set a selected backround image
@property (nonatomic, strong) UIColor *selectedItemTopBackgroundColor;
//The selected background top color height;
//Default value is 5
@property (nonatomic) CGFloat selectedItemTopBackroundColorHeight;
//The buttons title color
@property (nonatomic, strong) UIColor *titlesColor;
@property (nonatomic, strong) UIColor *selectedTitlesColor;
//The buttons font
@property (nonatomic, strong) UIFont *titlesFont;
//The inset of the title
@property (nonatomic) UIEdgeInsets titleInsets;

//Is the selected button is draggable. Default is YES.
@property (nonatomic, getter = isDraggable) BOOL draggable;


- (id)initWithStrings:(NSArray *)strings
             andFrame:(CGRect)frame containerView:(UIView *)contrainerView;
- (void)attachToContainerView;
- (void)hide:(BOOL)hide
    animated:(BOOL)animated
animationCompletion:(void (^)(void))completion;
- (void)applyDefaultStyle;
- (NSString *)titleAtIndex:(NSInteger)index;
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;

@end
