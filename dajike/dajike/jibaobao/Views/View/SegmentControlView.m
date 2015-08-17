//
//  SegmentControlView.m
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SegmentControlView.h"
#import "SegmentMenuView.h"
#import "FoodViewController.h"

@interface SegmentControlView()<SegmentMenuDelegate>
{
    SegmentMenuView *segmentMenuView;
    BOOL isMenuOpened;
    SegmentType currentSegType;
}
- (void)showMenu:(SegmentType)type currentSelect:(NSString *)currentSelected;
- (void)hideMenu;
- (void)layoutSegmentButton;
@end

@implementation SegmentControlView
- (id) init
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SegmentControlView" owner:nil options:nil];
    
    if ([[topLevelObjects objectAtIndex:0] isKindOfClass:[SegmentControlView class]]) {
        self = (SegmentControlView*) [topLevelObjects objectAtIndex:0];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
#pragma mark - private

- (void)showMenu:(SegmentType)type currentSelect:(NSString *)currentSelected
{
    if (isMenuOpened) {
        [self hideMenu];
    }
    segmentMenuView = [[SegmentMenuView alloc] init];
    segmentMenuView.delegate = self;
    [segmentMenuView setFrame:CGRectMake(0, 38, 320, [UIScreen mainScreen].bounds.size.height - 38)];
    segmentMenuView.segmentType = type;
//    segmentMenuView.currentSelected = currentSelected;
    segmentMenuView.segmentArray = nil;
    if (type == GOODSLIST) {
        segmentMenuView.segmentArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
        segmentMenuView.segmentArray1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }else if(type == PLACELIST){
        segmentMenuView.segmentArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
        segmentMenuView.segmentArray1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }else if(type == SORTRULELIST){
        segmentMenuView.segmentArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    [self.parentViewController.view addSubview:segmentMenuView];
//     [self addSubview:segmentMenuView];
}
- (void)hideMenu
{
    [segmentMenuView removeFromSuperview];
    segmentMenuView = nil;
    isMenuOpened = NO;
}
- (void)layoutSegmentButton
{
}

#pragma mark - SegmentMenuDelegate

- (void)selectedSegment:(NSInteger)selectIndex tagType:(SegmentType)type
{
    NSLog(@"%s",__func__);
}
- (void)dismissMenu
{
    [self hideMenu];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - IBActions
- (IBAction)segmentButtonClicked:(id)sender {
    UIButton *segmentButton = (UIButton *)sender;
    SegmentType setype;
    switch (segmentButton.tag) {
        case 0:
            setype = GOODSLIST;
            break;
        case 1:
            setype = PLACELIST;
            break;
        case 2:
            setype = SORTRULELIST;
            break;
        default:
            break;
    }
    
    if (!isMenuOpened) {
        [self showMenu:setype currentSelect:segmentButton.titleLabel.text];
    }
    
}
@end
