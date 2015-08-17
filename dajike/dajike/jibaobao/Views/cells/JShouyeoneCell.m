//
//  JShouyeoneCell.m
//  jibaobao
//
//  Created by dajike on 15/5/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeoneCell.h"

@implementation JShouyeoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void) addimageAndTitle
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
    CGFloat height = 138;
    NSArray *arr = @[
                     @{
                         @"imageName" : @"img_shouye_01.png",
                         @"titlename" : @"美食",
                         },
                     @{
                         @"imageName" : @"img_shouye_02.png",
                         @"titlename" : @"购物",
                         },
                     @{
                         @"imageName" : @"img_shouye_03.png",
                         @"titlename" : @"休闲娱乐",
                         },
                     @{
                         @"imageName" : @"img_shouye_04.png",
                         @"titlename" : @"丽人",
                         },
                     @{
                         @"imageName" : @"img_shouye_05.png",
                         @"titlename" : @"绿色特产",
                         },
                     @{
                         @"imageName" : @"img_shouye_06.png",
                         @"titlename" : @"家居家纺",
                         },
                     @{
                         @"imageName" : @"img_shouye_07.png",
                         @"titlename" : @"生活服务",
                         },
                     @{
                         @"imageName" : @"img_shouye_08.png",
                         @"titlename" : @"红包",
                         }
                     ];
    for (int i = 0; i < 8; i ++) {
        CGFloat origeY;
        CGFloat origeX;
        if (i > 3) {
            int x = (i-4)%4;
            origeY = height/2.0;
            origeX = x*(width/4.0);
        }else{
            int x = i%4;
            origeY = 0;
            origeX = x*(width/4.0);
        }
        //            JShouyeaButton *btn = [[JShouyeaButton alloc]initWithFrame:CGRectMake(((i-(i/4)*4)%4)*(width/4),  origeY, width/4, height/2)];
        JShouyeaButton *btn = [[JShouyeaButton alloc]initWithFrame:CGRectMake(origeX,  origeY, width/4.0, height/2.0)];
        NSLog(@"%d = %f,%f,%f,%f",i,btn.frame.origin.x,btn.frame.origin.y,btn.frame.size.width,btn.frame.size.height);
                    [btn setButtonImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i]objectForKey:@"imageName"]]] andButtonTitle:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i]objectForKey:@"titlename"]]];
//        [btn setButtonImage:[UIImage imageNamed:@"ico.png"] andButtonTitle:@"sfdfdg"];
        [btn setTag:i];
        [btn addTarget:self action:@selector(toBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }

}
- (void) toBtn:(id)sender
{
    JShouyeaButton *btn = (JShouyeaButton *)sender;
    if(self.delegate)
    {
        [self.delegate JShouyeoneCellButtonCliped:sender];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
