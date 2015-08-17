//
//  ProductDetailViewController.m
//  jibaobao
//
//  Created by swb on 15/5/22.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **   商品详情
 */

#import "ProductDetailViewController.h"
#import "UIView+MyView.h"
#import "defines.h"
#import "SwbBuyView.h"
#import "SwbCell3.h"
#import "DiscountCouponCell.h"
#import "FillInIndentViewController.h"
#import "BuyNeedKnowCell.h"
#import "LoginViewController.h"
#import "CashCouponTitleTextViewController.h"
#import "AllCommentPhotoViewController.h"
#import "StoreAndCancleObject.h"
#import "BrowserViewBg.h"
#import "SwbClickImageView.h"

#import "CommentImgModel.h"
#import "GoodsDetailModel.h"
#import "GoodsCommentModel.h"
#import "PictureTextDetailModel.h"
#import "KuaidiModel.h"
#import "ProductPhotosModel.h"
#import "SwbClickImageView.h"
#import "UMSocialSnsService.h"

#define img_Width ((WIDTH_CONTROLLER_DEFAULT-50)/4)

#define img_heighth img_Width

static NSString *swbCell1 = @"swbCell111";
static NSString *swbCell2 = @"swbCell222";
static NSString *swbCell3 = @"swbCell333";

@interface ProductDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    UIPageControl *pageControl;
    GoodsDetailModel    *_goodsModel;
    
    KuaidiModel         *_kuaidiModel;
    
    SwbBuyView *_buyView;
    SwbBuyView *_buyView1;
    UILabel *goodLb;
    UILabel *yishoulb4;
    UILabel *goodsDecsLb;
    
    NSMutableArray      *_commentArr;
    
    NSMutableArray      *_nearArr;
    
//    int                 _commentNum;
    int                 _oldOffset;
    
    UIImageView         *_storeIv;
    
    NSMutableArray      *_imgArr;
    
    NSMutableArray      *_commetImgArr;
    
    NSMutableArray      *_photosArr;
    
    UIScrollView *_imgScr;
    UIView *viewBg;
    
    //记录最近打开的cell的section和index
    int _currentSection;
    int _currentIndex;
    
    //记录cell是否展开
    BOOL _isCellOpen;
    
    int _isCellect;
    
    UIView *mylineView2;
    UIView *mylineView1;
    UIImageView *suishiiv1;
    UILabel *suishilb3;
    UIImageView *zhengpiniv3;
    UILabel *zhengpinlb5;
    UIImageView *yishouiv2;
}

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = @"商品详情";
    self.delegate = self;
    
    _goodsModel = [[GoodsDetailModel alloc]init];
    _kuaidiModel= [[KuaidiModel alloc]init];
    _commentArr = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
    _commetImgArr = [[NSMutableArray alloc]init];
    _nearArr    = [[NSMutableArray alloc]initWithObjects:@"我是来凑数的", nil];
    _imgArr     = [[NSMutableArray alloc]init];
    _photosArr  = [[NSMutableArray alloc]init];
    
    viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 120+WIDTH_CONTROLLER_DEFAULT/2) andBackgroundColor:[UIColor whiteColor]];
    _imgScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2)];
//    _commentNum = -1;
    _oldOffset  = 120;
    _currentIndex = -1;
    _currentSection = -1;
    _isCellect = -1;
    _isCellOpen = NO;
    
    
    
    [self setNavType:SHAREANGSHOUCANG_BUTTON];
    [self setStoreBtnHidden:YES];
    
    [self addTableView:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BuyNeedKnowCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell3" bundle:nil] forCellReuseIdentifier:swbCell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell3];
    
//    [self setHeadView];
    
//    [self setScrollBtnHidden:NO];
    
    [self setHeadView];
    
    [self setBuyView];
    [self getData];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
//-------------------------------------------- 分割线 --------------------------------------------------------

- (void)getData
{
    
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t queue4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        [self getShangPinXiangQing];
    });
    
    dispatch_group_async(group, queue2, ^{
        [self getShangJiaPingLun];
    });
    
    dispatch_group_async(group, queue3, ^{
        [self getShangPinXiangCe];
    });
    
