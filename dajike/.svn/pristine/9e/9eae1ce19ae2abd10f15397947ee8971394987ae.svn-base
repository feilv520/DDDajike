//
//  SegmentMenuView.h
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GOODSLIST,//商品分类列表
    PLACELIST,//地点列表
    SORTRULELIST,//排序规则列表
    
} SegmentType;

@protocol SegmentMenuDelegate <NSObject>

@optional

- (void)selectedSegment:(NSInteger)selectIndex tagType:(SegmentType)type;
- (void)dismissMenu;

@end

@interface SegmentMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewList0;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList1;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList2;
@property (nonatomic, weak) NSString *currentSelected;
@property (nonatomic) SegmentType segmentType;
@property (nonatomic, weak) id<SegmentMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *segmentArray;
@property (nonatomic, strong) NSArray *segmentArray1;

@end
