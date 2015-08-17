//
//  RecommendFoodViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
     类：  推荐菜
 */

#import "RecommendFoodViewController.h"
#import "RecommendFoodCell.h"
#import "defines.h"
#import "GoodsListModel.h"

static NSString *Cellidentifier = @"identifierCell";

@interface RecommendFoodViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataArray;
    int     _page;
}

@end

@implementation RecommendFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"推荐商品";
    //重新加载数据。一切都重新初始化
    isEnd = NO;
    _page = 0;
    
    [self addTableView:UITableViewStylePlain];
    
    self.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.delegate = self;
    _dataArray = [[NSMutableArray alloc]init];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"RecommendFoodCell" bundle:nil] forCellReuseIdentifier:Cellidentifier];
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self addHeaderAndFooter];
    NSLog(@"测试");
    [self updateGoodsRecomdGoods:YES andIsSuccess:^(BOOL finish) {
        
    }];
}

//推荐菜
- (void)updateGoodsRecomdGoods:(BOOL)isFirst andIsSuccess:(void (^)(BOOL finish))success
{
    //164 499-520 环境154
    //162 164 231 499-513 环境127
    NSString *storeId = @"";
    if (self.shopDetailInfoModel.store_id) {
        storeId = self.shopDetailInfoModel.store_id;
    }
    if (self.couponModel.store_id) {
        storeId = self.couponModel.store_id;
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:storeId,@"storeId", [NSString stringWithFormat:@"%d",_page+1],@"page", @"10",@"pageSize",nil];
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"Stores.tuiJianGoods" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
//        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        if (responseObject.succeed) {
            NSMutableArray *temArray = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i = 0; i < temArray.count; i++) {
                GoodsListModel *temModel = [[GoodsListModel alloc]init];
                temModel = [JsonStringTransfer dictionary:temArray[i] ToModel:temModel];
                [_dataArray addObject:temModel];
            }
            _page = [[responseObject.result objectForKey:@"page"] intValue];
            [self.mainTabview reloadData];
        }else{
            if (responseObject.msg) {
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
            
        }
        if (_page >= [[responseObject.result objectForKey:@"totalPage"] integerValue]) {
            isEnd = YES;
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        success(NO);
    }];

}
//---------------------- 我是分割线，代码开始 ----------------------

#pragma mark   TableView  DataSource   &   Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFoodCell *mCell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier];
    if (_dataArray.count>0) {
        mCell.goodsListModel = _dataArray[indexPath.row];
    }
    return mCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"您点击了第%ld行",(long)indexPath.row);
}


#pragma  mark--------MJREfresh---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:100 High:80];
        success(YES);
    }else {
        [self updateGoodsRecomdGoods:NO andIsSuccess:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    //重新加载数据。一切都重新初始化
    isEnd = NO;
    _page = 0;
    [_dataArray removeAllObjects];
    _dataArray = nil;
    _dataArray = [[NSMutableArray alloc]init];
    
    //    [_couponArr removeAllObjects];
    //    _couponArr = nil;
    //    _couponArr = [[NSMutableArray alloc]init];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
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
