//
//  CashCouponDetailViewController.m
//  jibaobao
//
//  Created by swb on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **   代金券详情 test
 */

#import "CashCouponDetailViewController.h"
#import "UIView+MyView.h"
#import "defines.h"
#import "SwbBuyView.h"
#import "SwbSubbranchCell.h"
#import "SwbCell3.h"
#import "DiscountCouponCell.h"
#import "WriteIndentViewController.h"       //填写订单
#import "AllCommentPhotoViewController.h"   //评价
#import "AllSubbranchViewController.h"      //分店
#import "RecommendFoodViewController.h"     //推荐菜
#import "CashCouponTitleTextViewController.h"//代金券图文详情
#import "FillInIndentViewController.h"      //购物--》填写订单 ＊＊＊＊
#import "CouponBuyNeedKownCell.h"
#import "LoginViewController.h"
#import "FoodShopDetailViewController.h"
#import "StoreAndCancleObject.h"
#import "BrowserViewBg.h"
#import "SwbClickImageView.h"

#import "PictureTextDetailModel.h"
#import "CouponDetailModel.h"
#import "GoodsCommentModel.h"
#import "NearPrivilegeModel.h"
#import "GoodsRecModel.h"
#import "CommentImgModel.h"
#import "UMSocialSnsService.h"
#define img_Width ((WIDTH_CONTROLLER_DEFAULT-50)/4)

#define img_heighth img_Width

static NSString *swbCell1 = @"swbCell111";
static NSString *swbCell2 = @"swbCell222";
static NSString *swbCell3 = @"swbCell333";
static NSString *swbCell4 = @"swbCell444";

@interface CashCouponDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    CouponDetailModel   *_couponModel;
    
    int                 _oldOffSet;
    
    NSMutableArray      *_commentsArr;
    
    NSMutableArray      *_NearArr;
    
    NSMutableArray      *_recommendArr;
    
    NSMutableArray      *_pictureArr;
    
    UIImageView         *_imgV;
    
    UIImageView         *_imgView;
    
    NSMutableArray      *_imgArr;
    
    SwbBuyView          *_buyView;
    
    SwbBuyView          *_buyView1;
    UIView *_viewBg;
    UILabel *storeLb;
    
    UILabel *goodsDecsLb;
    UIImageView *suishituiiv;
    UILabel *suishituiLb;
    UIImageView *guoqituiiv;
    UILabel *guoqituiLb;
    UIImageView *mianyuyueiv3;
    UILabel *mianyuyuelb5;
    UIImageView *yishouiv4;
    UILabel *yishoulb6;
    UIView *mylineView1;
    UIView *mylineView2;
    
    //记录最近打开的cell的section和index
    int _currentSection;
    int _currentIndex;
    
    //记录cell是否展开
    BOOL _isCellOpen;
    
    int _isCellet;
}

@end

@implementation CashCouponDetailViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getJWdu];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"代金券详情";
    [self initData];
    [self getData];
}

// ---------------------- 分割线 ——--------------------------
//初始化数据
- (void)initData
{
    _couponModel = [[CouponDetailModel alloc]init];
    _NearArr = [[NSMutableArray alloc]initWithObjects:@"", nil];
    _commentsArr = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
    _recommendArr = [[NSMutableArray alloc]init];
    _imgArr     = [[NSMutableArray alloc]init];
    _pictureArr = [[NSMutableArray alloc]init];
    
    _currentIndex = -1;
    _currentSection = -1;
    _isCellet = -1;
    _isCellOpen = NO;
    _oldOffSet = 120;
    self.delegate = self;
    [self setNavType:SHAREANGSHOUCANG_BUTTON];
    [self setStoreBtnHidden:YES];
    
    [self setTableView];
    [self setHeadView];
    [self setBuyView];
}
//初始化创建列表
- (void)setTableView
{
    [self addTableView:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbSubbranchCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell3" bundle:nil] forCellReuseIdentifier:swbCell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell3];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"CouponBuyNeedKownCell" bundle:nil] forCellReuseIdentifier:swbCell4];
}

// 获取经纬度
- (void)getJWdu
{
    //询问开启定位操作
#if TARGET_IPHONE_SIMULATOR
    //写入plist
    [FileOperation writeLatitude:@"31.326362"];
    [FileOperation writeLongitude:@"121.442765"];
#elif TARGET_OS_IPHONE
    //当前经纬度
    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //写入plist
        [FileOperation writeLatitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
        [FileOperation writeLongitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude]];
    }];