//    dispatch_group_async(group, queue4, ^{
//        
//    });
    
}
//获取商品详情
- (void)getShangPinXiangQing
{
    NSString *userId = @"";
    
    if ([FileOperation isLogin ]) {
        userId = [FileOperation getUserId];
    }
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.goodId,@"goodsId",userId,@"userId", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.goodsDetail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            //
            if ([responseObject.result isKindOfClass:[NSString class]]) {
                if ([responseObject.result length] == 0) {
                    return;
                }
            }
            
            NSMutableDictionary *dic = [responseObject.result mutableCopy];
            
            if (([responseObject.result objectForKey:@"mobile_desc_json"] != [NSNull null])&&([responseObject.result objectForKey:@"mobile_desc_json"] != nil)) {
                NSMutableArray *photoTextArr = [[responseObject.result objectForKey:@"mobile_desc_json"]mutableCopy];
                for (int i=0; i<photoTextArr.count; i++) {
                    PictureTextDetailModel *model = [[PictureTextDetailModel alloc]init];
                    model = [JsonStringTransfer dictionary:[photoTextArr objectAtIndex:i] ToModel:model];
                    [photoTextArr replaceObjectAtIndex:i withObject:model];
                }
                [_photosArr addObjectsFromArray:photoTextArr];
            }
            
            
            if ([dic objectForKey:@"peisong_json"] != [NSNull null]) {
                if ([[dic objectForKey:@"peisong_json"]count]>0) {
                    NSMutableDictionary *dicc= [[dic objectForKey:@"peisong_json"]mutableCopy];
                    
                    _kuaidiModel = [JsonStringTransfer dictionary:dicc ToModel:_kuaidiModel];
                }
                
            }
            
            _goodsModel = [JsonStringTransfer dictionary:dic ToModel:_goodsModel];
            [self getFuJinYouHui];
            _isCellect = [_goodsModel.collect intValue];
            if (_isCellect == 1) {
                //已收藏
                _storeIv.image = [UIImage imageNamed:@"img_asterisk_03"];
            }
            if (_isCellect == 0) {
                //未收藏
                _storeIv.image = [UIImage imageNamed:@"img_asterisk_02"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fillData];
                // 更新界面
                [self.mainTabview reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取商品评论
- (void)getShangJiaPingLun
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.goodId,@"goodsId",@"1",@"page",@"3",@"pageSize", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.comments" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            
            if (arr.count <= 0) {
                
                
            }else {
                for (int i=0; i<arr.count; i++) {
                    
                    NSMutableArray *tmpImgArr = [[[arr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
                    if (tmpImgArr.count == 0) {
                        [_commetImgArr addObject:@"我是来凑数的"];
                    }else {
                        for (int j=0; j<tmpImgArr.count; j++) {
                            CommentImgModel *mm = [[CommentImgModel alloc]init];
                            mm = [JsonStringTransfer dictionary:[tmpImgArr objectAtIndex:j] ToModel:mm];
                            [tmpImgArr replaceObjectAtIndex:j withObject:mm];
                        }
                        [_commetImgArr addObject:tmpImgArr];
                    }
                    
                    GoodsCommentModel *model = [[GoodsCommentModel alloc]init];
                    model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                    [arr replaceObjectAtIndex:i withObject:model];
                }
                [_commentArr addObjectsFromArray:arr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self.mainTabview reloadData];
            });
            //
            //                _goodsModel = [JsonStringTransfer dictionary:[arr objectAtIndex:0] ToModel:_goodsModel];
            //                [self setHeadView];
            //                [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取商品相册
- (void)getShangPinXiangCe
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.goodId,@"goodsId", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.goodsPhotos" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSMutableArray *arr = [responseObject.result mutableCopy];
            for (int i=0; i<arr.count; i++) {
                ProductPhotosModel *model = [[ProductPhotosModel alloc]init];
                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
            }
            [_imgArr addObjectsFromArray:arr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setimgView];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
// 获取附近优惠
- (void)getFuJinYouHui
{
    //参数字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[FileOperation getLatitude]],@"latitude",[NSString stringWithFormat:@"%@",[FileOperation getLongitude]],@"longitude",@"1",@"page",@"4",@"pageSize",[FileOperation getCurrentCityId],@"regionId",_goodsModel.cate_id,@"categoryId", nil];
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

//拿到数据后
- (void)fillData
{
    _buyView.priceLb.text = [NSString stringWithFormat:@"%.2f元",[_goodsModel.price floatValue]];
    CGRect rect1 = [self.view contentAdaptionLabel:_buyView.priceLb.text withSize:CGSizeMake(1000, 20) withTextFont:14.0f];
    _buyView.priceLb.frame = CGRectMake(10, 1, rect1.size.width+5, 20);
    if ([_goodsModel.market_price floatValue]>0) {
        _buyView.notPriceLb.text = [NSString stringWithFormat:@"%.2f元",[_goodsModel.market_price floatValue]];
        CGRect rect2 = [self.view contentAdaptionLabel:_buyView.notPriceLb.text withSize:CGSizeMake(1000, 10) withTextFont:14.0f];
        _buyView.notPriceLb.frame = CGRectMake(CGRectGetMaxX(_buyView.priceLb.frame)+10, 5, rect2.size.width+5, 10);
        [_buyView.notPriceLb setHidden:NO];
    }else
        [_buyView.notPriceLb setHidden:YES];
    
    _buyView.lotteryLb.text = [NSString stringWithFormat:@"%.0f%%累计抽奖",[_goodsModel.choujiang_bili floatValue]*100];
    
    _buyView1.priceLb.text = [NSString stringWithFormat:@"%.2f元",[_goodsModel.price floatValue]];
    CGRect rect3 = [self.view contentAdaptionLabel:_buyView1.priceLb.text withSize:CGSizeMake(1000, 20) withTextFont:14.0f];
    _buyView1.priceLb.frame = CGRectMake(10, 1, rect3.size.width+5, 20);
    if ([_goodsModel.market_price floatValue]>0) {
        _buyView1.notPriceLb.text = [NSString stringWithFormat:@"%.2f元",[_goodsModel.market_price floatValue]];
        CGRect rect4 = [self.view contentAdaptionLabel:_buyView1.notPriceLb.text withSize:CGSizeMake(1000, 10) withTextFont:14.0f];
        _buyView1.notPriceLb.frame = CGRectMake(CGRectGetMaxX(_buyView1.priceLb.frame)+10, 5, rect4.size.width+5, 10);
        [_buyView1.notPriceLb setHidden:NO];
    }else
        [_buyView1.notPriceLb setHidden:YES];
    
    _buyView1.lotteryLb.text = [NSString stringWithFormat:@"%.0f%%累计抽奖",[_goodsModel.choujiang_bili floatValue]*100];
    
    goodLb.text = _goodsModel.goods_name;
    goodsDecsLb.text = _goodsModel.description;
    CGRect rect11 = [self.view contentAdaptionLabel:_goodsModel.description withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-60, 1000) withTextFont:12.0f];
    
    if (rect11.size.height > 15) {
        goodsDecsLb.frame = CGRectMake(10, CGRectGetMaxY(goodLb.frame)+1, WIDTH_CONTROLLER_DEFAULT-60, rect11.size.height+5);
        mylineView1.frame = CGRectMake(0, CGRectGetMaxY(goodsDecsLb.frame)+1, WIDTH_CONTROLLER_DEFAULT, 0.5);
        viewBg.frame = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 120+WIDTH_CONTROLLER_DEFAULT/2+rect11.size.height-10);
        self.mainTabview.tableHeaderView = viewBg;
    }
    
    
    
    
    zhengpiniv3.frame = CGRectMake(10, CGRectGetMaxY(mylineView1.frame)+5, 20, 20);
    zhengpinlb5.frame = CGRectMake(CGRectGetMaxX(zhengpiniv3.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20);
    yishouiv2.frame = CGRectMake(CGRectGetMaxX(zhengpinlb5.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 20, 20);
    yishoulb4.frame = CGRectMake(CGRectGetMaxX(yishouiv2.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 70, 20);
    
    
    yishoulb4.text = [NSString stringWithFormat:@"已售%d",[_goodsModel.sales intValue]];
    
    mylineView2.frame = CGRectMake(0, CGRectGetMaxY(viewBg.frame)-0.5, WIDTH_CONTROLLER_DEFAULT, 0.5);
}

- (void)setBuyView
{
    _buyView = [[SwbBuyView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 45)];
//    [_buyView layoutMyView:[NSString stringWithFormat:@"%d",[_goodsModel.price intValue]] andNotPri:[NSString stringWithFormat:@"%d",[_goodsModel.market_price intValue]] andLottery:[NSString stringWithFormat:@"%.0f%%累计抽奖",[_goodsModel.choujiang_bili floatValue]*100]];
    [_buyView CallBackBuyBtnClicked:^{
        NSLog(@"立即购买");
        
        NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
        if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
            FillInIndentViewController *vc = [[FillInIndentViewController alloc]init];
            vc.goodModel = _goodsModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.view addSubview:_buyView];
    [_buyView setHidden:YES];
}

- (void)setimgView
{
    _imgScr.showsHorizontalScrollIndicator = NO;
    _imgScr.pagingEnabled = YES;
    _imgScr.delegate = self;
    for (int i=0; i<_imgArr.count; i++) {
        SwbClickImageView * mImgView = [[SwbClickImageView alloc]initWithFrame:CGRectMake(i*WIDTH_CONTROLLER_DEFAULT, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2)];
        ProductPhotosModel *model = [_imgArr objectAtIndex:i];
        
        [mImgView setImageWithURL:[commonTools getImgURL:model.imageUrl] placeholderImage:PlaceholderImage_Big];
        
        [_imgScr addSubview:mImgView];
//        __weak ProductDetailViewController *weakSelf = self;
        [mImgView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
            NSLog(@"推荐%ld",(long)clickImgView.tag);
            
        }];
    }
    [viewBg addSubview:_imgScr];
    [_imgScr setContentSize:CGSizeMake(_imgArr.count*WIDTH_CONTROLLER_DEFAULT, 0)];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, CGRectGetHeight(_imgScr.frame)-30, 150, 30)];
    [pageControl setCurrentPageIndicatorTintColor:Color_mainColor];
    [pageControl setPageIndicatorTintColor:Color_gray4];
    
    pageControl.numberOfPages=_imgArr.count;
    pageControl.currentPage=0;
    pageControl.enabled=YES;
    
    [pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    if (_imgArr.count>0) {
        [self.mainTabview addSubview:pageControl];
    }
    
}

-(void)pageTurn:(UIPageControl *)sender
{
    int pageNum=(int)pageControl.currentPage;
    CGSize viewSize=_imgScr.frame.size;
    [_imgScr setContentOffset:CGPointMake(pageNum*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",_imgScr.contentOffset.x);
    NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
}

- (void)setHeadView
{
    
    
//    UIImageView *imgView = [self.view createImageViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 100) andImageName:@"ico"];
//    [viewBg addSubview:imgView];
    _buyView1 = [[SwbBuyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgScr.frame), WIDTH_CONTROLLER_DEFAULT, 45)];
    NSLog(@"%@---%@",_goodsModel.market_price,_goodsModel.price);
//    [buyView layoutMyView:[NSString stringWithFormat:@"%d",[_goodsModel.price intValue]] andNotPri:[NSString stringWithFormat:@"%d",[_goodsModel.market_price intValue]] andLottery:[NSString stringWithFormat:@"%.0f%%累计抽奖",[_goodsModel.choujiang_bili floatValue]*100]];
    [_buyView1 CallBackBuyBtnClicked:^{
        NSLog(@"立即购买");
        NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
        if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
            FillInIndentViewController *vc = [[FillInIndentViewController alloc]init];
            vc.goodModel = _goodsModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    [viewBg addSubview:_buyView1];
    
    goodLb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_buyView1.frame)+5, 100, 20) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor blackColor] andCornerRadius:0.0];
    [viewBg addSubview:goodLb];
    goodsDecsLb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(goodLb.frame)+1, WIDTH_CONTROLLER_DEFAULT-60, 14) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [viewBg addSubview:goodLb];
    _storeIv = [self.view createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-35, CGRectGetMaxY(_buyView1.frame)+5, 20, 20) andImageName:@"img_asterisk_02"];
    [viewBg addSubview:_storeIv];
    UILabel *lb2 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-38, CGRectGetMaxY(_storeIv.frame)+1, 25, 15) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:@"收藏" AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0];
    [viewBg addSubview:lb2];
    
    UIButton *storeBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-35, CGRectGetMaxY(_buyView1.frame)+5, 35, 35) andBackImageName:nil andTarget:self andAction:@selector(btnClicked:) andTitle:nil andTag:5];
    [viewBg addSubview:storeBtn];
    
    mylineView1 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(storeBtn.frame)+5, WIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:mylineView1];
    
    suishiiv1 = [self.view createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(mylineView1.frame)+5, 20, 20) andImageName:@"img_positive"];
    suishiiv1.hidden = YES;
    [viewBg addSubview:suishiiv1];
    suishilb3 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(suishiiv1.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"随时退" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    suishilb3.hidden = YES;
    [viewBg addSubview:suishilb3];
    
    
    zhengpiniv3 = [self.view createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(mylineView1.frame)+5, 20, 20) andImageName:@"img_positive"];
    [viewBg addSubview:zhengpiniv3];
    zhengpinlb5 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(zhengpiniv3.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"正品" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [viewBg addSubview:zhengpinlb5];
    
    yishouiv2 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(zhengpinlb5.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 20, 20) andImageName:@"img_peo_cri"];
    [viewBg addSubview:yishouiv2];
    yishoulb4 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(yishouiv2.frame)+5, CGRectGetMaxY(mylineView1.frame)+5, 70, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [viewBg addSubview:yishoulb4];
    
    mylineView2 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(viewBg.frame)-0.5, WIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:mylineView2];
    
