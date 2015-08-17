//
//  CollectViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CollectViewController.h"
#import "SegmentButtonsView.h"
#import "defines.h"
#import "DiscountCouponCell.h"
#import "BunessList1Cell.h"
#import "DiscountCouponEditCell.h"
#import "BunessList1CellEditCell.h"
#import "defines.h"
#import "ProductDetailViewController.h"
#import "CashCouponDetailViewController.h"
#import "FoodShopDetailViewController.h"

@interface CollectViewController ()<SegmentButtonsViewDelegate>
{
    NSMutableArray *couponDataArray;
    NSMutableArray *_couponDeleteArr;
    NSMutableArray *storeDataArray;
    NSMutableArray *_storeDeleteArr;
    
    //是否可编辑状态 YES：可编辑状态 NO：不可编辑状态
    BOOL itCanEdit;
    
    NSInteger couponPage;
    NSInteger shopPage;
    UIButton *_delateBtn;
    UISegmentedControl *_selectBtn;

}
@end

@implementation CollectViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"我的收藏";
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    itCanEdit = NO;
    
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    couponDataArray = [[NSMutableArray alloc]init];
    storeDataArray = [[NSMutableArray alloc]init];
    _couponDeleteArr = [[NSMutableArray alloc]init];
    _storeDeleteArr = [[NSMutableArray alloc]init];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.allowsSelectionDuringEditing = YES;
    
    [self addRightNavButton];
    couponPage = 1;
    shopPage = 1;
    [self refreshData:^(BOOL finish) {
    }];
    
    //首次进入时为优惠券
    self.collectType = COUPON;
    
    [self addHeaderAndFooter];
    
    [self addSelectBtnView];
    
}
#pragma mark------
#pragma mark------headView-------
- (void)addSelectBtnView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 50)];
    headView.backgroundColor = [UIColor colorWithRed:236.0 green:236.0 blue:236.0 alpha:1.0];
    
    NSArray * btnNames = @[@"优惠券",@"商家"];
    _selectBtn = [[UISegmentedControl alloc]initWithItems:btnNames];
    _selectBtn.frame = CGRectMake(10, 10, WIDTH_CONTROLLER_DEFAULT-20, 30);
    _selectBtn.selectedSegmentIndex = 0;
    _selectBtn.tintColor = Color_mainColor;
    [_selectBtn addTarget:self action:@selector(selectBtnChange:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:_selectBtn];
    [self.view addSubview:headView];
    
    CGRect frame = self.mainTabview.frame;
    frame.origin.y = self.mainTabview.frame.origin.y+50;
    frame.size.height = self.mainTabview.frame.size.height - 50;
    [self.mainTabview setFrame:frame];
    
}
- (void)selectBtnChange:(UISegmentedControl *)seg{
    
    itCanEdit = NO;
    _couponDeleteArr = [[NSMutableArray alloc]init];
    _storeDeleteArr = [[NSMutableArray alloc]init];
    [_delateBtn setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
    [self.mainTabview setEditing:NO animated:YES];
    
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.collectType = COUPON;
            if (couponPage == 1) {
                [self refreshData:^(BOOL finish) {
                }];
            }
            break;
        case 1:
            self.collectType = SHOPS;
            if (shopPage == 1) {
                [self refreshData:^(BOOL finish) {
                }];
            }
            break;
        default:
            break;
    }
    
    [self.mainTabview reloadData];
}

