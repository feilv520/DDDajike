//
//  AllCommentPhotoViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
    类：  全部评论和全部图片
 */

#import "BackNavigationViewController.h"
#import "MySelectView.h"
#import "DMLazyScrollView.h"

@interface AllCommentPhotoViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *publicId;
@property (strong, nonatomic) NSString *flagStr;

//<DMLazyScrollViewDelegate,ViewSelectDelegate,BarButtonDelegate>
//{
//    MySelectView        *_mySelectView;
//    DMLazyScrollView    *_lazyScrollView;
//    NSMutableArray      *_viewControllerArray;
//}

@end