#endif
}

#pragma mark  网络请求获取数据
- (void)getData
{
    NSString *userId = @"";
    if ([FileOperation isLogin]) {
        userId = [FileOperation getUserId];
    }
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group  = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        
        NSDictionary *parameter = @{@"goodsId":self.goodsId,@"userId":userId};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.couponDetail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                if (responseObject.result) {
                    
                    if ([responseObject.result isKindOfClass:[NSString class]]) {
                        if ([commonTools isEmpty:responseObject.result]) {
                            return;
                        }
                    }
                    NSMutableDictionary *dic = [responseObject.result mutableCopy];
                    [self handleCouponDetail:dic];
                }
            }
            else
            {
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];
    });
    
    dispatch_group_async(group, queue2, ^{
        
        NSDictionary *parameter = @{@"goodsId":self.goodsId,@"page":@"1",@"pageSize":@"3"};
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.comments" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
                [self handleCommentsData:arr];
            }
            else
            {
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];
    });
}
//获得推荐商品
- (void)getRecommendProduct
{
    NSDictionary *parameter = @{@"storeId":_couponModel.store_id};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.recomdGoods" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSMutableArray *arr = [responseObject.result mutableCopy];
            for (int i=0; i<arr.count; i++) {
                GoodsRecModel *model = [[GoodsRecModel alloc]init];
                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
            }
            [_recommendArr addObjectsFromArray:arr];
            [self.mainTabview reloadData];
        }
        else
        {
            [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获得附近优惠
- (void)getFuJinYouHuiData
{
    //参数字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[FileOperation getLatitude]],@"latitude",[NSString stringWithFormat:@"%@",[FileOperation getLongitude]],@"longitude",@"1",@"page",@"4",@"pageSize",_couponModel.cate_id,@"categoryId",[FileOperation getCurrentCityId],@"regionId", nil];
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
            [_NearArr addObjectsFromArray:tmpArr];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//处理代金券详情数据
- (void)handleCouponDetail:(NSMutableDictionary *)dic
{
    NSMutableArray *picArr = [[dic objectForKey:@"twDetail"]mutableCopy];
    for (int i=0; i<picArr.count; i++) {
        PictureTextDetailModel *model = [[PictureTextDetailModel alloc]init];
        model = [JsonStringTransfer dictionary:[picArr objectAtIndex:i] ToModel:model];
        [picArr replaceObjectAtIndex:i withObject:model];
    }
    [_pictureArr addObjectsFromArray:picArr];
    _couponModel = [JsonStringTransfer dictionary:dic ToModel:_couponModel];
    _isCellet = [_couponModel.collect intValue];
    if (_isCellet == 1) {
        //已收藏
        _imgV.image = [UIImage imageNamed:@"img_asterisk_03"];
    }
    if (_isCellet == 0) {
        //未收藏
        _imgV.image = [UIImage imageNamed:@"img_asterisk_02"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fillData];
    });
    [self getFuJinYouHuiData];
    [self getRecommendProduct];
}
//处理评论数据
- (void)handleCommentsData:(NSMutableArray *)arr
{
    for (int i=0; i<arr.count; i++) {
        NSMutableArray *tmpImgArr = [[[arr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
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
        GoodsCommentModel *model = [[GoodsCommentModel alloc]init];
        model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
        [arr replaceObjectAtIndex:i withObject:model];
    }
    [_commentsArr addObjectsFromArray:arr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTabview reloadData];
    });
}
//拿到数据后
- (void)fillData
{
    _buyView.priceLb.text = [NSString stringWithFormat:@"%.2f元",[_couponModel.price floatValue]];
    CGRect rect1 = [self.view contentAdaptionLabel:_buyView.priceLb.text withSize:CGSizeMake(1000, 20) withTextFont:14.0f];
    _buyView.priceLb.frame = CGRectMake(10, 1, rect1.size.width+5, 20);
    if ([_couponModel.market_price floatValue]>0) {
        _buyView.notPriceLb.text = [NSString stringWithFormat:@"%.2f元",[_couponModel.market_price floatValue]];
        CGRect rect2 = [self.view contentAdaptionLabel:_buyView.notPriceLb.text withSize:CGSizeMake(1000, 10) withTextFont:14.0f];
        _buyView.notPriceLb.frame = CGRectMake(CGRectGetMaxX(_buyView.priceLb.frame)+10, 5, rect2.size.width+5, 10);
        [_buyView.notPriceLb setHidden:NO];
    }else
        [_buyView.notPriceLb setHidden:YES];
    
    _buyView.lotteryLb.text = [NSString stringWithFormat:@"%.0f%%累计抽奖",[_couponModel.choujiang_bili floatValue]*100];
    
    _buyView1.priceLb.text = [NSString stringWithFormat:@"%.2f元",[_couponModel.price floatValue]];
    CGRect rect3 = [self.view contentAdaptionLabel:_buyView1.priceLb.text withSize:CGSizeMake(1000, 20) withTextFont:14.0f];
    _buyView1.priceLb.frame = CGRectMake(10, 1, rect3.size.width+5, 20);
    if ([_couponModel.market_price floatValue]>0) {
        _buyView1.notPriceLb.text = [NSString stringWithFormat:@"%.2f元",[_couponModel.market_price floatValue]];
        CGRect rect4 = [self.view contentAdaptionLabel:_buyView1.notPriceLb.text withSize:CGSizeMake(1000, 10) withTextFont:14.0f];
        _buyView1.notPriceLb.frame = CGRectMake(CGRectGetMaxX(_buyView1.priceLb.frame)+10, 5, rect4.size.width+5, 10);
        [_buyView1.notPriceLb setHidden:NO];
    }else
        [_buyView1.notPriceLb setHidden:YES];
    
    _buyView1.lotteryLb.text = [NSString stringWithFormat:@"%.0f%%累计抽奖",[_couponModel.choujiang_bili floatValue]*100];
    
    
    storeLb.text = _couponModel.store_name;
    goodsDecsLb.text = _couponModel.goods_desc;
    
    CGRect rect11 = [self.view contentAdaptionLabel:_couponModel.goods_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-60, 1000) withTextFont:12.0f];
    
    if (rect11.size.height > 15) {
        goodsDecsLb.frame = CGRectMake(10, CGRectGetMaxY(storeLb.frame)+1, WIDTH_CONTROLLER_DEFAULT-60, rect11.size.height+5);
        mylineView1.frame = CGRectMake(0, CGRectGetMaxY(goodsDecsLb.frame)+1, WIDTH_CONTROLLER_DEFAULT, 0.5);
        _viewBg.frame = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 120+WIDTH_CONTROLLER_DEFAULT/2+rect11.size.height-10);
        self.mainTabview.tableHeaderView = _viewBg;
    }
    
    
    
    suishituiiv.frame = CGRectMake(10, CGRectGetMaxY(mylineView1.frame)+7, 16, 16);
    suishituiLb.frame = CGRectMake(CGRectGetMaxX(suishituiiv.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20);
    
//    float x1 = 10.0f;
    float x2 = 10.0f;
    float x3 = 10.0f;
    float x4 = 10.0f;
    
    if ([_couponModel.is_suishitui intValue] == 1) {
        suishituiiv.hidden = NO;
        suishituiLb.hidden = NO;
        x2 = CGRectGetMaxX(suishituiLb.frame);
    }
    guoqituiiv.frame = CGRectMake(x2, CGRectGetMaxY(mylineView1.frame)+7, 16, 16);
    guoqituiLb.frame = CGRectMake(CGRectGetMaxX(guoqituiiv.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20);
    
    if ([_couponModel.is_guoqitui intValue] == 1) {
        guoqituiiv.hidden = NO;
        guoqituiLb.hidden = NO;
        x3 = CGRectGetMaxX(guoqituiLb.frame);
    }else if ([_couponModel.is_suishitui intValue] == 1) {
        x3 = CGRectGetMaxX(suishituiLb.frame);
    }
    mianyuyueiv3.frame = CGRectMake(x3, CGRectGetMaxY(mylineView1.frame)+7, 16, 16);
    mianyuyuelb5.frame = CGRectMake(CGRectGetMaxX(mianyuyueiv3.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20);
    
    if ([_couponModel.is_yuyue intValue] == 1) {
        mianyuyueiv3.hidden = NO;
        mianyuyuelb5.hidden = NO;
        x4 = CGRectGetMaxX(mianyuyuelb5.frame);
    }else if ([_couponModel.is_guoqitui intValue] == 1) {
        x4 = CGRectGetMaxX(guoqituiLb.frame);
    }else if ([_couponModel.is_suishitui intValue] == 1) {
        x4 = CGRectGetMaxX(suishituiLb.frame);
    }
    
    yishouiv4.frame = CGRectMake(x4, CGRectGetMaxY(mylineView1.frame)+7, 16, 16);
    yishoulb6.frame = CGRectMake(CGRectGetMaxX(yishouiv4.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 70, 20);
    yishoulb6.text = [NSString stringWithFormat:@"已售%d",[_couponModel.sales intValue]];
    
    [_imgView setImageWithURL:[commonTools getImgURL:_couponModel.default_image] placeholderImage:PlaceholderImage_Big];
    
    mylineView2.frame = CGRectMake(0, CGRectGetMaxY(_viewBg.frame)-0.5, WIDTH_CONTROLLER_DEFAULT, 0.5);
}

- (void)setBuyView
{
    _buyView = [[SwbBuyView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 45)];
//    float marketPrice = [_couponModel.market_price floatValue]>0?[_couponModel.market_price floatValue]:0;
//    [_buyView layoutMyView:[NSString stringWithFormat:@"%.2f元",[_couponModel.price floatValue]] andNotPri:[NSString stringWithFormat:@"%d元",[_couponModel.market_price intValue]] andLottery:[NSString stringWithFormat:@"%.0f%%累计抽奖",[_couponModel.choujiang_bili floatValue]*100]];
    [_buyView CallBackBuyBtnClicked:^{
        NSLog(@"立即购买");
        
        WriteIndentViewController *writeVC = [[WriteIndentViewController alloc]init];
        writeVC.model = _couponModel;
        [self.navigationController pushViewController:writeVC animated:YES];
    }];
    
    
    [self.view addSubview:_buyView];
    [_buyView setHidden:YES];
}

- (void)setHeadView
{
    _viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 120+WIDTH_CONTROLLER_DEFAULT/2) andBackgroundColor:[UIColor whiteColor]];
    _imgView = [self.view createImageViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2) andImageName:imagePlaceholderImage_Big];
    [_imgView setImageWithURL:[commonTools getImgURL:_couponModel.default_image] placeholderImage:PlaceholderImage_Big];
    
    [_viewBg addSubview:_imgView];
    _buyView1 = [[SwbBuyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame), WIDTH_CONTROLLER_DEFAULT, 45)];
//    [buyView layoutMyView:[NSString stringWithFormat:@"%d元",[_couponModel.price intValue]] andNotPri:[NSString stringWithFormat:@"%d元",[_couponModel.market_price intValue]] andLottery:[NSString stringWithFormat:@"%.0f%%累计抽奖",[_couponModel.choujiang_bili floatValue]*100]];
    [_buyView1 CallBackBuyBtnClicked:^{
        NSLog(@"立即购买");
        
        WriteIndentViewController *writeVC = [[WriteIndentViewController alloc]init];
        writeVC.model = _couponModel;
        [self.navigationController pushViewController:writeVC animated:YES];

    }];
    [_viewBg addSubview:_buyView1];
    
    storeLb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_buyView1.frame)+5, 100, 20) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor blackColor] andCornerRadius:0.0];
    [_viewBg addSubview:storeLb];
    goodsDecsLb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(storeLb.frame)+1, WIDTH_CONTROLLER_DEFAULT-60, 14) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [_viewBg addSubview:goodsDecsLb];
    _imgV = [self.view createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-35, CGRectGetMaxY(_buyView1.frame)+5, 20, 20) andImageName:@"img_asterisk_02"];
    [_viewBg addSubview:_imgV];
    UILabel *lb2 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-38, CGRectGetMaxY(_imgV.frame)+1, 25, 15) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:@"收藏" AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
    [_viewBg addSubview:lb2];
    
    UIButton *storeBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-35, CGRectGetMaxY(_buyView1.frame)+5, 35, 35) andBackImageName:nil andTarget:self andAction:@selector(btnClicked:) andTitle:nil andTag:5];
    [_viewBg addSubview:storeBtn];
    
    mylineView1 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(storeBtn.frame)+5, WIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:Color_line_bg];
    [_viewBg addSubview:mylineView1];
    
    
    
    
    
    suishituiiv = [self.view createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(mylineView1.frame)+7, 16, 16) andImageName:@"img_re_01"];
    suishituiiv.hidden = YES;
    [_viewBg addSubview:suishituiiv];
    
    suishituiLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(suishituiiv.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"随时退" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    suishituiLb.hidden = YES;
    [_viewBg addSubview:suishituiLb];
    
    
    
    guoqituiiv = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(suishituiLb.frame)+5, CGRectGetMaxY(mylineView1.frame)+7, 16, 16) andImageName:@"img_re_02"];
    guoqituiiv.hidden = YES;
    [_viewBg addSubview:guoqituiiv];
    guoqituiLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(guoqituiiv.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"过期退" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    guoqituiLb.hidden = YES;
    [_viewBg addSubview:guoqituiLb];
    
    
    
    mianyuyueiv3 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(guoqituiLb.frame)+5, CGRectGetMaxY(mylineView1.frame)+7, 16, 16) andImageName:@"img_re_03"];
    mianyuyueiv3.hidden = YES;
    [_viewBg addSubview:mianyuyueiv3];
    mianyuyuelb5 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(guoqituiiv.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"免预约" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    mianyuyuelb5.hidden = YES;
    [_viewBg addSubview:mianyuyuelb5];
    
    
    
    
    yishouiv4 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(mianyuyuelb5.frame)+5, CGRectGetMaxY(mylineView1.frame)+7, 16, 16) andImageName:@"img_re_03"];
    [_viewBg addSubview:yishouiv4];
    yishoulb6 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(yishouiv4.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 70, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"已售0" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [_viewBg addSubview:yishoulb6];
    
    mylineView2 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_viewBg.frame)-0.5, WIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:Color_line_bg];
    [_viewBg addSubview:mylineView2];
    
    self.mainTabview.tableHeaderView = _viewBg;
}