//    UIImageView *iv4 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(lb5.frame), CGRectGetMaxY(lineView1.frame)+7, 16, 16) andImageName:@"img_re_03"];
//    [viewBg addSubview:iv4];
//    UILabel *lb6 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(iv4.frame)+5, CGRectGetMaxY(lineView1.frame)+5, 55, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"免预约" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
//    [viewBg addSubview:lb6];
    
    self.mainTabview.tableHeaderView = viewBg;
}

//收藏店铺
- (void)storeShop
{
    [StoreAndCancleObject stroe:[FileOperation getUserId] withObjectId:self.goodId withType:@"1" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellect = 1;
            _storeIv.image = [UIImage imageNamed:@"img_asterisk_03"];
        }
    }];
    
}

//取消收藏
- (void)quxiaoStoreShop
{
    [StoreAndCancleObject cancelStore:[FileOperation getUserId] withObjectId:self.goodId withType:@"goods" withBlcok:^(int flag) {
        if (flag == 666) {
            _isCellect = 0;
            _storeIv.image = [UIImage imageNamed:@"img_asterisk_02"];
        }
    }];
}

- (void)btnClicked:(id)sender
{
    NSLog(@"收藏");
    
    NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
    if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
        
        if (_isCellect == 0) {
            //未收藏
            _storeIv.image = [UIImage imageNamed:@"img_asterisk_02"];
            [self storeShop];
        }
        if (_isCellect == 1) {
            //已收藏
            _storeIv.image = [UIImage imageNamed:@"img_asterisk_03"];
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
        [[ShareObject shared] setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.goodsImageStr]]] andShareTitle:_goodsModel.goods_name andShareUrl:SHARE_URL];
        [[ShareObject shared]shareUM:@"sd" presentSnsIconSheetView:self delegate:self];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        if (_commentArr.count>2) {
            if (_commentArr.count+1>=6) {
                return 6;
            }else
                return _commentArr.count+1;
        }else
            return 2;
    }
    else {
        return _nearArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0.5;
//    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGRect rect1 = [self.view contentAdaptionLabel:_kuaidiModel.fanwei withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect2 = [self.view contentAdaptionLabel:_kuaidiModel.kuaidi withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect3 = [self.view contentAdaptionLabel:_kuaidiModel.feiyong withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect4 = [self.view contentAdaptionLabel:_kuaidiModel.shijian withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect5 = [self.view contentAdaptionLabel:_kuaidiModel.shouhou withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            return 180+rect1.size.height+rect2.size.height+rect3.size.height+rect4.size.height+rect5.size.height>280?180+rect1.size.height+rect2.size.height+rect3.size.height+rect4.size.height+rect5.size.height:280;
        }else
            return 30;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0 ||indexPath.row == 1 || indexPath.row == _commentArr.count) {
            return 30;
        }else {
            if (_commentArr.count>2) {
                
                
                GoodsCommentModel *model = [_commentArr objectAtIndex:indexPath.row];
                CGRect rect3 = [self.view contentAdaptionLabel:model.content withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                float imgHeight = 0.0f;
                if (_commetImgArr.count>0) {
                    if ([[_commetImgArr objectAtIndex:indexPath.row-2]isKindOfClass:[NSString class]]) {
                        
                    }else {
                        long arrCount = [[_commetImgArr objectAtIndex:indexPath.row-2]count]%4 == 0?([[_commetImgArr objectAtIndex:indexPath.row-2]count]/4):([[_commetImgArr objectAtIndex:indexPath.row-2]count]/4+1);
                        
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
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 30;
        }
        else {
            return 81;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell2 = @"Cell222";
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            BuyNeedKnowCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
            myCell.model = _goodsModel;
            myCell.kuaidiModel = _kuaidiModel;
            return myCell;
        }
        static NSString *cell1 = @"Cell111";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        
//        for (UIView *temView in myCell.contentView.subviews) {
//            [temView removeFromSuperview];
//        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:55];
        if (!lb) {
            lb = [self.view creatLabelWithFrame:CGRectMake(10, 0, 120, 30) AndFont:15.0 AndBackgroundColor:[UIColor clearColor] AndText:@"购买须知" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            lb.tag = 55;
            [myCell.contentView addSubview:lb];
        }
        return myCell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0 ||indexPath.row == 1 || indexPath.row == _commentArr.count) {
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
            lb12.textColor = Color_word_bg;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                lb12.text = @"查看图文详情";
                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 1) {
                if (_commentArr.count>2) {
                    lb12.text = [NSString stringWithFormat:@"网友点评（%d人评价）",[_goodsModel.comments intValue]];
                }else
                    lb12.text = @"暂无评论";
            }
            if (indexPath.row == _commentArr.count) {
                lb12.text = [NSString stringWithFormat:@"查看%d条评论",[_goodsModel.comments intValue]];
                lb12.textColor = Color_mainColor;
            }
            return myCell;
        }
        else {
            SwbCell3 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
            
            GoodsCommentModel *mmod = [_commentArr objectAtIndex:indexPath.row];
            
            if (_commentArr.count>2) {
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
            
            
            if ([[_commetImgArr objectAtIndex:indexPath.row-2] isKindOfClass:[NSString class]]) {
                NSLog(@"呵呵，没人发图片评论");
                UIView *imgViewBg = (UIView *)[myCell.contentView viewWithTag:808];
                if (imgViewBg) {
                    for (UIView *tmpV in imgViewBg.subviews) {
                        [tmpV removeFromSuperview];
                    }
                }
            }else {
                NSMutableArray *arr = [_commetImgArr objectAtIndex:indexPath.row-2];
                
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
    if (indexPath.section == 2) {
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
            lb13.textColor = Color_word_bg;
            lb13.text = @"你附近的优惠";
            return myCell;
        }
        else {
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
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CashCouponTitleTextViewController *vc = [[CashCouponTitleTextViewController alloc]init];
            vc.goodId = self.goodId;
            vc.flagStr = @"0";
            vc.picturesArr = [_photosArr mutableCopy];
            vc.goodModel = _goodsModel;
            vc.kuaidiModel = _kuaidiModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (_commentArr.count==2) return;
        else if (indexPath.row == _commentArr.count) {
            AllCommentPhotoViewController *vc = [[AllCommentPhotoViewController alloc]init];
            vc.publicId = self.goodId;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"---%d----%f",_oldOffset,scrollView.contentOffset.y);
    
    if (scrollView == _imgScr) {
        int page= _imgScr.contentOffset.x/WIDTH_CONTROLLER_DEFAULT;
        pageControl.currentPage=page;
    }
    
    if (scrollView.contentOffset.y > WIDTH_CONTROLLER_DEFAULT/2) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        [self setScrollBtnHidden:NO];
        [_buyView setHidden:NO];
        
    }
    else {
        [self setScrollBtnHidden:YES];
        [_buyView setHidden:YES];
    }
    
    
//    
//    if (scrollView.contentOffset.y > WIDTH_CONTROLLER_DEFAULT/2) {
//        [_buyView setHidden:NO];
//    }else
//        [_buyView setHidden:YES];
    

    
//    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
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
