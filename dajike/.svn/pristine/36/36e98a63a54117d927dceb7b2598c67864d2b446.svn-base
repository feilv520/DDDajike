//
//  MySelectView.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


//   全部晒图，，全部评论  选择view

#import "MySelectView.h"
#import "defines.h"

@implementation MySelectView

@synthesize myDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_gray4;
//        self.layer.cornerRadius = 3.0f;
//        self.layer.masksToBounds = YES;
        _nCurSelIndex = 0;
        _selectItemArr = [[NSMutableArray alloc]init];
//        NSArray *titleArray = [[NSArray alloc]initWithObjects:@"评论",@"晒图", nil];
//        _nItemWidth = 80;
//        for (int i = 0; i < titleArray.count; i++) {
//            NSString *title = [titleArray objectAtIndex:i];
//            TwoSelectViews *itemView = [[TwoSelectViews alloc]initWithFrame:CGRectMake(i*_nItemWidth+0.5*(i+1), 0.5, _nItemWidth, self.frame.size.height-1)];
//            [itemView setTitle:title];
//            itemView.index = i;
//            itemView.mDelegate = self;
//            [self addSubview:itemView];
//            [_selectItemArr addObject:itemView];
//            
//            if (i == 0) {
//                [itemView setSeleted:YES];
//                itemView.backgroundColor = Color_mainColor;
//                itemView.lbTitle.textColor = [UIColor whiteColor];
//            }
//        }
    }
    
    return self;
}

- (void)setTitle:(NSMutableArray *)titleArray
{
//    _nItemWidth = WIDTH_CONTROLLER_DEFAULT;
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = [titleArray objectAtIndex:i];
        TwoSelectViews *itemView = [[TwoSelectViews alloc]initWithFrame:CGRectMake(i*_nItemWidth+0.6*i, 0.5, _nItemWidth, self.frame.size.height-1)];
        [itemView setTitle:title];
        itemView.index = i;
        itemView.mDelegate = self;
        [self addSubview:itemView];
        [_selectItemArr addObject:itemView];
        
        if (i == 0) {
            [itemView setSeleted:YES];
            itemView.backgroundColor = Color_mainColor;
            itemView.lbTitle.textColor = [UIColor whiteColor];
        }
    }
}

-(void)setSelectedIndex:(int)index
{
    _nCurSelIndex = index;
    for (int i=0; i<[_selectItemArr count]; i++)
    {
        TwoSelectViews *itemView = [_selectItemArr objectAtIndex:i];
        [itemView setSeleted:NO];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.lbTitle.textColor = [UIColor darkGrayColor];
        
        if (index == i)
        {
            [itemView setSeleted:YES];
            itemView.backgroundColor = Color_mainColor;
            itemView.lbTitle.textColor = [UIColor whiteColor];
        }
    }
}

-(int)getSelectedIndex
{
    return _nCurSelIndex;
}

#pragma mark - SelectedViewDelegate
- (void)selectedView:(TwoSelectViews *)twoSelectView selectedIndex:(int)index
{
    for (int i=0; i<[_selectItemArr count]; i++)
    {
        TwoSelectViews *itemView = [_selectItemArr objectAtIndex:i];
        [itemView setSeleted:NO];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.lbTitle.textColor = [UIColor darkGrayColor];
        
        if (index == i)
        {
            [itemView setSeleted:YES];
            itemView.backgroundColor = Color_mainColor;
            itemView.lbTitle.textColor = [UIColor whiteColor];
            
            _nCurSelIndex = i;
        }
    }
    
    
    if([myDelegate respondsToSelector:@selector(selectView:selectedIndex:)])
    {
        [myDelegate selectView:self selectedIndex:index];
    }
}

@end
