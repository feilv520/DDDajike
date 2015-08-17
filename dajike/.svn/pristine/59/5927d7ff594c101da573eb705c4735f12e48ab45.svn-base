//
//  JShouyeTwoCell.m
//  jibaobao
//
//  Created by dajike on 15/5/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeTwoCell.h"
#import "defines.h"

@implementation JShouyeTwoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width-20;
        CGFloat height = 113;
//        CGFloat height = self.frame.size.height;
//        NSArray *arr = @[
//                         @{
//                             @"imageName" : @"ico.png",
//                             @"titlename" : @"111111111",
//                             },
//                         @{
//                             @"imageName" : @"ico.png",
//                             @"titlename" : @"22222222",
//                             },
//                         @{
//                             @"imageName" : @"ico.png",
//                             @"titlename" : @"22222222",
//                             }
//                         ];
        CGFloat pingjunWidth = width/3;
        self.btn1 = [[JShouyeLimitDiscountButton alloc]initWithFrame:CGRectMake((0*width/3)+10, 25+5, pingjunWidth, height-25+10+10+15+30)];
         self.btn2 = [[JShouyeLimitDiscountButton alloc]initWithFrame:CGRectMake((1*width/3)+10, 25+5, pingjunWidth, height-25+10+10+15+30)];
         self.btn3 = [[JShouyeLimitDiscountButton alloc]initWithFrame:CGRectMake((2*width/3)+10, 25+5, pingjunWidth, height-25+10+10+15+30)];
        
        [self.btn1 setTag:0];
        [self.btn2 setTag:1];
        [self.btn3 setTag:2];
//        [self.btn1 addTarget:self action:@selector(toBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btn2 addTarget:self action:@selector(toBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btn3 addTarget:self action:@selector(toBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.btn3];
        
        UILabel *Label;
        if (!Label) {
            Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 3, 150, 20)];
            [Label setFont:Font_Default];
            [Label setTextColor:Color_Green_oldPrice_];
            [Label setTextAlignment:NSTextAlignmentLeft];
            [Label setBackgroundColor:Color_Clear];
        }
        [Label setText:@"限时优惠"];
        [self addSubview:Label];
        
    }
    return self;
}

//- (void) toBtns:(id) sender
//{
//    
//}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
