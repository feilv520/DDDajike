//
//  UIView+MyView.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MyView)<UIAlertViewDelegate>

#pragma mark --  创建Label

- (UILabel *)creatLabelWithFrame:(CGRect)frame AndFont:(int)font AndBackgroundColor:(UIColor *)backgroundColor AndText:(NSString *)text AndTextAlignment:(NSTextAlignment)textAlignment AndTextColor:(UIColor *)textColor andCornerRadius:(CGFloat)cornerRadius;

#pragma mark - 创建View

- (UIView *)createViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor;

#pragma mark --  创建ImageView

- (UIImageView *)createImageViewWithFrame:(CGRect)frame andImageName:(NSString *)imageName;

#pragma mark --  创建button

- (UIButton *)createButtonWithFrame:(CGRect)frame andBackImageName:(NSString *)imageName andTarget:(id)target andAction:(SEL)action andTitle:(NSString*)title andTag:(int)tag;

#pragma mark --创建UITextField

- (UITextField *)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)placeholder andPassWord:(BOOL)YESorNO andLeftImageView:(UIImageView*)leftImageView andRightImageView:(UIImageView*)rightImageView andFont:(float)font;

#pragma mark --  label自适应
//Label自适应
- (CGRect)contentAdaptionLabel:(NSString *)string withSize:(CGSize)frameSize withTextFont:(CGFloat)fontSize;

@end
