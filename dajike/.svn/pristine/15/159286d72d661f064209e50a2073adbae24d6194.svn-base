//
//  AllCommentPhotoViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
    类：  全部评论和全部图片
 */

#import "AllCommentPhotoViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "TheCommentViewController.h"
#import "ThePhotoViewController.h"
#import "SwbCell3.h"
#import "ShopCommentModel.h"
#import "CommentImgModel.h"
#import "SwbClickImageView.h"
#import "BrowserViewBg.h"

#define img_Width ((WIDTH_CONTROLLER_DEFAULT-50)/4)

#define img_heighth img_Width

static NSString *cell3 = @"Cell33";

@interface AllCommentPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    ThePhotoViewController      *_photoVC;
    
    UIButton    *_commentBtn;
    UIButton    *_photoBtn;
    
    BOOL        _isOpenCell;
    int         _currentClickIndex;
    //评论数据源
    NSMutableArray *_commentsArr;
    NSMutableArray *_imageCommentArr;
    NSInteger _butTag;
    //晒图数据源
    NSMutableArray *_photoArr;
    NSMutableArray *_photoImgArr;
    
    //总数据源，两者切换
    NSMutableArray *_dataSource;
    NSMutableArray *_dataImgSource;
    
    int     _page;
}

@end

@implementation AllCommentPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    
    _commentsArr = [[NSMutableArray alloc]init];
     _imageCommentArr = [[NSMutableArray alloc]init];
     _photoArr = [[NSMutableArray alloc]init];
     _photoImgArr = [[NSMutableArray alloc]init];
    
    _dataSource = [[NSMutableArray alloc]init];
    _dataImgSource = [[NSMutableArray alloc]init];
    
    _page = 0;
    _currentClickIndex = -1;
    
    
    [self addTableView:UITableViewStyleGrouped];
    [self addHeaderAndFooter];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell3" bundle:nil] forCellReuseIdentifier:cell3];
    
//    [self setScrollBtnHidden:NO];
    [self addSegmentView];
    _butTag = 30;
    [self updateGoodsCommentsListData:YES andIsSuccess:^(BOOL finish) {
        
    }];
    
//    NSUInteger numberOfPages = 2;
//    _viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
//    for (NSUInteger k = 0; k < numberOfPages; ++k) {
//        [_viewControllerArray addObject:[NSNull null]];
//    }
//    _mySelectView = [[MySelectView alloc] initWithFrame:CGRectMake(0, 7, 161.5, 30)];
//    _mySelectView.myDelegate = self;
//    self.navigationItem.titleView = _mySelectView;
//    
//    _lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
//    [_lazyScrollView setEnableCircularScroll:NO];
//    [_lazyScrollView setAutoPlay:NO];
//    __weak __typeof(&*self)weakSelf = self;
//    _lazyScrollView.dataSource = ^(NSUInteger index) {
//        return [weakSelf controllerAtIndex:index];
//    };
//    _lazyScrollView.numberOfPages = 2;
//    _lazyScrollView.controlDelegate = self;
//    [self.view addSubview:_lazyScrollView];
}

// --------------------------------- 我是分割线 -------------------------------

