//
//  Choujiang01Cell.m
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "Choujiang01Cell.h"
@interface Choujiang01Cell()
@property (weak, nonatomic) IBOutlet UIView *bgV0;
@property (weak, nonatomic) IBOutlet UIView *bgV1;

@end
@implementation Choujiang01Cell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choujiang_bg.png"]];
    self.bgV0.layer.cornerRadius = 9.0;
    self.bgV1.layer.cornerRadius = 4.0;
    self.label11.layer.masksToBounds = YES;
    self.label21.layer.masksToBounds = YES;
    self.label31.layer.masksToBounds = YES;
    self.label11.layer.cornerRadius = 10.0;
    self.label21.layer.cornerRadius = 10.0;
    self.label31.layer.cornerRadius = 10.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//播报动画
- (void) bobaoAnimation
{
    CGRect frame = self.bobaoLabel.frame;
    frame.origin.y = 0;
//    frame.size.height = 18;
    [self.bobaoLabel setFrame:frame];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"y0-%f",self.bobaoLabel.frame.origin.y);
        CGRect frame = self.bobaoLabel.frame;
        frame.origin.y = -10;
        [self.bobaoLabel setFrame:frame];
        NSLog(@"y1-%f",self.bobaoLabel.frame.origin.y);
        self.bobaoLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        NSLog(@"y2-%f",self.bobaoLabel.frame.origin.y);
        self.bobaoLabel.alpha = 0.0f;
        [self setBoBaoModel11:_boBaoModel];
        CGRect frame = self.bobaoLabel.frame;
        frame.origin.y = 10;
        [self.bobaoLabel setFrame:frame];
        NSLog(@"y3-%f",self.bobaoLabel.frame.origin.y);
        self.bobaoLabel.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            NSLog(@"y4-%f",self.bobaoLabel.frame.origin.y);
            CGRect frame = self.bobaoLabel.frame;
            frame.origin.y = 0;
            [self.bobaoLabel setFrame:frame];
            NSLog(@"y5-%f",self.bobaoLabel.frame.origin.y);
            self.bobaoLabel.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            NSLog(@"Yes");
            NSLog(@"y6-%f",self.bobaoLabel.frame.origin.y);
            CGRect frame = self.bobaoLabel.frame;
            frame.origin.y = 0;
            //    frame.size.height = 18;
            [self.bobaoLabel setFrame:frame];
        }];
    }];

}

- (void) setBoBaoModel11:(ZhongJiangTopModel *)model
{
    NSMutableString *userPhone = [[NSMutableString alloc]initWithString:model.userName];
    NSString *str = [NSString stringWithFormat:@"中奖播报%@****%@%@%@",[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2],model.jine,model.choujiangDate];
    NSInteger konggeLength = (57 - str.length)/3;
    NSMutableString *strKongge = [[NSMutableString alloc]init];
    for (int i = 0; i < konggeLength; i++) {
        [strKongge appendString:@" "];
    }
    self.bobaoLabel.text = [NSString stringWithFormat:@"中奖播报%@%@****%@%@%@%@%@",strKongge,[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2],strKongge,model.jine,strKongge,model.choujiangDate];
}

- (void) setTopModel0:(ZhongJiangTopModel *) model
{
    NSMutableString *userPhone = [[NSMutableString alloc]initWithString:model.userName];
    self.label12.text = [NSString stringWithFormat:@"%@****%@",[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2]];
    self.label13.text = [NSString stringWithFormat:@"%.2f元",[model.jine floatValue]];
    
}
- (void) setTopModel1:(ZhongJiangTopModel *) model
{
    NSMutableString *userPhone = [[NSMutableString alloc]initWithString:model.userName];
    self.label22.text = [NSString stringWithFormat:@"%@****%@",[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2]];
    self.label23.text = [NSString stringWithFormat:@"%.2f元",[model.jine floatValue]];
}
- (void) setTopModel2:(ZhongJiangTopModel *) model
{
    NSMutableString *userPhone = [[NSMutableString alloc]initWithString:model.userName];
    self.label32.text = [NSString stringWithFormat:@"%@****%@",[userPhone substringToIndex:3],[userPhone substringFromIndex:userPhone.length-2]];
    self.label33.text = [NSString stringWithFormat:@"%.2f元",[model.jine floatValue]];
}

@end