//收藏店铺
- (void)storeShop
{
    [StoreAndCancleObject stroe:[FileOperation getUserId] withObjectId:self.goodsId withType:@"1" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellet = 1;
            _imgV.image = [UIImage imageNamed:@"img_asterisk_03"];
        }
    }];
    
}

//取消收藏
- (void)quxiaoStoreShop
{
    [StoreAndCancleObject cancelStore:[FileOperation getUserId] withObjectId:self.goodsId withType:@"goods" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellet = 0;
            _imgV.image = [UIImage imageNamed:@"img_asterisk_02"];
        }
    }];
}

- (void)btnClicked:(id)sender
{
    NSLog(@"收藏");
    
    NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
    if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
        
        if (_isCellet == 0) {
            //未收藏
            _imgV.image = [UIImage imageNamed:@"img_asterisk_02"];
            [self storeShop];
        }
        if (_isCellet == 1) {
            //已收藏
            _imgV.image = [UIImage imageNamed:@"img_asterisk_03"];
            [self quxiaoStoreShop];
        }
        
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [[ShareObject shared] setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_couponModel.store_logo]]] andShareTitle:_couponModel.goods_name andShareUrl:SHARE_URL];
        [[ShareObject shared]shareUM:@"sd" presentSnsIconSheetView:self delegate:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return _recommendArr.count>0?5:4;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 3) {
        if (_commentsArr.count>2) {
            if (_commentsArr.count+1>=6) {
                return 6;
            }else
                return _commentsArr.count+1;
        }else
            return 2;
//        return _commentsArr.count>2?_commentsArr.count+1:1;
    }
    else {
        return _NearArr.count;
    }
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
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 100;
        }
        if (indexPath.row == 3) {
            if (_recommendArr.count>0) {
                NSString *str = nil;
                for (int i=0; i<_recommendArr.count; i++) {
                    GoodsRecModel *model = [_recommendArr objectAtIndex:i];
                    if (str.length == 0) {
                        str = [NSString stringWithFormat:@"%@",model.goods_name];
                    }else
                        str = [str stringByAppendingFormat:@"%@ ",model.goods_name];
                }
                NSLog(@"%@",str);
                CGRect rect2 = [self.view contentAdaptionLabel:str withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-40, 1000) withTextFont:15.0f];
                return (int)rect2.size.height>54?70:rect2.size.height+20;
            }
        }
        return 30;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            CGRect rect1 = [self.view contentAdaptionLabel:_couponModel.unuse_time_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            CGRect rect2 = [self.view contentAdaptionLabel:_couponModel.use_time_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            CGRect rect3 = [self.view contentAdaptionLabel:_couponModel.use_rule_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            return 120+rect1.size.height+rect2.size.height+rect3.size.height>160?120+rect1.size.height+rect2.size.height+rect3.size.height:160;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == _commentsArr.count) {
            return 30;
        }else {
            if (_commentsArr.count>2) {
                
                
                GoodsCommentModel *model = [_commentsArr objectAtIndex:indexPath.row];
                CGRect rect3 = [self.view contentAdaptionLabel:model.content withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                float imgHeight = 0.0f;
                if (_imgArr.count>0) {
                    if ([[_imgArr objectAtIndex:indexPath.row-2]isKindOfClass:[NSString class]]) {
                        
                    }else {
                        long arrCount = [[_imgArr objectAtIndex:indexPath.row-2]count]%4 == 0?([[_imgArr objectAtIndex:indexPath.row-2]count]/4):([[_imgArr objectAtIndex:indexPath.row-2]count]/4+1);
                        
                        imgHeight = rect3.size.height>43?arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+arrCount*10:arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+10;
                    }
                    
                }
                
                if (indexPath.section == _currentSection) {
                    if (indexPath.row == _currentIndex) {
                        if (_isCellOpen) {
                            _currentIndex = (int)indexPath.row;
                            _currentSection = (int)indexPath.section;
                            
                            CGRect rect = [self.view contentAdaptionLabel:model.content withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                            return rect.size.height+45+imgHeight;
                        }
                    }
                }
                return rect3.size.height>43?90+imgHeight:rect3.size.height+40+imgHeight;
            }
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            return 30;
        }
        else {
            return 81;
        }
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell2 = @"Cell222";
    if (indexPath.section == 0) {
        static NSString *cell1 = @"Cell111";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        
        for (UIView *temView in myCell.contentView.subviews) {
            [temView removeFromSuperview];
        }
        
        //星星评论
        for(int i = 0;i<5;i++)
        {
            UIImageView *iv = [[UIImageView alloc]init];
            iv.frame = CGRectMake(10+19*i, 5, 15, 15);
            iv.image = [UIImage imageNamed:@"img_xingxing_03"];
            [myCell.contentView addSubview:iv];
            if (i<[_couponModel.avgXingji intValue]) {
                iv.image = [UIImage imageNamed:@"img_xingxing_02"];
            }
            if (![commonTools isNull:_couponModel.avgXingji]) {
                if (![commonTools isPureInt:[NSString stringWithFormat:@"%@",_couponModel.avgXingji]]) {
                    if (i == [_couponModel.avgXingji intValue]) {
                        iv.image = [UIImage imageNamed:@"img_xingxing_04"];
                    }
                }
            }
            
        }
        UILabel *commentLb = [self.view creatLabelWithFrame:CGRectMake(110, 0, 60, 30) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:[NSString stringWithFormat:@"%.1f分",[_couponModel.avgXingji floatValue]] AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor colorWithRed:241.0/255.0 green:135.0/255.0 blue:34.0/255.0 alpha:1.0f] andCornerRadius:0.0f];
        [myCell.contentView addSubview:commentLb];
        
        UILabel *lb = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-160, 0, 120, 30) AndFont:13.0 AndBackgroundColor:[UIColor clearColor] AndText:[NSString stringWithFormat:@"%d人评价",[_couponModel.goodscomments intValue]] AndTextAlignment:NSTextAlignmentRight AndTextColor:Color_word_bg andCornerRadius:0.0f];
        [myCell.contentView addSubview:lb];
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return myCell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            SwbSubbranchCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
            myCell.model = _couponModel;
            [myCell callBackPhoneCall:^{
                NSLog(@"打电话");
                
                [commonTools dialPhone:_couponModel.tel];
            }];
            return myCell;
        }
        else {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell2];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
            }
            UILabel *lb10 = (UILabel *)[myCell viewWithTag:66];
            
            if (!lb10) {
                lb10 = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
                lb10.tag = 66;
                [myCell.contentView addSubview:lb10];
            }
            lb10.frame = CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30);
            lb10.textColor = Color_word_bg;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                lb10.text = @"商家信息";
                lb10.textColor = [UIColor blackColor];
            }
