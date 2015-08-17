//
//  TwoSelectViews.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "TwoSelectViews.h"
#import "UIView+MyView.h"


@implementation TwoSelectViews

@synthesize index = _index;
//@synthesize lbTitle = _lbTitle;
@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 3.0f;
//        self.layer.masksToBounds = YES;
        
        _lbTitle = [self creatLabelWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"" AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
        [self addSubview:_lbTitle];
        
        UITapGestureRecognizer *gensture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        gensture.delegate = self;
        [self addGestureRecognizer:gensture];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _lbTitle.text = title;
}
- (void)setSeleted:(BOOL)flag
{
    
}

#pragma mark - Button Actions
- (void)btnAction:(UIButton*)sender
{
    if([mDelegate respondsToSelector:@selector(selectedView:selectedIndex:)])
    {
        [mDelegate selectedView:self selectedIndex:_index];
    }
}

- (void)tapAction
{
    if([mDelegate respondsToSelector:@selector(selectedView:selectedIndex:)])
    {
        [mDelegate selectedView:self selectedIndex:_index];
    }
}

@end
