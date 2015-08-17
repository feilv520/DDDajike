//
//  DTuijianGoogsViewController.h
//  dajike
//
//  Created by dajike on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "DZiyingsCategoryModel.h"

@interface DTuijianGoogsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isEnd;
}
@property (retain, nonatomic)UITableView *mainTableView;
@property (retain, nonatomic) UIImageView *noDataView;

@property (retain, nonatomic) MJRefreshGifHeader *header;
@property (retain, nonatomic) MJRefreshBackNormalFooter *footer;

@property (retain, nonatomic) DZiyingsCategoryModel *ziyingModel;

@property (assign, nonatomic) BOOL isTuijian;

@end
