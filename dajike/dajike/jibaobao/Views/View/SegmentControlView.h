//
//  SegmentControlView.h
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    GOODSLIST_C,//商品分类列表
    PLACELIST_C,//地点列表
    SORTRULELIST_C,//排序规则列表
} ProductType;

@protocol SegmentDelegate <NSObject>

- (void)segment:(int)actionIndex diction:(NSDictionary *)dict;

@end

@interface SegmentControlView : UIView
@property (weak, nonatomic) IBOutlet UIButton *segment1Button;
@property (weak, nonatomic) IBOutlet UIButton *segment2Button;
@property (weak, nonatomic) IBOutlet UIButton *segment3Button;
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) NSDictionary *typeList;
@property (nonatomic) ProductType productType;
@property (nonatomic, weak) id<SegmentDelegate> delegate;
- (IBAction)segmentButtonClicked:(id)sender;

@end
