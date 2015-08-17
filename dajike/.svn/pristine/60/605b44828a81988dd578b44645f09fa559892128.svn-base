//
//  UIView+MyView.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "UIView+MyView.h"
#import "defines.h"

@implementation UIView (MyView)

- (UILabel *)creatLabelWithFrame:(CGRect)frame AndFont:(int)font AndBackgroundColor:(UIColor *)backgroundColor AndText:(NSString *)text AndTextAlignment:(NSTextAlignment)textAlignment AndTextColor:(UIColor *)textColor andCornerRadius:(CGFloat)cornerRadius
{
    UILabel*label = [[UILabel alloc]initWithFrame:frame];
    label.numberOfLines = 0;
    label.textAlignment = textAlignment;
    label.backgroundColor = backgroundColor;
    label.font = [UIFont systemFontOfSize:font];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = textColor;
    label.text = text;
    label.clipsToBounds = YES;
    label.layer.cornerRadius = cornerRadius;
    return label;
}
- (UIButton*)createButtonWithFrame:(CGRect)frame andBackImageName:(NSString *)imageName andTarget:(id)target andAction:(SEL)action andTitle:(NSString *)title andTag:(int)tag
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.layer.borderWidth = 0;
    return button;
}
- (UIImageView*)createImageViewWithFrame:(CGRect)frame andImageName:(NSString *)imageName
{
    UIImageView*imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.userInteractionEnabled = YES;
    return imageView;
}
- (UIView*)createViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor
{
    UIView*view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view ;
}
- (UITextField*)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder andPassWord:(BOOL)YESorNO andLeftImageView:(UIImageView *)imageView andRightImageView:(UIImageView *)rightImageView andFont:(float)font
{
    UITextField*textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.secureTextEntry = YESorNO;
    textField.borderStyle = UITextBorderStyleNone;
//    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocapitalizationType = NO;
//    textField.clearButtonMode = YES;
    textField.leftView = imageView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.rightView = rightImageView;
//    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:font];
    textField.textColor = [UIColor blackColor];
    return textField;
    
}

#pragma mark------- Label的自适应 ----------
- (CGRect)contentAdaptionLabel:(NSString *)string withSize:(CGSize)frameSize withTextFont:(CGFloat)fontSize
{
    CGRect rect;
    if (IS_IOS6) {
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:frameSize lineBreakMode:NSLineBreakByCharWrapping];
        rect.size = size;
    }
    else
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        rect = [string boundingRectWithSize:frameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    }
    return rect;
}

@end
