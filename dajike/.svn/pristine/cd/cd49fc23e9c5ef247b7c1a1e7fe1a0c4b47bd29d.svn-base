//
//  FoodShopDetailViewController.m
//  jibaobao
//
//  Created by swb on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **   类：  美食商家详情
 */

#import "FoodShopDetailViewController.h"
#import "MyHeaderView.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "SwbCommentView.h"
#import "CashCouponDetailViewController.h"      //代金券详情
#import "RecommendFoodViewController.h"         //推荐菜
#import "ShopInfoViewController.h"
#import "OrderCommentViewController.h"
#import "LoginViewController.h"
//各种Cell
#import "BeautifulFoodCellTableViewCell.h"
#import "ShopDecCell.h"
#import "SwbCell3.h"
#import "DiscountCouponCell.h"

#import "ShopDetailInfoModel.h"
#import "GoodsRecModel.h"
#import "CouponDetailModel.h"
#import "ShopCommentModel.h"
#import "NearPrivilegeModel.h"
#import "CommentStarView.h"
#import "AllCommentPhotoViewController.h"
#import "LoginViewController.h"
#import "CommentImgModel.h"
#import "ShopListModel.h"
#import "StoreAndCancleObject.h"
#import "BrowserViewBg.h"
#import "SwbClickImageView.h"

#import "UMSocialSnsService.h"

#import "MAPViewController.h"
#import "FileOperation.h"

#define img_Width ((WIDTH_CONTROLLER_DEFAULT-50)/4)

#define img_heighth img_Width

static NSString *swbCell1 = @"swbCell111";
static NSString *swbCell2 = @"swbCell222";
static NSString *swbCell3 = @"swbCell333";
static NSString *swbCell4 = @"swbCell444";

@interface FoodShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    //记录最近打开的cell的section和index
    int _currentSection;
    int _currentIndex;
    
    //记录cell是否展开
    BOOL _isCellOpen;
    
    NSMutableArray *_couponArr;
    NSMutableArray *_goodsArr;
    
    NSMutableArray *_recommentArr;
    
    NSMutableArray *_commentArr;
    
    NSMutableArray *_nearArr;
    
    ShopDetailInfoModel *_shopModel;
    
    MyHeaderView *_mView;
    
    NSMutableArray *_imgArr;
    
    int _isCellect;
    
    int _commentNum;
}

@end

@implementation FoodShopDetailViewController
//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    //询问开启定位操作
//#if TARGET_IPHONE_SIMULATOR
//    //写入plist
//    [FileOperation writeLatitude:@"31.326362"];
//    [FileOperation writeLongitude:@"121.442765"];
//#elif TARGET_OS_IPHONE
//    //当前经纬度
//    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//        //写入plist
//        [FileOperation writeLatitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
//        [FileOperation writeLongitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude]];
//    }];
//#endif
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"商家详情";
    
    [self initdata];
    [self initTableView];
    [self getData];
}

