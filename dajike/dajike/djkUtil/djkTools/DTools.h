//
//  DTools.h
//  dajike
//
//  Created by dajike on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DTools : NSObject
//获取nib cell 重用
+ (id) loadTableViewCell:(UITableView *)tableView cellClass:(Class)objClass;
//获取nib cell 非重用
+ (id) loadTableViewWithoutChongyongCell:(UITableView *)tableView cellClass:(Class)objClass;
//获取非nib cell 重用
+ (id) loadNotNibTableViewCell:(UITableView *)tableView cellClass:(Class)objClass;
//UIButton 字体 颜色 背景色
+ (void)setButtton:(UIButton *)but Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor;
//UILabel 字体 颜色 背景色
+ (void)setLable:(UILabel *)lab Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor;
//UITextfield 字体 颜色 背景色
+ (void)setTextfield:(UITextField *)textfield Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor;
@end