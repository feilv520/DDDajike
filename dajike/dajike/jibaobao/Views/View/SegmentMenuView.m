//
//  SegmentMenuView.m
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SegmentMenuView.h"
#import "SegmentMenuCell.h"
@interface SegmentMenuView()

- (SegmentMenuCell *)loadSegmentMenuCell:(UITableView *)tableView;

@end
@implementation SegmentMenuView
- (id) init
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SegmentMenuView" owner:nil options:nil];
    
    if ([[topLevelObjects objectAtIndex:0] isKindOfClass:[SegmentMenuView class]]) {
        self = (SegmentMenuView*) [topLevelObjects objectAtIndex:0];
    }
    self.segmentType = SORTRULELIST;
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
    
    [self setBackgroundColor:[UIColor whiteColor]];
    if (self.segmentType == GOODSLIST) {
        [self.tableViewList0 setHidden:YES];
        [self.tableViewList1 setHidden:NO];
        [self.tableViewList2 setHidden:NO];
    }else if(self.segmentType == PLACELIST){
        [self.tableViewList0 setHidden:YES];
        [self.tableViewList1 setHidden:NO];
        [self.tableViewList2 setHidden:NO];
    }else if (self.segmentType == SORTRULELIST){
        [self.tableViewList0 setHidden:NO];
        [self.tableViewList1 setHidden:YES];
        [self.tableViewList2 setHidden:YES];
    }
}
#pragma mark - private

- (SegmentMenuCell *)loadSegmentMenuCell:(UITableView *)tableView
{
    NSString * const nibName  = @"SegmentMenuCell";
    
    SegmentMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableViewList0]) {
        
    }else if ([tableView isEqual:self.tableViewList1]) {
//        if (self.segmentType == GOODSLIST) {
//            SegmentMenuCell *cell = [self loadSegmentMenuCell:tableView];
//            cell.titleLabel.text = @"美食";
//        }else if(self.segmentType == PLACELIST){
//            
//        }
    }else if ([tableView isEqual:self.tableViewList2]) {
        
    }
//    if (self.segmentType == GOODSLIST) {
//        
//    }else if(self.segmentType == PLACELIST){
//        
//    }else if (self.segmentType == SORTRULELIST){
//        
//    }
    return 5;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableViewList0]) {
        static NSString *identifer = @"pcell";
        UITableViewCell *pcell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (pcell == nil) {
            pcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        }
        pcell.textLabel.text = @"智能排序";
        return pcell;
    }else if ([tableView isEqual:self.tableViewList1]) {
        if (self.segmentType == GOODSLIST) {
            SegmentMenuCell *cell = [self loadSegmentMenuCell:tableView];
            cell.titleLabel.text = @"美食";
            return cell;
        }else if(self.segmentType == PLACELIST){
            static NSString *identifer = @"pcell";
            UITableViewCell *pcell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (pcell == nil) {
                pcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
            }
            pcell.textLabel.text = @"卢湾区";
            return pcell;
        }
    }else if ([tableView isEqual:self.tableViewList2]) {
        static NSString *identifer = @"pcell";
        UITableViewCell *pcell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (pcell == nil) {
            pcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        }
        pcell.textLabel.text = @"500m";
        return pcell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.delegate != nil) {
//        
//        [self.delegate selectedSegment:indexPath.row tagType:self.segmentType];
//    }
}
#pragma mark - UIResponder

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.delegate != nil) {
//        
//        [self.delegate dismissMenu];
//    }
//}
#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