- (void) addRightNavButton
{
    //添加编辑按钮  右上方
    _delateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_delateBtn setImage:[UIImage imageNamed:@"img_editor_h"] forState:UIControlStateNormal];
    [_delateBtn addTarget:self action:@selector(rightNavButtonClip:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_delateBtn];
}
//编辑按钮事件
- (void) rightNavButtonClip:(id)sender
{
    if (itCanEdit) {
        if (_storeDeleteArr.count != 0 ||
            _couponDeleteArr.count != 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除所选项？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            itCanEdit = NO;
            [_delateBtn setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
            [self.mainTabview setEditing:NO animated:YES];
        }
    }else{
        itCanEdit = YES;
       [_delateBtn setImage:[UIImage imageNamed:@"img_editor_c.png"] forState:UIControlStateNormal];
        [self.mainTabview setEditing:YES animated:YES];
    }

}
- (void)addData:(void (^)(BOOL finish))success
{
    if (self.collectType == COUPON) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",[NSString stringWithFormat:@"%ld",couponPage],@"page",@"10",@"pageSize", nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyCollectss.couponList" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                NSLog(@"%@",responseObject.result);
                if (responseObject.succeed) {
                    NSArray *arr = [NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
                    for (NSDictionary *dic in arr) {
                        CollectModel *model = [[CollectModel alloc]init];
                        model = [JsonStringTransfer dictionary:dic ToModel:model];
                        model.isChecked = NO;
                        [couponDataArray addObject:model];
                    }
                }
                success(YES);
                couponPage = [[responseObject.result objectForKey:@"page"] integerValue];
                if (couponPage >= [[responseObject.result objectForKey:@"totalPage"] integerValue]) {
                    isEnd = YES;
                }
                [self.mainTabview reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        });
    }else if (self.collectType == SHOPS){
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",[NSString stringWithFormat:@"%ld",shopPage],@"page",@"10",@"pageSize",@"3",@"latitude",@"3",@"longitude",nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.storeList" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                    NSLog(@"opertion*&****************:%@",operation);
                    NSLog(@"result:%@",responseObject.result);
                if (responseObject.succeed == YES) {
                    NSArray *subArray= [NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
                    
                    for (NSDictionary *dic in subArray) {
                        BunessList1Model *model = [[BunessList1Model alloc]init];
                        model = [JsonStringTransfer dictionary:dic ToModel:model];
                        model.isChecked = NO;
                        [storeDataArray addObject:model];
                    }
                }
                success (YES);
                shopPage = [[responseObject.result objectForKey:@"page"] integerValue];
                if (shopPage >= [[responseObject.result objectForKey:@"totalPage"] integerValue]) {
                    isEnd = YES;
                }
                [self.mainTabview reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.collectType == COUPON) {
        if (couponDataArray.count == 0) {
            [self.noDataView setHidden:NO];
        }else{
            [self.noDataView setHidden:YES];
        }
        return couponDataArray.count;
    }else if (self.collectType == SHOPS){
        if (storeDataArray.count == 0) {
            [self.noDataView setHidden:NO];
        }else{
            [self.noDataView setHidden:YES];
        }
        return storeDataArray.count;
    }
    return 0;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.frame.size.height;
    return 81;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger row = indexPath.row;
    if (self.collectType == COUPON) {
        static NSString *cellId = @"DiscountCouponCell";
        DiscountCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCouponCell" owner:nil options:nil] lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row < couponDataArray.count) {
            CollectModel *model = couponDataArray[indexPath.row];
            [cell config:model];
            [cell setChecked:model.isChecked];
        }
        
        return cell;
        
    }else if(self.collectType == SHOPS){
        static NSString *cellId = @"BunessList1Cell";
        
        BunessList1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BunessList1Cell" owner:nil options:nil] lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row < storeDataArray.count) {
            BunessList1Model *model = storeDataArray[indexPath.row];
            [cell config:model];
            [cell setChecked:model.isChecked];
        }
        return cell;
    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (itCanEdit) {
        if (self.collectType == COUPON) {
            DiscountCouponCell *cell = (DiscountCouponCell *)[tableView cellForRowAtIndexPath:indexPath];
            CollectModel *listModel = couponDataArray[indexPath.row];
            listModel.isChecked = !listModel.isChecked;
            [couponDataArray replaceObjectAtIndex:indexPath.row withObject:listModel];
            [cell setChecked:listModel.isChecked];
            
            if ([_couponDeleteArr containsObject:indexPath]) {
                [_couponDeleteArr removeObject:indexPath];
            }else{
                [_couponDeleteArr addObject:indexPath];
            }
        }else if(self.collectType == SHOPS){
            BunessList1Cell *cell = (BunessList1Cell *)[tableView cellForRowAtIndexPath:indexPath];
            BunessList1Model *listModel = storeDataArray[indexPath.row];
            listModel.isChecked = !listModel.isChecked;
            [storeDataArray replaceObjectAtIndex:indexPath.row withObject:listModel];
            [cell setChecked:listModel.isChecked];
            
            if ([_storeDeleteArr containsObject:indexPath]) {
                [_storeDeleteArr removeObject:indexPath];
            }else{
                [_storeDeleteArr addObject:indexPath];
            }
        }
        
    }else{
        if (self.collectType == COUPON) {
            CollectModel *listModel = couponDataArray[indexPath.row];
            if ([listModel.type isEqualToString:@"material"]) {
                //商品详情
                ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
                vc.goodId = [NSString stringWithFormat:@"%d",[listModel.item_id intValue]];
                vc.goodsImageStr = [NSString stringWithFormat:@"%@",listModel.default_image];
                NSLog(@"%@",vc.goodId);
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([listModel.type isEqualToString:@"coupon"]){
                //代金券详情
                CashCouponDetailViewController *CashCouponDetailVC = [[CashCouponDetailViewController alloc]init];
                CashCouponDetailVC.goodsId = listModel.item_id;
                [self.navigationController pushViewController:CashCouponDetailVC animated:YES];
            }
        }else if (self.collectType == SHOPS){
            //商家详情
            BunessList1Model *listModel = storeDataArray[indexPath.row];
            FoodShopDetailViewController *shopVC = [[FoodShopDetailViewController alloc]init];
            shopVC.storeId = listModel.item_id;
            [shopVC callBackFoodVC:^{
                NSLog(@"评论成功");
            }];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
        
    }
    
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return itCanEdit;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        if (itCanEdit) {
//            NSString *itemId = [[NSString alloc]init];
//            NSString *type = [[NSString alloc]init];
//            
//            if (self.collectType == COUPON) {
//                
//                CollectModel *model = couponDataArray[indexPath.row];
//                itemId = model.item_id;
//                type = @"goods";
//            }else if (self.collectType == SHOPS){
//                BunessList1Model *model = storeDataArray[indexPath.row];
//                itemId = model.item_id;
//                type = @"store";
//            }
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",itemId,@"itemId",type,@"type",nil];
//            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.delete" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//                if (responseObject.succeed) {
//                    NSLog(@"%@",responseObject.result);
//                    //数据处理
//                    if (self.collectType == COUPON) {
//                        [couponDataArray removeObjectAtIndex:indexPath.row];
//                    }else if (self.collectType == SHOPS){
//                        [storeDataArray removeObjectAtIndex:indexPath.row];
//                    }
//                    [self.mainTabview reloadData];
//                }
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"error = %@",error);
//            }];
//
//        }
//    }
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if(self.collectType == COUPON){
            for (int i = 0; i < couponDataArray.count; i++) {
                CollectModel *listmodel = couponDataArray[i];
                listmodel.isChecked = NO;
                [couponDataArray replaceObjectAtIndex:i withObject:listmodel];
            }
            _couponDeleteArr =[[NSMutableArray alloc]init];
        }else if (self.collectType == SHOPS){
            for (int i = 0; i < storeDataArray.count; i++) {
                BunessList1Model *listmodel = storeDataArray[i];
                listmodel.isChecked = NO;
                [storeDataArray replaceObjectAtIndex:i withObject:listmodel];
            }
            _storeDeleteArr = [[NSMutableArray alloc]init];
        }
        itCanEdit = NO;
        [_delateBtn setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
        [self.mainTabview setEditing:NO animated:YES];
        [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        
    }else if (buttonIndex == 1){
        if (itCanEdit) {
            NSMutableString *itemId = [[NSMutableString alloc]init];
            NSString *type = [[NSString alloc]init];
            
            if (self.collectType == COUPON) {
                type = @"goods";
                for (int i = 0; i < _couponDeleteArr.count; i++) {
                    NSIndexPath *index = _couponDeleteArr[i];
                    CollectModel *model = couponDataArray[index.row];
                
                    if (i == 0){
                        itemId = [NSMutableString stringWithString:model.item_id];
                    }else{
                        [itemId appendFormat:@",%@",model.item_id];
                    }
                }
                
            }else if (self.collectType == SHOPS){
                type = @"store";
                for (int i = 0; i < _storeDeleteArr.count; i++) {
                    NSIndexPath *index = _storeDeleteArr[i];
                    BunessList1Model *model = storeDataArray[index.row];
                    if (i == 0){
                        itemId = [NSMutableString stringWithString:model.item_id];
                    }else{
                        [itemId appendFormat:@",%@",model.item_id];
                    }
                }
            }
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",itemId,@"itemId",type,@"type",nil];
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.delete" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"%@",responseObject.result);
                    //数据处理
                    if (self.collectType == COUPON) {
                        for (int i = 0; i <_couponDeleteArr.count; i++) {
                            NSIndexPath *index = _couponDeleteArr[i];
                            [couponDataArray removeObjectAtIndex:index.row];
                        }
                    }else if (self.collectType == SHOPS){
                        for (int i = 0; i <_storeDeleteArr.count; i++) {
                            NSIndexPath *index = _storeDeleteArr[i];
                            [storeDataArray removeObjectAtIndex:index.row];
                        }
                    }
                    [self.mainTabview reloadData];
                }
                itCanEdit = NO;
                _couponDeleteArr = [[NSMutableArray alloc]init];
                _storeDeleteArr = [[NSMutableArray alloc]init];
                [_delateBtn setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
                [self.mainTabview setEditing:NO animated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
            }];
            
        }

    }

}

#pragma mark------
#pragma mark------loadTableView--------
- (DiscountCouponCell *)loadDiscountCouponCell:(UITableView *)tableView
{
    NSString * const nibName  = @"DiscountCouponCell";
    DiscountCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (DiscountCouponEditCell *)loadDiscountCouponEditCell:(UITableView *)tableView
{
    NSString * const nibName  = @"DiscountCouponEditCell";
    DiscountCouponEditCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (BunessList1Cell *)loadBunessList1Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"BunessList1Cell";
    
    BunessList1Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (BunessList1CellEditCell *)loadBunessList1CellEditCell:(UITableView *)tableView
{
    NSString * const nibName  = @"BunessList1CellEditCell";
    
    BunessList1CellEditCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
        success (YES);
    }else{
        if (self.collectType == COUPON){
            couponPage = couponPage+1;
        }else if (self.collectType == SHOPS){
            shopPage = shopPage+1;
        }
        [self addData:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    if (self.collectType == COUPON) {
        if (couponDataArray != nil) {
            [couponDataArray removeAllObjects];
            couponDataArray = nil;
            couponDataArray = [[NSMutableArray alloc]init];
        }
    }else if (self.collectType == SHOPS){
        if (storeDataArray != nil) {
            [storeDataArray removeAllObjects];
            storeDataArray = nil;
            storeDataArray = [[NSMutableArray alloc]init];
        }
    }
    
    if (self.collectType == COUPON){
        couponPage = 1;
    }else if (self.collectType == SHOPS){
        shopPage = 1;
    }
    isEnd = NO;
    [self addData:^(BOOL finish) {
        success(finish);
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
