//
//  JShouyeMainViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "NavigationViewController.h"

@interface JShouyeMainViewController : NavigationViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