- (void)addSegmentView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, 7, 161.5, 30) andBackgroundColor:Color_gray4];
    viewBg.layer.cornerRadius = 3.0f;
    
    _commentBtn = [self.view createButtonWithFrame:CGRectMake(0.5, 0.5, 80, 29) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"评论" andTag:30];
    _commentBtn.selected = YES;
    _commentBtn.layer.cornerRadius = 2.0f;
    _commentBtn.layer.masksToBounds = YES;
    _commentBtn.backgroundColor = Color_mainColor;
    [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [viewBg addSubview:_commentBtn];
    
    _photoBtn = [self.view createButtonWithFrame:CGRectMake(CGRectGetMaxX(_commentBtn.frame)+0.5, 0.5, 80, 29) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"晒图" andTag:31];
    _photoBtn.selected = NO;
    _photoBtn.layer.cornerRadius = 2.0f;
    _photoBtn.layer.masksToBounds = YES;
    _photoBtn.backgroundColor = [UIColor whiteColor];
    [_photoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [viewBg addSubview:_photoBtn];
    
    self.navigationItem.titleView = viewBg;
}
// tag ===   30.评论   31.晒图
- (void)btnClickedAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == _butTag) {
        return;
    }
    if (btn.tag == 30) {
        _commentBtn.backgroundColor = Color_mainColor;
        _photoBtn.backgroundColor = [UIColor whiteColor];
        _commentBtn.selected = YES;
        _photoBtn.selected = NO;
        
        //重新加载数据。一切都重新初始化
        isEnd = NO;
        _page = 0;
        [_dataSource removeAllObjects];
        [_dataImgSource removeAllObjects];
        [_imageCommentArr removeAllObjects];
        [_commentsArr removeAllObjects];
        [_photoArr removeAllObjects];
        [_photoImgArr removeAllObjects];
        _dataSource = nil;
        _dataSource = [[NSMutableArray alloc]init];
        _dataImgSource = nil;
        _dataImgSource = [[NSMutableArray alloc]init];
        
        [self updateGoodsCommentsListData:YES andIsSuccess:^(BOOL finish) {
            
        }];
        
//        //切换数据源
//        _dataSource = [_commentsArr mutableCopy];
//        _dataImgSource = [_imageCommentArr mutableCopy];
//        [self.mainTabview reloadData];
        
        NSLog(@"评论");
    }
    if (btn.tag == 31) {
        _photoBtn.backgroundColor = Color_mainColor;
        _commentBtn.backgroundColor = [UIColor whiteColor];
        _commentBtn.selected = NO;
        _photoBtn.selected = YES;
        
        //重新加载数据。一切都重新初始化
        isEnd = NO;
        _page = 0;
        [_dataSource removeAllObjects];
        [_dataImgSource removeAllObjects];
        [_imageCommentArr removeAllObjects];
        [_commentsArr removeAllObjects];
        [_photoArr removeAllObjects];
        [_photoImgArr removeAllObjects];
        _dataSource = nil;
        _dataSource = [[NSMutableArray alloc]init];
        _dataImgSource = nil;
        _dataImgSource = [[NSMutableArray alloc]init];
        
        [self updateGoodsCommentsListData:YES andIsSuccess:^(BOOL finish) {
            
        }];
        
//        //切换数据源
//        _dataSource = [_photoArr mutableCopy];
//        _dataImgSource = [_photoImgArr mutableCopy];
//        
//        [self.mainTabview reloadData];
        
        NSLog(@"晒图");
    }
    _butTag = btn.tag;
}

//右一
- (void)right1Cliped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 55) {
        [self.mainTabview setContentOffset:CGPointMake(0, 0) animated:YES];
        NSLog(@"列表滚回顶部");
    }
}

