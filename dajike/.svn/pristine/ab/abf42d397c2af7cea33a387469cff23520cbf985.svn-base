//
//  DTools.m
//  dajike
//
//  Created by dajike on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DTools.h"


@implementation DTools

//获取nib cell 重用
+ (id) loadTableViewCell:(UITableView *)tableView cellClass:(Class)objClass
{
    NSString *  nibName  = [NSString stringWithFormat:@"%s",object_getClassName(objClass)];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

//获取非nib cell 重用
+ (id) loadNotNibTableViewCell:(UITableView *)tableView cellClass:(Class)objClass
{
    NSString *  cellName  = [NSString stringWithFormat:@"%s",object_getClassName(objClass)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}


//获取nib cell 非重用
+ (id) loadTableViewWithoutChongyongCell:(UITableView *)tableView cellClass:(Class)objClass
{
    NSString *  nibName  = [NSString stringWithFormat:@"%s",object_getClassName(objClass)];
    
    [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    return cell;
}
//UIButton 字体 颜色 背景色
+ (void)setButtton:(UIButton *)but Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor{
    but.titleLabel.font = font;
    [but setTitleColor:titleColor forState:UIControlStateNormal];
    but.backgroundColor = backColor;
}
//UILabel 字体 颜色 背景色
+ (void)setLable:(UILabel *)lab Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor{
    lab.font = font;
    lab.textColor = titleColor;
    lab.backgroundColor = backColor;
}
//UITextfield 字体 颜色 背景色
+ (void)setTextfield:(UITextField *)textfield Font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor{
    textfield.font = font;
    textfield.textColor = titleColor;
    textfield.backgroundColor = backColor;
}

@end
