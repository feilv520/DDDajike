//
//  CommentStarView.m
//  jibaobao
//
//  Created by swb on 15/6/2.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CommentStarView.h"
#import "commonTools.h"

@implementation CommentStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
//星星评论
- (void)layoutCommentStar:(NSString *)star
{
    for(int i = 0;i<5;i++)
    {
        UIImageView *iv = [[UIImageView alloc]init];
        iv.frame = CGRectMake(10+19*i, 5, 15, 15);
        iv.image = [UIImage imageNamed:@"img_xingxing_03"];
        [self addSubview:iv];
        if (i<[star intValue]) {
            iv.image = [UIImage imageNamed:@"img_xingxing_02"];
        }
        if (![star isEqualToString:@"<null>"]) {
            if (![commonTools isPureInt:[NSString stringWithFormat:@"%@",star]]) {
                if (i == [star intValue]) {
                    iv.image = [UIImage imageNamed:@"img_xingxing_04"];
                }
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