//            if (indexPath.row == 2) {
//                lb10.text = @"查看全部3家分店";
//                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
            if (indexPath.row == 2) {
                lb10.text = _recommendArr.count>0?@"推荐":@"暂无推荐";
                lb10.textColor = [UIColor lightGrayColor];
            }
            if (indexPath.row == 4) {
                lb10.text = [NSString stringWithFormat:@"人均：%.2f元",[_couponModel.renjun floatValue]];
            }
            if (indexPath.row == 3) {
                if (_recommendArr.count>0) {
                    lb10.text = @"";
                    for (int i=0; i<_recommendArr.count; i++) {
                        GoodsRecModel *model = [_recommendArr objectAtIndex:i];
                        lb10.text = [lb10.text stringByAppendingFormat:@"%@ ",model.goods_name];
                    }
                    CGRect rect = [self.view contentAdaptionLabel:lb10.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-40, 1000) withTextFont:15.0f];
                    lb10.numberOfLines = 0;
                    lb10.lineBreakMode = NSLineBreakByTruncatingTail;
                    if ((int)rect.size.height > 54) {
                        lb10.frame = CGRectMake(10, 5, WIDTH_CONTROLLER_DEFAULT-40, 60);
                    }else
                        lb10.frame = CGRectMake(10, 5, WIDTH_CONTROLLER_DEFAULT-40, rect.size.height+10);
                    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else
                    lb10.text = [NSString stringWithFormat:@"人均：%.2f元",[_couponModel.renjun floatValue]];
                
            }
            return myCell;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell2];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
                
            }
            UILabel *lb11 = (UILabel *)[myCell viewWithTag:66];
            if (!lb11) {
                lb11 = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"历史课" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
                lb11.tag = 66;
                [myCell.contentView addSubview:lb11];
            }
            myCell.accessoryType = UITableViewCellAccessoryNone;
            lb11.frame = CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30);
            lb11.textColor = Color_word_bg;
            lb11.text = @"购买须知";
            return myCell;
        }
        if (indexPath.row == 1) {
            CouponBuyNeedKownCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell4];
            myCell.model = _couponModel;
            return myCell;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == _commentsArr.count) {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell2];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
                
            }
            UILabel *lb12 = (UILabel *)[myCell viewWithTag:66];
            if (!lb12) {
                lb12 = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"历史课" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
                lb12.tag = 66;
                [myCell.contentView addSubview:lb12];
            }
            myCell.accessoryType = UITableViewCellAccessoryNone;
            lb12.textColor = Color_word_bg;
            lb12.frame = CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30);
            
            if (indexPath.row == 0) {
                lb12.text = @"查看图文详情";
                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 1) {
                if (_commentsArr.count>2) {
                    lb12.text = [NSString stringWithFormat:@"网友点评（%d人评价）",[_couponModel.goodscomments intValue]];
                }else
                    lb12.text = @"暂无评论";
            }
            if (indexPath.row == _commentsArr.count) {
                lb12.text = [NSString stringWithFormat:@"查看%d条评论",[_couponModel.goodscomments intValue]];
                lb12.textColor = Color_mainColor;
                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return myCell;
        }
        else {
            SwbCell3 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
            
            
            GoodsCommentModel *mmod = [_commentsArr objectAtIndex:indexPath.row];
            
            if (_commentsArr.count>2) {
                myCell.model = mmod;
            }
            myCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_down"];
            if (indexPath.section == _currentSection) {
                if (indexPath.row == _currentIndex) {
                    if (_isCellOpen) {
                        CGRect rect = [self.view contentAdaptionLabel:mmod.content withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
                        myCell.descriptionCon.constant = rect.size.height+5;
                        myCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_up"];
                    }
                }
            }
            
            
            if ([[_imgArr objectAtIndex:indexPath.row-2] isKindOfClass:[NSString class]]) {
                NSLog(@"呵呵，没人发图片评论");
                UIView *imgViewBg = (UIView *)[myCell.contentView viewWithTag:808];
                if (imgViewBg) {
                    for (UIView *tmpV in imgViewBg.subviews) {
                        [tmpV removeFromSuperview];
                    }
                }
            }else {
                NSMutableArray *arr = [_imgArr objectAtIndex:indexPath.row-2];
                
                UIView *imgViewBg = (UIView *)[myCell.contentView viewWithTag:808];
                if (!imgViewBg) {
                    imgViewBg = [[UIView alloc]init];
                    imgViewBg.tag = 808;
                    [myCell.contentView addSubview:imgViewBg];
                }
                long arrCount = arr.count%4 == 0?(arr.count/4):(arr.count/4+1);
                imgViewBg.frame = CGRectMake(0, CGRectGetMinY(myCell.descriptionLb.frame)+myCell.descriptionCon.constant+5, WIDTH_CONTROLLER_DEFAULT, arrCount*img_heighth);
                
                
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
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell2];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
                
            }
            UILabel *lb13 = (UILabel *)[myCell viewWithTag:66];
            if (!lb13) {
                lb13 = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"历史课" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
                lb13.tag = 66;
                [myCell.contentView addSubview:lb13];
            }
            lb13.frame = CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT-20, 30);
            lb13.textColor = Color_word_bg;
            lb13.text = @"附近优惠";
            return myCell;
        }
        else {
            DiscountCouponCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell3];
            if (_NearArr.count>1) {
                myCell.nearbyYouhuiModel = [_NearArr objectAtIndex:indexPath.row];
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
        AllCommentPhotoViewController *allCommentVC = [[AllCommentPhotoViewController alloc]init];
        allCommentVC.publicId = self.goodsId;
        allCommentVC.flagStr = @"1";
        [self.navigationController pushViewController:allCommentVC animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            FoodShopDetailViewController *vc = [[FoodShopDetailViewController alloc]init];
            vc.storeId = _couponModel.store_id;
            [vc callBackFoodVC:^{
                NSLog(@"评论成功");
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        if (indexPath.row == 2) {
//            AllSubbranchViewController *allsubVC = [[AllSubbranchViewController alloc]init];
//            [self.navigationController pushViewController:allsubVC animated:YES];
//        }
        if (indexPath.row == 3) {
            if (_recommendArr.count>0) {
                RecommendFoodViewController *recommendVC = [[RecommendFoodViewController alloc]init];
                recommendVC.couponModel = _couponModel;
                [self.navigationController pushViewController:recommendVC animated:YES];
            }
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            CashCouponTitleTextViewController *vc = [[CashCouponTitleTextViewController alloc]init];
            vc.goodId = self.goodsId;
            vc.picturesArr = _pictureArr;
            vc.flagStr = @"1";
            vc.model = _couponModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (_commentsArr.count==2) return;
        else if (indexPath.row == _commentsArr.count) {
            AllCommentPhotoViewController *vc = [[AllCommentPhotoViewController alloc]init];
            vc.publicId = self.goodsId;
            vc.flagStr = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
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
            
            [tableView reloadData];
        }
    }
}

//滑动一定距离后显示置顶按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > WIDTH_CONTROLLER_DEFAULT/2) {
        [self setScrollBtnHidden:NO];
    }
    else
        [self setScrollBtnHidden:YES];
    
    if (scrollView.contentOffset.y > WIDTH_CONTROLLER_DEFAULT/2) {
        [_buyView setHidden:NO];
    }else
        [_buyView setHidden:YES];
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
