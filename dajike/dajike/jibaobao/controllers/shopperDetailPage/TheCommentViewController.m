//
//  TheCommentViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
     类： 全部评论
 */

#import "TheCommentViewController.h"

@interface TheCommentViewController ()
{
    UITableView *_mTableView;
}

@end

@implementation TheCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addTableView];
    
}
// -------------------------分割线-----------------------------

- (void)addTableView
{
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