// ----------------------------  分割线 -------------------------------
//初始化
- (void)initdata
{
    _couponArr = [[NSMutableArray alloc]initWithObjects:@"我是凑数的", nil];
    _goodsArr = [[NSMutableArray alloc]init];
    _recommentArr = [[NSMutableArray alloc]init];
    _commentArr = [[NSMutableArray alloc]initWithObjects:@"我还是来凑数的", nil];
    _nearArr    = [[NSMutableArray alloc]initWithObjects:@"我们都是来凑数的", nil];
    
    _imgArr     = [[NSMutableArray alloc]init];
    
    _shopModel = [[ShopDetailInfoModel alloc]init];
    _currentIndex = -1;
    _currentSection = -1;
    _isCellOpen = NO;
    _isCellect = -1;
    _commentNum = 0;
    
    self.delegate       = self;
    [self setNavType:SHAREANGSHOUCANG_BUTTON];
    [self setStoreBtnHidden:YES];
}
//初始化列表
- (void)initTableView
{
    [self addTableView:UITableViewStyleGrouped];
    [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-108)];
    self.mainTabview.backgroundColor = Color_bg;
    self.mainTabview.delegate   = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BeautifulFoodCellTableViewCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell3" bundle:nil] forCellReuseIdentifier:swbCell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell3];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"ShopDecCell" bundle:nil] forCellReuseIdentifier:swbCell4];
    
    [self setTableViewHeaderView];
}
//设置列表头视图
- (void)setTableViewHeaderView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 70+WIDTH_CONTROLLER_DEFAULT/2) andBackgroundColor:[UIColor whiteColor]];
    _mView = [[MyHeaderView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 70+WIDTH_CONTROLLER_DEFAULT/2)];
    _mView.frame = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 70+WIDTH_CONTROLLER_DEFAULT/2);
    [_mView addShopPhotosBtn];
    [_mView btnClickedCallBackAction:^(long btnTag) {
        if (btnTag == 2) {
            MAPViewController *mapVC = [[MAPViewController alloc]init];
            if (self.cityName == nil){
                self.cityName = [FileOperation getDingweiCityName];
            }
            [mapVC pointAnnotationTitle:_shopModel.address city:self.cityName latitude:[_shopModel.latitude floatValue] longitude:[_shopModel.longitude floatValue]];
            [self presentViewController:mapVC animated:YES completion:nil];
            NSLog(@"地址");
        }
        if (btnTag == 3) {
            NSLog(@"电话");
            [commonTools dialPhone:_shopModel.tel];
        }
        if (btnTag == 4) {
            NSLog(@"收藏");
            [self store];
        }
        if (btnTag == 5) {
            NSLog(@"相册");
            ShopInfoViewController *shopVC = [[ShopInfoViewController alloc]init];
            shopVC.storeId = _shopModel.store_id;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }];
    [viewBg addSubview:_mView];
    self.mainTabview.tableHeaderView = viewBg;
    
    if ([self.flagStr intValue] != 5) {
        SwbCommentView *commentView = [[SwbCommentView alloc]initWithFrame:CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT-108, WIDTH_CONTROLLER_DEFAULT, 44)];
        [commentView callbackBtnClicked:^{
            NSLog(@"评论");
            if ([FileOperation isLogin]) {
                OrderCommentViewController *vc = [[OrderCommentViewController alloc]init];
                vc.goodsOrOrder = 1;
                vc.storeId = self.storeId;
                [vc callBackShopComment:^{
                    if (_commentArr.count<3) {
                        [_commentArr removeAllObjects];
                        [_imgArr removeAllObjects];
                        _commentArr = nil;
                        _imgArr = nil;
                        _commentArr = [[NSMutableArray alloc]initWithObjects:@"我还是来凑数的", nil];
                        _imgArr     = [[NSMutableArray alloc]init];
                        [self getShangJiaPingLun];
                    }else {
                        _commentNum = _commentNum+1;
                        [self.mainTabview reloadData];
                    }
                    [ProgressHUD showMessage:@"评论成功" Width:100 High:80];
                    self.block();
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                LoginViewController *vc = [[LoginViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        [self.view addSubview:commentView];
    }
}

- (void)callBackFoodVC:(CallBackFoodVCBlock)block
{
    self.block = block;
}
//收藏
- (void)store
{
    if ([FileOperation isLogin]) {
        if (_isCellect == 0) {
            //未收藏
            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_02"];
            [self storeShop];
        }
        if (_isCellect == 1) {
            //已收藏
            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_03"];
            [self quxiaoStoreShop];
        }
    }else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)getData
{
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t groug = dispatch_group_create();
    
    dispatch_group_async(groug, queue1, ^{
        [self getShangJiaXiangQing];
    });
    
    dispatch_group_async(groug, queue2, ^{
        [self getShangJiaPingLun];
    });
    
//    dispatch_group_async(groug, queue3, ^{
//        [self getFuJinYouHui];
//    });
}
//获取商家详情
- (void)getShangJiaXiangQing
{
    NSString *userId = @"";
    if ([FileOperation isLogin]) {
        userId = [FileOperation getUserId];
    }
    NSDictionary *parameter = @{@"storeId":self.storeId,@"userId":userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableDictionary *tmpDic = [responseObject.result  mutableCopy];
            
            NSMutableArray *recArr = [[tmpDic objectForKey:@"recommendGoodsList"]mutableCopy];
            for (int i=0; i<recArr.count; i++) {
                GoodsRecModel *model = [[GoodsRecModel alloc]init];
                model = [JsonStringTransfer dictionary:[recArr objectAtIndex:i] ToModel:model];
                [recArr replaceObjectAtIndex:i withObject:model];
            }
            [_recommentArr addObjectsFromArray:recArr];
            
            NSMutableArray *couArr = [[tmpDic objectForKey:@"couponList"]mutableCopy];
            
            for (int j=0; j<couArr.count; j++) {
                CouponDetailModel *model = [[CouponDetailModel alloc]init];
                model = [JsonStringTransfer dictionary:[couArr objectAtIndex:j] ToModel:model];
                [couArr replaceObjectAtIndex:j withObject:model];
            }
            [_couponArr addObjectsFromArray:couArr];
            
            _shopModel = [JsonStringTransfer dictionary:tmpDic ToModel:_shopModel];
            
            _commentNum = [_shopModel.commentcount intValue];
            
            [self getFuJinYouHui];
            dispatch_async(dispatch_get_main_queue(), ^{
                _mView.shopNameLb.text = _shopModel.store_name;
                _mView.commentNumLb.text = [NSString stringWithFormat:@"%d人评价",[_shopModel.commentcount intValue]];
                _mView.photoNumLb.text = [NSString stringWithFormat:@"%d张",[_shopModel.imageCount intValue]];
                [_mView.iv setImageWithURL:[commonTools getImgURL:_shopModel.store_logo] placeholderImage:PlaceholderImage_Big];
                [_mView.shopPhotoImg setImageWithURL:[commonTools getImgURL:_shopModel.file_path] placeholderImage:PlaceholderImage];
                _mView.xingjiLb.text = [NSString stringWithFormat:@"%.1f分",[_shopModel.avgxingji floatValue]];
                CommentStarView *starV = [[CommentStarView alloc]init];
                starV.frame = CGRectMake(0, CGRectGetMaxY(_mView.shopNameLb.frame), 110, 20);
                [starV layoutCommentStar:[NSString stringWithFormat:@"%@",_shopModel.avgxingji]];
                [_mView addSubview:starV];
                _mView.adressLb.text = _shopModel.address;
                
                _isCellect = [_shopModel.collect intValue];
                if (_isCellect == 1) {
                    //已收藏
                    _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_03"];
                }
                if (_isCellect == 0) {
                    //未收藏
                    _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_02"];
                }
                
                [self.mainTabview reloadData];
            });
            
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
// 商家评论
- (void)getShangJiaPingLun
{
    NSDictionary *parameter = @{@"storeId":self.storeId,@"page":@"1",@"pageSize":@"2"};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.comments" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableArray *mArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            
            for (int i=0; i<mArr.count; i++) {
                NSMutableArray *tmpImgArr = [[[mArr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
                if (tmpImgArr.count == 0) {
                    [_imgArr addObject:@"我是来凑数的"];
                }else {
                    for (int j=0; j<tmpImgArr.count; j++) {
                        CommentImgModel *mm = [[CommentImgModel alloc]init];
                        mm = [JsonStringTransfer dictionary:[tmpImgArr objectAtIndex:j] ToModel:mm];
                        [tmpImgArr replaceObjectAtIndex:j withObject:mm];
                    }
                    [_imgArr addObject:tmpImgArr];
                }
                
                ShopCommentModel *model = [[ShopCommentModel alloc]init];
                model = [JsonStringTransfer dictionary:[mArr objectAtIndex:i] ToModel:model];
                [mArr replaceObjectAtIndex:i withObject:model];
            }
            [_commentArr addObjectsFromArray:mArr];
            
            _commentNum = (int)_commentArr.count-1;
            
            NSLog(@"_____%@",_imgArr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
            });
            
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取附近优惠
- (void)getFuJinYouHui
{
    //参数字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_shopModel.latitude],@"latitude",[NSString stringWithFormat:@"%@",_shopModel.longitude],@"longitude",@"1",@"page",@"4",@"pageSize", nil];
    //post请求
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.fujinyouhui" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed ) {
            NSLog(@"%@",responseObject.result);
            
            NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i = 0; i<tmpArr.count; i++) {
                NearPrivilegeModel *model = [[NearPrivilegeModel alloc]init];
                model = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:model];
                [tmpArr replaceObjectAtIndex:i withObject:model];
            }
            [_nearArr addObjectsFromArray:tmpArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//右一
- (void)right1Cliped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 55) {
        [self.mainTabview setContentOffset:CGPointMake(0, 0) animated:YES];
        NSLog(@"列表滚回顶部");
    }else{
        //分享
        [[ShareObject shared] setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shopModel.store_logo]]] andShareTitle:_shopModel.store_name andShareUrl:SHARE_URL];
        [[ShareObject shared]shareUM:@"sd" presentSnsIconSheetView:self delegate:self];
    }
}
//收藏店铺
- (void)storeShop
{
    [StoreAndCancleObject stroe:[FileOperation getUserId] withObjectId:self.storeId withType:@"2" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellect = 1;
            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_03"];
        }
    }];

}

//取消收藏
- (void)quxiaoStoreShop
{
    [StoreAndCancleObject cancelStore:[FileOperation getUserId] withObjectId:self.storeId withType:@"store" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellect = 0;
            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_02"];
        }
    }];
}

#pragma mark   Tableview   Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _couponArr.count;
    }
    if (section == 1) {
        return _recommentArr.count>0?4:3;
    }
    if (section == 2) {
        if (_commentArr.count>1) {
            return _commentArr.count+1>4?4:_commentArr.count+1;
        }else
            return 1;
        
    }
    if (section == 3) {
        return _nearArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 30;
        }
        else
            return 80;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            return 30;
        }else {
            if (indexPath.row == 1) {
                if (indexPath.section == _currentSection) {
                    if (indexPath.row == _currentIndex) {
                        if (_isCellOpen) {
                            _currentIndex = (int)indexPath.row;
                            _currentSection = (int)indexPath.section;
                            
                            CGRect rect = [self.view contentAdaptionLabel:_shopModel.description2 withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                            return rect.size.height+56;
                        }
                    }
                }
                NSLog(@"%@",_shopModel.description2);
                CGRect rect1 = [self.view contentAdaptionLabel:_shopModel.description2 withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                
                return (int)rect1.size.height>30?80:rect1.size.height+40;
            }
            if (indexPath.row == 3) {
                NSString *str = nil;
                for (int i=0; i<_recommentArr.count; i++) {
                    GoodsRecModel *model = [_recommentArr objectAtIndex:i];
                    if (str.length == 0) {
                        str = [NSString stringWithFormat:@"%@",model.goods_name];
                    }else
                        str = [str stringByAppendingFormat:@"%@ ",model.goods_name];
                }
                NSLog(@"%@",str);
                CGRect rect2 = [self.view contentAdaptionLabel:str withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-40, 1000) withTextFont:13.0f];
                return (int)rect2.size.height>47?60:rect2.size.height+20;
            }
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == _commentArr.count) {
            return 30;
        }else {
            if (_commentArr.count>1) {
                
                
                ShopCommentModel *model = [_commentArr objectAtIndex:indexPath.row];
                CGRect rect3 = [self.view contentAdaptionLabel:model.comments withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                float imgHeight = 0.0f;
                if (_imgArr.count>0) {
                    if ([[_imgArr objectAtIndex:indexPath.row-1]isKindOfClass:[NSString class]]) {
                        
                    }else {
                        long arrCount = [[_imgArr objectAtIndex:indexPath.row-1]count]%4 == 0?([[_imgArr objectAtIndex:indexPath.row-1]count]/4):([[_imgArr objectAtIndex:indexPath.row-1]count]/4+1);
                        
                        imgHeight = rect3.size.height>43?arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+arrCount*10:arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+10;
                    }
                    
                }
                
                if (indexPath.section == _currentSection) {
                    if (indexPath.row == _currentIndex) {
                        if (_isCellOpen) {
                            _currentIndex = (int)indexPath.row;
                            _currentSection = (int)indexPath.section;
                            
                            CGRect rect = [self.view contentAdaptionLabel:model.comments withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                            return rect.size.height+45+imgHeight;
                        }
                    }
                }
                return rect3.size.height>43?90+imgHeight:rect3.size.height+40+imgHeight;
            }
            
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 30;
        }else
            return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1 = @"Cell111";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
            }
            UIImageView *quanIv = (UIImageView *)[myCell.contentView viewWithTag:111];
            if (!quanIv) {
                quanIv = [self.view createImageViewWithFrame:CGRectMake(10, 6, 20, 18) andImageName:@"img_juan"];
                quanIv.tag = 111;
                [myCell.contentView addSubview:quanIv];
            }
            quanIv.hidden = NO;
            UILabel *quanLb = (UILabel *)[myCell.contentView viewWithTag:112];
            if (!quanLb) {
                quanLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxY(quanIv.frame)+5, 0, 150, 30) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
                quanLb.tag = 112;
                [myCell.contentView addSubview:quanLb];
            }
            quanLb.frame = CGRectMake(CGRectGetMaxY(quanIv.frame)+10, 0, 150, 30);
            quanLb.textColor = Color_word_bg;
            quanLb.text = [NSString stringWithFormat:@"代金券（ %d ）",[_shopModel.couponCount intValue]];
            myCell.accessoryType = UITableViewCellAccessoryNone;
            return myCell;
        }else {
            BeautifulFoodCellTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
            if (_couponArr.count>1) {
                myCell.model = [_couponArr objectAtIndex:indexPath.row];
            }
            
            return myCell;
        }
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            ShopDecCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell4];
            myCell.model = _shopModel;
            myCell.arowImg.image = [UIImage imageNamed:@"img_arrow_01_down"];
            if (indexPath.section == _currentSection) {
                if (indexPath.row == _currentIndex) {
                    if (_isCellOpen) {
                        
                        CGRect rect = [self.view contentAdaptionLabel:_shopModel.description2 withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
                        myCell.decsHeightCon.constant = rect.size.height+5;
                        myCell.arowImg.image = [UIImage imageNamed:@"img_arrow_01_up"];
                    }
                        
                }
            }
            
            return myCell;
        }
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        UIImageView *iv = (UIImageView *)[myCell.contentView viewWithTag:111];
        if (iv) {
            iv.hidden = YES;
        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:112];
        if (!lb) {
            lb = [self.view creatLabelWithFrame:CGRectMake(10, 0, 150, 30) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            lb.tag = 112;
            [myCell.contentView addSubview:lb];
        }
        lb.frame = CGRectMake(10, 0, 150, 30);
        lb.textColor = Color_word_bg;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 0) {
            lb.text = @"商家概述";
        }
        if (indexPath.row == 2) {
            
            lb.text = _recommentArr.count>0?@"推荐":@"暂无推荐";
        }
        if (indexPath.row == 3) {
            
            lb.lineBreakMode = NSLineBreakByTruncatingTail;
            lb.text = @"";
            for (int i=0; i<_recommentArr.count; i++) {
                GoodsRecModel *model = [_recommentArr objectAtIndex:i];
                if (lb.text.length == 0) {
                    lb.text = [NSString stringWithFormat:@"%@",model.goods_name];
                }else
                    lb.text = [lb.text stringByAppendingFormat:@"%@ ",model.goods_name];
            }
            CGRect rect = [self.view contentAdaptionLabel:lb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-40, 1000) withTextFont:13.0f];
            if ((int)rect.size.height>47) {
                lb.frame = CGRectMake(10, 5, WIDTH_CONTROLLER_DEFAULT-40, 47);
            }else
                lb.frame = CGRectMake(10, 5, WIDTH_CONTROLLER_DEFAULT-40, rect.size.height+10);
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return myCell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == _commentArr.count) {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
            }
            UIImageView *iv = (UIImageView *)[myCell.contentView viewWithTag:111];
            if (iv) {
                iv.hidden = YES;
            }
            UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:112];
            if (!lb) {
                lb = [self.view creatLabelWithFrame:CGRectMake(10, 0, 150, 30) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
                lb.tag = 112;
                [myCell.contentView addSubview:lb];
            }
            lb.frame = CGRectMake(10, 0, 150, 30);
            lb.textColor = Color_word_bg;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                if (_commentArr.count > 1) {
                    lb.text = [NSString stringWithFormat:@"网友点评（%d人评价）",_commentNum];
                }
                else
                    lb.text = @"暂无评论";
            }
            if (indexPath.row == _commentArr.count) {
                lb.text = [NSString stringWithFormat:@"查看%d条评论",_commentNum];
                lb.textColor = Color_mainColor;
                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            return myCell;
        }else {
            SwbCell3 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
            
            ShopCommentModel *mmod = [_commentArr objectAtIndex:indexPath.row];
            
            if (_commentArr.count>1) {
                myCell.shopModel = mmod;
            }
            myCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_down"];
            if (indexPath.section == _currentSection) {
                if (indexPath.row == _currentIndex) {
                    if (_isCellOpen) {
                        CGRect rect = [self.view contentAdaptionLabel:mmod.comments withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
                        myCell.descriptionCon.constant = rect.size.height+5;
                        myCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_up"];
                    }
                }
            }
            
            
            if ([[_imgArr objectAtIndex:indexPath.row-1] isKindOfClass:[NSString class]]) {
                NSLog(@"呵呵，没人发图片评论");
                UIView *imgViewBg = (UIView *)[myCell.contentView viewWithTag:808];
                if (imgViewBg) {
                    for (UIView *tmpV in imgViewBg.subviews) {
                        [tmpV removeFromSuperview];
                    }
                }
            }else {
                NSMutableArray *arr = [_imgArr objectAtIndex:indexPath.row-1];
                
                UIView *imgViewBg = (UIView *)[myCell.contentView viewWithTag:808];
                if (!imgViewBg) {
                    imgViewBg = [[UIView alloc]init];
                    imgViewBg.tag = 808;
                    [myCell.contentView addSubview:imgViewBg];
                }
                imgViewBg.frame = CGRectMake(0, CGRectGetMinY(myCell.descriptionLb.frame)+myCell.descriptionCon.constant+5, WIDTH_CONTROLLER_DEFAULT, (arr.count/4+1)*img_heighth);
                
                
                for (UIView *tmpV in imgViewBg.subviews) {
                    [tmpV removeFromSuperview];
                }
                
                
                for (int i=0; i<arr.count; i++) {
                    CommentImgModel *model = [arr objectAtIndex:i];
                    SwbClickImageView *imgv = [[SwbClickImageView alloc]initWithFrame:CGRectMake(10*(i%4+1)+i%4*img_Width, i/4*5+i/4*img_Width, img_Width, img_heighth)];
                    imgv.tag = 10+i;
                    //处理图片规格
                    NSArray *tar = [model.img_url componentsSeparatedByString:@"_"];
                    NSString *tmpStr = [NSString stringWithFormat:@"%@.jpg",[tar firstObject]];
                    [imgv setImageWithURL:[commonTools getImgURL:tmpStr] placeholderImage:PlaceholderImage];
                    [imgv callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
                        BrowserViewBg *browser = (BrowserViewBg *)[imgViewBg viewWithTag:90090];
                        if (!browser) {
                            browser = [[BrowserViewBg alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
                            browser.tag = 90090;
                            [[UIApplication sharedApplication].keyWindow addSubview:browser];
                        }
                        browser.imgArr = arr;
                        browser.currentIndex = i;
                        browser.imgViewSuperView = imgViewBg;
                        [browser show:clickImgView];
                    }];
                    [imgViewBg addSubview:imgv];
                    
                }
            }
            
            
            return myCell;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
            }
            UIImageView *iv = (UIImageView *)[myCell.contentView viewWithTag:111];
            if (iv) {
                iv.hidden = YES;
            }
            UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:112];
            if (!lb) {
                lb = [self.view creatLabelWithFrame:CGRectMake(10, 0, 150, 30) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
                lb.tag = 112;
                [myCell.contentView addSubview:lb];
            }
            lb.frame = CGRectMake(10, 0, 150, 30);
            lb.textColor = Color_word_bg;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            lb.text = @"你附近的优惠";
            return myCell;
        }else {
            DiscountCouponCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell3];
            if (_nearArr.count>1) {
                myCell.nearbyYouhuiModel = [_nearArr objectAtIndex:indexPath.row];
            }
            
            return myCell;
        }
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row) {
            CouponDetailModel *model = [_couponArr objectAtIndex:indexPath.row];
            CashCouponDetailViewController *cashCouponVC = [[CashCouponDetailViewController alloc]init];
            cashCouponVC.goodsId = model.goods_id;
            [self.navigationController pushViewController:cashCouponVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            ShopDecCell *cell = (ShopDecCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.arowImg.hidden) {
                return;
            }
            if (indexPath.section == _currentSection && indexPath.row == _currentIndex) {
                _isCellOpen = !_isCellOpen;
            }else{
                _isCellOpen = YES;
            }
            NSLog(@"--%d,--%d",_currentSection,_currentIndex);
            _currentSection = (int)indexPath.section;
            _currentIndex = (int)indexPath.row;
            [tableView reloadData];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_currentIndex inSection:_currentSection], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (indexPath.row == 3) {
            RecommendFoodViewController *recommendVC = [[RecommendFoodViewController alloc]init];
            recommendVC.shopDetailInfoModel = _shopModel;
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
    }
    if (indexPath.section == 2){
        //网友点评
        if (indexPath.row == 0) {
            return;
        }
        if (_commentArr.count == 1) {
            return;
        }
        if (_commentArr.count > 1 && indexPath.row == _commentArr.count) {
            AllCommentPhotoViewController *commentPhotoVC = [[AllCommentPhotoViewController alloc]init];
            commentPhotoVC.flagStr = @"0";
            commentPhotoVC.publicId = _shopModel.store_id;
            [self.navigationController pushViewController:commentPhotoVC animated:YES];
        }else {
            SwbCell3 *cell = (SwbCell3 *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.arrowImg.hidden) {
                return;
            }
            if (indexPath.section == _currentSection && indexPath.row == _currentIndex) {
                _isCellOpen = !_isCellOpen;
            }else{
                _isCellOpen = YES;
            }
            _currentSection = (int)indexPath.section;
            _currentIndex = (int)indexPath.row;
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_currentIndex inSection:_currentSection], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row) {
            CashCouponDetailViewController *cashCouponVC = [[CashCouponDetailViewController alloc]init];
            NearPrivilegeModel *model = [_nearArr objectAtIndex:indexPath.row];
            cashCouponVC.goodsId = model.goods_id;
            [self.navigationController pushViewController:cashCouponVC animated:YES];

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 120) {
        [self setScrollBtnHidden:NO];
    }
    else
        [self setScrollBtnHidden:YES];
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