#pragma mark   TableView   Delegate  &  DataSource
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_butTag == 30) {
//        return _commentsArr.count;
//    }else{
//        return _photoArr.count;
//    }
    if (_dataSource.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSource.count>0) {
        NSString *commentStr = nil;
        ShopCommentModel *model1 = nil;
        GoodsCommentModel *model2 = nil;
        if ([self.flagStr intValue] == 0) {
            model1 = [_dataSource objectAtIndex:indexPath.row];
            commentStr = model1.comments;
        }
        if ([self.flagStr intValue] == 1) {
            model2 = [_dataSource objectAtIndex:indexPath.row];
            commentStr = model2.content;
        }
        
//        ShopCommentModel *model = [_dataSource objectAtIndex:indexPath.row];
        CGRect rect3 = [self.view contentAdaptionLabel:commentStr withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
        float imgHeight = 0.0f;
        if (_dataImgSource.count>0) {
            if ([[_dataImgSource objectAtIndex:indexPath.row]isKindOfClass:[NSString class]]) {
                
            }else {
                long arrCount = [[_dataImgSource objectAtIndex:indexPath.row]count]%4 == 0?([[_dataImgSource objectAtIndex:indexPath.row]count]/4):([[_dataImgSource objectAtIndex:indexPath.row]count]/4+1);
                
                imgHeight = rect3.size.height>43?arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+arrCount*10:arrCount*((WIDTH_CONTROLLER_DEFAULT-50)/4)+10;
            }
            
        }
        
        if (indexPath.row == _currentClickIndex) {
            if (_isOpenCell) {
                _currentClickIndex = (int)indexPath.row;
                
                CGRect rect = [self.view contentAdaptionLabel:commentStr withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                return rect.size.height+45+imgHeight;
            }
        }
        return rect3.size.height>43?90+imgHeight:rect3.size.height+40+imgHeight;
    }
    
//    if (_butTag == 30) {
//        
//    }
//    if (_butTag == 31) {
//        
//    }
//
//    if (indexPath.row == _currentClickIndex) {
//        if (_isOpenCell == YES) {
//            _currentClickIndex = (int)indexPath.row;
//            
//
//            return 120;
//        }
//        return 80;
//    }else
        return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwbCell3 *mCell = [tableView dequeueReusableCellWithIdentifier:cell3];
    
    NSString *commStr = nil;
    ShopCommentModel *model1 = nil;
    GoodsCommentModel *model2 = nil;
    if ([self.flagStr intValue] == 0) {
//        mCell.shopModel = _dataSource[indexPath.row];
        if (_dataSource.count>0) {
            model1 = [_dataSource objectAtIndex:indexPath.row];
            mCell.shopModel =model1;
            commStr = model1.comments;
        }
        
    }
    if ([self.flagStr intValue] == 1) {
//        mCell.model = _dataSource[indexPath.row];
        if (_dataSource.count>0) {
            model2 = [_dataSource objectAtIndex:indexPath.row];
            mCell.model =model2;
            commStr = model2.content;
        }
        
        
        
    }
    
//    ShopCommentModel *mmod = [_dataSource objectAtIndex:indexPath.row];
    mCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_down"];
    if (indexPath.row == _currentClickIndex) {
        if (_isOpenCell) {
            CGRect rect = [self.view contentAdaptionLabel:commStr withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
            mCell.descriptionCon.constant = rect.size.height+5;
            mCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_up"];
        }
    }
    if (_dataImgSource.count>0) {
        if ([[_dataImgSource objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            NSLog(@"呵呵，没人发图片评论");
            UIView *imgViewBg = (UIView *)[mCell.contentView viewWithTag:808];
            if (imgViewBg) {
                for (UIView *tmpV in imgViewBg.subviews) {
                    [tmpV removeFromSuperview];
                }
            }
        }else {
            NSMutableArray *arr = [_dataImgSource objectAtIndex:indexPath.row];
            
            UIView *imgViewBg = (UIView *)[mCell.contentView viewWithTag:808];
            if (!imgViewBg) {
                imgViewBg = [[UIView alloc]init];
                imgViewBg.tag = 808;
                [mCell.contentView addSubview:imgViewBg];
            }
            long viewHeight = arr.count%4 == 0?(arr.count/4):(arr.count/4+1);
            imgViewBg.frame = CGRectMake(0, CGRectGetMinY(mCell.descriptionLb.frame)+mCell.descriptionCon.constant+5, WIDTH_CONTROLLER_DEFAULT, viewHeight*img_heighth);
            
            
            for (UIView *tmpV in imgViewBg.subviews) {
                [tmpV removeFromSuperview];
            }
            
            
            for (int i=0; i<arr.count; i++) {
                CommentImgModel *model = [arr objectAtIndex:i];
                SwbClickImageView *imgv = [[SwbClickImageView alloc]initWithFrame:CGRectMake(10*(i%4+1)+i%4*img_Width, i/4*5+i/4*img_Width, img_Width, img_heighth)];
                imgv.tag = i+10;
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
    }
    
    
//    if ([self.flagStr intValue] == 0) {
//        mCell.shopModel = _dataSource[indexPath.row];
//
//        ShopCommentModel *mmod = [_dataSource objectAtIndex:indexPath.row];
//        mCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_down"];
//        if (indexPath.row == _currentClickIndex) {
//            if (_isOpenCell) {
//                CGRect rect = [self.view contentAdaptionLabel:mmod.comments withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
//                mCell.descriptionCon.constant = rect.size.height+5;
//                mCell.arrowImg.image = [UIImage imageNamed:@"img_arrow_01_up"];
//            }
//        }
//        
//        
//        if ([[_dataImgSource objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
//            NSLog(@"呵呵，没人发图片评论");
//        }else {
//            NSMutableArray *arr = [_dataImgSource objectAtIndex:indexPath.row];
//            
//            UIView *imgViewBg = (UIView *)[mCell.contentView viewWithTag:808];
//            if (!imgViewBg) {
//                imgViewBg = [[UIView alloc]init];
//                imgViewBg.tag = 808;
//                [mCell.contentView addSubview:imgViewBg];
//            }
//            imgViewBg.frame = CGRectMake(0, CGRectGetMinY(mCell.descriptionLb.frame)+mCell.descriptionCon.constant+5, WIDTH_CONTROLLER_DEFAULT, (arr.count/4+1)*img_heighth);
//            
//            
//            for (UIView *tmpV in imgViewBg.subviews) {
//                [tmpV removeFromSuperview];
//            }
//            
//            
//            for (int i=0; i<arr.count; i++) {
//                CommentImgModel *model = [arr objectAtIndex:i];
//                UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*(i%4+1)+i%4*img_Width, i/4*5+i/4*img_Width, img_Width, img_heighth)];
//                [imgv setImageWithURL:[commonTools getImgURL:model.img_url] placeholderImage:PlaceholderImage];
//                [imgViewBg addSubview:imgv];
//            }
//        }
//    }
//    if ([self.flagStr intValue] == 1) {
//        mCell.model = _dataSource[indexPath.row];
//    }
    
   
    
    return mCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SwbCell3 *cell = (SwbCell3 *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.arrowImg.hidden) {
        return;
    }
    if (indexPath.row == _currentClickIndex) {
        _isOpenCell = !_isOpenCell;
    }else{
        _isOpenCell = YES;
    }
    _currentClickIndex = (int)indexPath.row;
        [tableView reloadData];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_currentClickIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}


//全部评价列表 商品评论
- (void)updateGoodsCommentsListData:(BOOL)isFirst andIsSuccess:(void (^)(BOOL finish))success
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group  = dispatch_group_create();
    NSString *myId = @"";
    NSString *method = @"";
    if ([self.flagStr intValue] == 0) {
        myId = @"storeId";
        method = @"Stores.comments";
    }
    if ([self.flagStr intValue] == 1) {
        myId = @"goodsId";
        method = @"Goods.comments";
    }
//    dispatch_group_async(group, queue, ^{
        NSDictionary *parameter = @{myId:self.publicId,@"page":[NSString stringWithFormat:@"%d",_page+1],@"pageSize":@"10"};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:method parameters:parameter ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
                
                
                for (int i=0; i<arr.count; i++) {
//                    ShopCommentModel *model1 = nil;
//                    GoodsCommentModel *model2 = nil;
                    NSObject *model = nil;
                    if ([self.flagStr intValue] == 0) {
//                        model1 = [[ShopCommentModel alloc]init];
                        model = [[ShopCommentModel alloc]init];
                    }
                    if ([self.flagStr intValue] == 1) {
                        model = [[GoodsCommentModel alloc]init];
                    }
                    
                    
                    model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                    
                    NSMutableArray *imgArr = [[[arr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
                    if (imgArr.count == 0) {
                        [_imageCommentArr addObject:@"我是来凑数的"];
                    }else {
                        for (int j=0; j<imgArr.count; j++) {
                            CommentImgModel *mm = [[CommentImgModel alloc]init];
                            mm = [JsonStringTransfer dictionary:[imgArr objectAtIndex:j] ToModel:mm];
                            [imgArr replaceObjectAtIndex:j withObject:mm];
                        }
                        [_imageCommentArr addObject:imgArr];
                        [_photoImgArr addObject:imgArr];
                        [_photoArr addObject:model];
                    }
                    
                    
                    [arr replaceObjectAtIndex:i withObject:model];
                    
                }
                [_commentsArr addObjectsFromArray:arr];
                NSLog(@"_____photoArr=%@\n____photoImgArr=%@\n_______commentsArr=%@_______imageCommentArr=%@",_photoArr,_photoImgArr,_commentsArr,_imageCommentArr);
                
                
//                //商家评论数据源
//                if ([self.flagStr intValue]==0) {
//                    for (int i=0; i<arr.count; i++) {
//                        ShopCommentModel *model = [[ShopCommentModel alloc]init];
//                        model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
//                        
//                        if (model.img != nil) {
//                            NSMutableArray *imgArr = [[[arr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
//                            if (imgArr.count == 0) {
//                                [_imageCommentArr addObject:@"我是来凑数的"];
//                            }else {
//                                for (int j=0; j<imgArr.count; j++) {
//                                    CommentImgModel *mm = [[CommentImgModel alloc]init];
//                                    mm = [JsonStringTransfer dictionary:[imgArr objectAtIndex:j] ToModel:mm];
//                                    [imgArr replaceObjectAtIndex:j withObject:mm];
//                                }
//                                [_imageCommentArr addObject:imgArr];
//                                [_photoImgArr addObject:imgArr];
//                            }
//                            [_photoArr addObject:model];
//                        }
//                        
//                        [arr replaceObjectAtIndex:i withObject:model];
//                        
//                    }
//                    [_commentsArr addObjectsFromArray:arr];
//                    NSLog(@"_____photoArr=%@\n____photoImgArr=%@\n_______commentsArr=%@_______imageCommentArr=%@",_photoArr,_photoImgArr,_commentsArr,_imageCommentArr);
//                }
//                //商品评论数据元
//                if ([self.flagStr intValue] == 1) {
//                    for (int i=0; i<arr.count; i++) {
//                        GoodsCommentModel *model = [[GoodsCommentModel alloc]init];
//                        model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
//                        if (model.img != nil) {
//                            NSMutableArray *imgArr = [[[arr objectAtIndex:i]objectForKey:@"img"]mutableCopy];
//                            if (imgArr.count == 0) {
//                                [_imageCommentArr addObject:@"我是来凑数的"];
//                            }else {
//                                for (int j=0; j<imgArr.count; j++) {
//                                    CommentImgModel *mm = [[CommentImgModel alloc]init];
//                                    mm = [JsonStringTransfer dictionary:[imgArr objectAtIndex:j] ToModel:mm];
//                                    [imgArr replaceObjectAtIndex:j withObject:mm];
//                                }
//                                [_imageCommentArr addObject:imgArr];
//                                [_photoImgArr addObject:imgArr];
//                            }
//                            [_photoArr addObject:model];
//                        }
//                        
//                        [arr replaceObjectAtIndex:i withObject:model];
//                        
//                    }
//                    [_commentsArr addObjectsFromArray:arr];
//                }
                _page = [[responseObject.result objectForKey:@"page"] intValue];
                if (_butTag == 30) {
                    _dataImgSource = [_imageCommentArr mutableCopy];
                    _dataSource = [_commentsArr mutableCopy];
                }
                if (_butTag == 31) {
                    _dataImgSource = [_photoImgArr mutableCopy];
                    _dataSource = [_photoArr mutableCopy];
                }
                
                NSLog(@"---_--——-_dataImgSource=%@——-_-_-_-__dataSource=%@",_dataImgSource,_dataSource);
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTabview reloadData];
//                });
            }else{
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
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

//    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 120) {
        [self setScrollBtnHidden:NO];
    }else
        [self setScrollBtnHidden:YES];
}




#pragma  mark--------MJREfresh---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:100 High:80];
        success(YES);
    }else {
        [self updateGoodsCommentsListData:NO andIsSuccess:^(BOOL finish) {
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
    [_dataSource removeAllObjects];
    [_dataImgSource removeAllObjects];
    [_imageCommentArr removeAllObjects];
    [_commentsArr removeAllObjects];
    [_photoArr removeAllObjects];
    [_photoImgArr removeAllObjects];
    _dataSource = nil;
    _dataSource = [[NSMutableArray alloc]init];
    _dataImgSource = nil;
    _dataImgSource = [[NSMutableArray alloc]init];
    
    //    [_couponArr removeAllObjects];
    //    _couponArr = nil;
    //    _couponArr = [[NSMutableArray alloc]init];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}



//- (UIViewController *) controllerAtIndex:(NSInteger) index {
//    if (index > _viewControllerArray.count || index < 0) return nil;
//    id res = [_viewControllerArray objectAtIndex:index];
//    if (res == [NSNull null])
//    {
//        if (index == 0)
//        {
//            TheCommentViewController *contr = [[TheCommentViewController alloc]init];
//            contr.fatherVC = self;
//            [_viewControllerArray replaceObjectAtIndex:index withObject:contr];
//            return contr;
//        }
//        else
//        {
//            _photoVC = [[ThePhotoViewController alloc] init];
//            _photoVC.fatherVC = self;
//            [_viewControllerArray replaceObjectAtIndex:index withObject:_photoVC];
//            return _photoVC;
//        }
//    }
//    return res;
//}
//
//#pragma ProductSelViewDelegate
//- (void)selectView:(MySelectView *)mSelectView selectedIndex:(int)index
//{
//    //[_lazyScrollView setPage:index animated:YES];
//    int i = (int)[_lazyScrollView currentPage];
//    [_lazyScrollView moveByPages:index-i animated:YES];
//}
//#pragma mark - DMLazyScrollViewDelegate
//- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex
//{
//    [_mySelectView setSelectedIndex:(int)pageIndex];
//}









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
