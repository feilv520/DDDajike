//
//  DGoodsListViewController.m
//  dajike
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 
 *     商品列表
 
 */
#import "DShouyeZhiyingController.h"
#import "dDefine.h"
#import "DGoodsListTableViewCell.h"
#import "DGoodsListBlurView.h"
//#import "SKSTableView.h"
//#import "SKSTableViewCell.h"
#import "DGoodsListModel.h"
#import "SWBTabBarController.h"
#import "DGoodsListSelectTableViewCell.h"
#import "DFileOperation.h"
#import "DSelectCityView.h"
#import "DSelectCityViewController.h"
#import "DWebViewController.h"
#import "SWBTabBar.h"

@interface DShouyeZhiyingController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,DSelectCityViewDelegate>{
    BOOL twoFlag;
    BOOL threeFlag;
    BOOL fourFlag;
    
    BOOL selectFlag;
    
    //城市Id
    NSString *_cityRegionId;
    //地区Id
    NSString *_regionId;
    
//    NSMutableArray *headArray;
    NSArray *secondArray;
    
    //添加搜索框和选择城市head
    UILabel * cityLabel;
    UIImageView *cityUpImageV;
    UISearchBar *dSearchBar;
    
    
    
    //商品列表参数
    NSString *storeId;
    NSString *keywords;
    NSString *regionId;
    NSString *attrIds;
    NSString *attrValues;
    NSString *cateId;
    NSString *order;
    NSInteger page;
    
    DSelectCityView *_SelectCityView;
    //selectView 蒙板
    UIView *_selectVMengbanView;
    
    //cateId arr
    NSMutableArray *cateIdArr;
    
    //筛选
    NSMutableArray *shaixuanArr;
    
    //区分筛选和分类
    BOOL isShaixuan;
    NSInteger nowOpen;
    
    //分类 arr
    NSMutableArray *fenleiArr;
    NSInteger fNowOpen;
    
    BOOL isFirst;
}


@property (nonatomic, strong) DImgButton *oneBtn;
@property (nonatomic, strong) DImgButton *twoBtn;
@property (nonatomic, strong) DImgButton *threeBtn;
@property (nonatomic, strong) DImgButton *fourBtn;
@property (nonatomic, strong) DImgButton *fiveBtn;

@property (nonatomic, strong) DImgButton *cancelBtn;
@property (nonatomic, strong) DImgButton *successBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *twoImageV;
@property (nonatomic, strong) UIImageView *threeImageV;
@property (nonatomic, strong) UIImageView *fourImageV;

@property (nonatomic, strong) UIView *selectView;
//@property (nonatomic, strong) UIView *mView;

@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) UITableView *selectTableView;

//@property (nonatomic, strong) NSMutableArray *contents;


@property (nonatomic, strong) NSMutableArray *goodsListArray;

//区域list
@property (nonatomic, strong) NSMutableArray *quyuList;

@end

@implementation DShouyeZhiyingController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getCurrengCitys];
//    _SelectCityView.selectCityTag = [DFileOperation selectCityIndex];
    if ([DFileOperation getCurrentZhiyingCityDic] == nil) {
        //选择城市
        DSelectCityViewController *selectCityVC = [[DSelectCityViewController alloc]initWithNibName:nil bundle:nil];
        selectCityVC.isNOSelectCity = YES;
        [self.navigationController pushViewController:selectCityVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirst = YES;
    
    selectFlag = NO;
    //初始化
    storeId = @"";
    keywords = @"";
//    regionId = [[DFileOperation getCurrentZhiyingCityDic] objectForKey:@"id"];
    attrIds = @"";
    attrValues = @"";
    cateId = @"";
    order = @"";
    page = 0;
    _cityRegionId = @"";
    _regionId = @"";
    _goodsListArray = [[NSMutableArray alloc]init];
    cateIdArr = [[NSMutableArray alloc]init];
    nowOpen = 1000;
    fNowOpen = 1000;
    [self getCurrengCitys];
    

    [self setNaviBarTitle:@"区域直营"];
    [DFileOperation getAllQuyuPlaces:^(BOOL finish) {
    }];
    
 
    
    [self addSelectCityAndSearchBar];
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, DWIDTH_CONTROLLER_DEFAULT, 30)];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 1)];
    line1.backgroundColor = DColor_bg;
    [slideView addSubview:line1];
    [self.view addSubview:slideView];
    slideView.backgroundColor = DColor_White;
    
#pragma 选择按钮
    
    self.oneBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT / 5, 30)];
    [self.oneBtn setTitle:@"默认" forState:UIControlStateNormal];
    self.oneBtn.titleLabel.font = DFont_12;
    [self.oneBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
    [slideView addSubview:self.oneBtn];
    
    self.twoBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 30)];
    [self.twoBtn setTitle:@"销量" forState:UIControlStateNormal];
    self.twoBtn.titleLabel.font = DFont_12;
    [self.twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    self.twoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 10, 10, 10)];
    self.twoImageV.layer.cornerRadius = 2.0;
    self.twoImageV.layer.masksToBounds = YES;
    [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    self.twoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.twoBtn addSubview:self.twoImageV];
    [slideView addSubview:self.twoBtn];
    
    twoFlag = NO;
    
    self.threeBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.twoBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 30)];
    [self.threeBtn setTitle:@"评价" forState:UIControlStateNormal];
    self.threeBtn.titleLabel.font = DFont_12;
    [self.threeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    self.threeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 10, 10, 10)];
    self.threeImageV.layer.cornerRadius = 2.0;
    self.threeImageV.layer.masksToBounds = YES;
    [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    self.threeImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.threeBtn addSubview:self.threeImageV];
    [slideView addSubview:self.threeBtn];
    
    threeFlag = NO;
    
    self.fourBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.threeBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 30)];
    [self.fourBtn setTitle:@"价格" forState:UIControlStateNormal];
    self.fourBtn.titleLabel.font = DFont_12;
    [self.fourBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    self.fourImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 10, 10, 10)];
    self.fourImageV.layer.cornerRadius = 2.0;
    self.fourImageV.layer.masksToBounds = YES;
    [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    self.fourImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.fourBtn addSubview:self.fourImageV];
    [slideView addSubview:self.fourBtn];
    
    fourFlag = NO;
    
    self.fiveBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fourBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 30)];
    [self.fiveBtn setTitle:@"筛选" forState:UIControlStateNormal];
    self.fiveBtn.titleLabel.font = DFont_12;
    [self.fiveBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    [slideView addSubview:self.fiveBtn];
    
#pragma tableView
    
    [self addTableView:YES];
    [self.dMainTableView setFrame:DRect(0, 138, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT - 138)];
    
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    
    [self.dMainTableView registerNib:[UINib nibWithNibName:@"DGoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodslist"];
    
#pragma 筛选
    self.blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 105, DHEIGHT_CONTROLLER_DEFAULT)];
    self.blurView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.64];
    [self.view addSubview:self.blurView];
    //单击
    UITapGestureRecognizer* singleRecognizer0;
    singleRecognizer0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shaixuanHidden)];
    singleRecognizer0.numberOfTapsRequired = 1; // 单击
    [self.blurView addGestureRecognizer:singleRecognizer0];
    [self.blurView setHidden:YES];
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT - 105, DHEIGHT_CONTROLLER_DEFAULT)];
    self.selectView.backgroundColor = DColor_ffffff;
    
    [self.view addSubview:self.selectView];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.selectView.frame.size.width, DHEIGHT_CONTROLLER_DEFAULT - 64) style:UITableViewStyleGrouped];
    [self.selectTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    
    self.selectTableView.backgroundColor = DColor_White;
    
//    [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"select"];
    
    [self.selectView addSubview:self.selectTableView];
    
    self.cancelBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 22, 50, 40)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = DFont_12;
    [self.cancelBtn addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:DColor_808080 forState:UIControlStateNormal];
    [self.selectView addSubview:self.cancelBtn];
    
    self.successBtn = [[DImgButton alloc] initWithFrame:CGRectMake(self.selectView.frame.size.width - 50, 22, 50, 40)];
    [self.successBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.successBtn.titleLabel.font = DFont_12;
    [self.successBtn addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.successBtn setTitleColor:DColor_808080 forState:UIControlStateNormal];
    [self.selectView addSubview:self.successBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 40, 22, 100, 30)];
    self.titleLabel.text = @"筛选";
    self.titleLabel.font = DFont_15;
    self.titleLabel.textColor = DColor_666666;
    [self.selectView addSubview:self.titleLabel];
    
    [self refreshData:^(BOOL finish) {
    }];
    
    _selectVMengbanView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-108)];
    _selectVMengbanView.backgroundColor = DColor_mengban;
    [self.view addSubview:_selectVMengbanView];
    [self.view bringSubviewToFront:_selectVMengbanView];
    //单击
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_selectVMengbanView addGestureRecognizer:singleRecognizer];
    [_selectVMengbanView setHidden:YES];
    
    _SelectCityView = [[DSelectCityView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 210)];
    _SelectCityView.myDelegate = self;
    [_selectVMengbanView addSubview:_SelectCityView];
    [_SelectCityView setHidden:YES];
}

//获取当前城市
- (void) getCurrengCitys
{
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:[DFileOperation getCurrentZhiyingCityDic]];
    if ([[cityDic objectForKey:@"pid"]intValue] == 0) {
        _cityRegionId = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"id"]];
        _regionId = @"";
    }else {
        _cityRegionId = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"pid"]];
        _regionId = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"id"]];
    }
    
     [self setCurrentSelectCity:[cityDic objectForKey:@"pname"] andquxian:[cityDic objectForKey:@"name"]];
    [_SelectCityView addSubViewsWithCity:cityDic];
}

- (void)viewWillDisappear:(BOOL)animated{
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:NO];
    if([DMyAfHTTPClient sharedClient].indicator.animatCount)
        [DMyAfHTTPClient sharedClient].indicator.animatCount = 0;
    [[DMyAfHTTPClient sharedClient].indicator progresshHUDRemovedFast];
}

#pragma 取消和完成动作
- (void)selectButtonAction:(DImgButton *)btn{
    nowOpen = 1000;
    fNowOpen = 1000;
    if (btn == self.cancelBtn) {
        [UIView animateWithDuration:0.5f animations:^{
            self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            self.blurView.hidden = YES;
        } completion:^(BOOL finished) {
            NSLog(@"FINISHED");
        }];
    } else if(btn == self.successBtn){
//        [self buttonAction:self.oneBtn];
        order = @"";
//        [self refreshData:^(BOOL finish) {
//        }];
        [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            fourFlag = YES;
        }];
        attrIds = @"";
        for (int i = 0; i < shaixuanArr.count; i++) {
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:i]objectForKey:@"isFlag"]] ;
            BOOL hasSelected = NO;
            for (int j = 0; j < isFlagArr.count; j++) {
                BOOL isflag = [[isFlagArr objectAtIndex:j]boolValue];
                if (isflag == YES) {
                    hasSelected = YES;
                }
            }
            if (hasSelected == YES) {
                if ([attrIds isEqualToString:@""]) {
                    attrIds = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:i]objectForKey:@"attr_id"]];
                }else{
                    attrIds = [attrIds stringByAppendingString:[NSString stringWithFormat:@",%@",[[shaixuanArr objectAtIndex:i]objectForKey:@"attr_id"]]];
                }
            }
        }
        [self refreshData:^(BOOL finish) {
        }];
        [UIView animateWithDuration:0.5f animations:^{
            self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            self.blurView.hidden = YES;
        } completion:^(BOOL finished) {
            NSLog(@"FINISHED");
//            [self refreshData:^(BOOL finish) {
//            }];
        }];
    }
}


#pragma tableView delegate 的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            if (shaixuanArr.count > 0) {
                return shaixuanArr.count;
            }
            return 0;
        }else{
            if (fenleiArr.count > 0) {
                return fenleiArr.count+1;
            }
            return 1;
        }
    }
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            return 40;
        }else{
            return 40;
        }
    }
    return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            
        }else{
            
        }
    }
    return 0.5f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            if (section == nowOpen) {
                if (shaixuanArr.count > section) {
                    return [[[shaixuanArr objectAtIndex:section]objectForKey:@"def_value"] count];
                }
                return  0;
            }
            return 0;
        }else{
            if (section == fNowOpen) {
                if (fenleiArr.count >= section) {
                    return [[[fenleiArr objectAtIndex:section-1]objectForKey:@"two"] count];
                }
                return  0;
            }
            return 0;
        }
    }
    
    if (self.goodsListArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return self.goodsListArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            UIView *bV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
            bV.backgroundColor = DColor_cccccc;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 320, 39)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = section;
            [btn addTarget:self action:@selector(toBtns:) forControlEvents:UIControlEventTouchUpInside];
            [bV addSubview:btn];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 39)];
            [label setFont:DFont_12];
            [label setTextColor:DColor_666666];
            //    label.tag = 2000+section;
            label.text = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:section]objectForKey:@"attr_name"]];
            NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:section] objectForKey:@"selectAttr"]];
            if ([selectAttrStr isEqualToString:@""]) {
                label.text = [NSString stringWithFormat:@"%@",label.text];
            }else{
                label.text = [NSString stringWithFormat:@"%@(%@)",label.text,selectAttrStr];
            }
            [btn addSubview:label];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 13, 13, 7)];
            [imageView setTag:2000+section];
            [imageView setImage:[UIImage imageNamed:@"img_pub_gray"]];
            [btn addSubview:imageView];
            
            return bV;
        }
        UIView *bV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        bV.backgroundColor = DColor_cccccc;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 320, 39.5)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = section;
        [btn addTarget:self action:@selector(toFenleiBtns:) forControlEvents:UIControlEventTouchUpInside];
        [bV addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 39.5)];
        [label setFont:DFont_12];
        [label setTextColor:DColor_666666];
        //    label.tag = 2000+section;
        if (section == 0) {
            label.text = @"全部商品";
        }else{
            label.text = [NSString stringWithFormat:@"%@",[[fenleiArr objectAtIndex:section-1] objectForKey:@"cate_name"]];
        }
        [btn addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 13, 13, 7)];
        [imageView setTag:2000+section];
        [imageView setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [btn addSubview:imageView];
        if (section == 0) {
            [imageView setHidden:YES];
        }else{
            if ([[[fenleiArr objectAtIndex:section-1] objectForKey:@"two"] count] == 0) {
                [imageView setHidden:YES];
            }
        }
        
        
        return bV;
    }else{
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            NSString *stridentifer = @"select";
            [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:stridentifer];
            DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stridentifer];
            NSLog(@"shaixuanArr = %@",shaixuanArr);
            if (shaixuanArr.count > indexPath.section) {
                NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"isFlag"]] ;
                NSLog(@"shaixuanArr = %@",isFlagArr);
                NSLog(@"indexPath.row = %d",indexPath.row);
                NSLog(@"indexPath.section = %d",indexPath.section);
                BOOL isflag = [[isFlagArr objectAtIndex:indexPath.row]boolValue];
                if (isflag) {
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
                }else{
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
                }
                cell.contentView.backgroundColor = DColor_mainRed;
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"def_value"] objectAtIndex:indexPath.row]];
                //    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
            }
            return cell;

        }else{
            static NSString *identifer = @"fenleiCell";
            UITableViewCell *fenleiCell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (fenleiCell == nil) {
                fenleiCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                fenleiCell.backgroundColor = DColor_f6f1ef;
            }
            [fenleiCell.textLabel setFont:DFont_14];
            [fenleiCell.textLabel setTextColor:DColor_666666];
            if (fenleiArr.count > indexPath.section-1) {
                NSArray *fenlei2Arr = [NSArray arrayWithArray:[[fenleiArr objectAtIndex:indexPath.section-1] objectForKey:@"two"]];
                fenleiCell.textLabel.text = [NSString stringWithFormat:@"%@",[[fenlei2Arr objectAtIndex:indexPath.row] objectForKey:@"cate_name"]];
            }
            return fenleiCell;
        }
    }
    else {
        DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
        if (self.goodsListArray.count > indexPath.row) {
            DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:[goodsListModel default_image]]];
            cell.titleLabel.text = [goodsListModel goods_name];
            cell.commintLabel.text = [NSString stringWithFormat:@"%@%%好评",[goodsListModel haoping]];
            NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[goodsListModel price]]];
            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyString.length - 2, 2)];
            cell.moneyLabel.attributedText = moneyString;
            cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[goodsListModel comments]];
        }
        return cell;
    }
    return nil;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSString *stridentifer = [NSString stringWithFormat:@"select%ld%ld",indexPath.row,indexPath.subRow];
//    NSString *stridentifer = @"select";
//    [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:stridentifer];
//    DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stridentifer];
//    NSLog(@"shaixuanArr = %@",shaixuanArr);
//    NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:indexPath.row]objectForKey:@"isFlag"]] ;
//    BOOL isflag = [[isFlagArr objectAtIndex:indexPath.subRow-1]boolValue];
//    if (isflag) {
//        [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
//    }else{
//        [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
//    }
//    cell.contentView.backgroundColor = DColor_mainRed;
//    
//    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[[shaixuanArr objectAtIndex:indexPath.row]objectForKey:@"def_value"] objectAtIndex:indexPath.subRow-1]];
////    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            return 44.0f;
        }else{
            return 44.0f;
        }
    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:self.selectTableView]) {
        if (isShaixuan) {
            DGoodsListSelectTableViewCell *cell = (DGoodsListSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"shaixuanArr%@",shaixuanArr);
            NSLog(@"indexPath.row%d",indexPath.row);
            if ([cell isKindOfClass:[DGoodsListSelectTableViewCell class]]){
                NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:indexPath.section] objectForKey:@"selectAttr"]];
                
                NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"isFlag"]] ;
                BOOL isflag = [[isFlagArr objectAtIndex:indexPath.row]boolValue];
                if (isflag) {
                    selectAttrStr = [selectAttrStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",cell.nameLabel.text] withString:@""];
                    
                    if (![selectAttrStr hasPrefix:@","] && ![selectAttrStr hasSuffix:@","]) {
                        selectAttrStr = [selectAttrStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",cell.nameLabel.text] withString:@""];
                    }
                    if ([selectAttrStr hasSuffix:@","]) {
                        selectAttrStr = [selectAttrStr substringWithRange:NSMakeRange(0, selectAttrStr.length - 1)];
                    }
                    if ([selectAttrStr hasPrefix:@","]) {
                        selectAttrStr = [selectAttrStr substringWithRange:NSMakeRange(1, selectAttrStr.length - 1)];
                    }
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
                    isflag = NO;
                } else {
                    if ([selectAttrStr isEqualToString:@""]) {
                        selectAttrStr = [NSString stringWithFormat:@"%@",cell.nameLabel.text];
                    } else {
                        selectAttrStr = [NSString stringWithFormat:@"%@,%@",selectAttrStr,cell.nameLabel.text];
                    }
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
                    isflag = YES;
                }
                [isFlagArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%hhd",isflag]];
                NSMutableDictionary *shaixuanDic = [shaixuanArr objectAtIndex:indexPath.section];
                [shaixuanDic setObject:isFlagArr forKey:@"isFlag"];
                [shaixuanDic setObject:selectAttrStr forKey:@"selectAttr"];
                [shaixuanArr replaceObjectAtIndex:indexPath.section withObject:shaixuanDic];
                [self.selectTableView reloadData];
        }
    
        }else{
            NSArray *fenlei2Arr = [NSArray arrayWithArray:[[fenleiArr objectAtIndex:indexPath.section-1] objectForKey:@"two"]];
            //            fenleiCell.textLabel.text = [NSString stringWithFormat:@"%@",[[fenlei2Arr objectAtIndex:indexPath.row] objectForKey:@"cate_name"]];
            cateId = [NSString stringWithFormat:@"%@",[[fenlei2Arr objectAtIndex:indexPath.row] objectForKey:@"cate_id"]];
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5f animations:^{
                self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
                self.blurView.hidden = YES;
            } completion:^(BOOL finished) {
                NSLog(@"FINISHED");
            }];

        }
    }
    else
    {
        if (self.goodsListArray.count > indexPath.row) {
            DWebViewController *vc = [[DWebViewController alloc]init];
            DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
            vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",goodsListModel.goods_id,get_userId];
            vc.type = IS_NEED_ADD;
            vc.goodId = [NSString stringWithFormat:@"%@",goodsListModel.goods_id];
            vc.imageUrl = [NSString stringWithFormat:@"%@",goodsListModel.default_image];
            vc.googsTitle = [NSString stringWithFormat:@"%@",goodsListModel.goods_name];
            vc.isHelp = 6;
            push(vc);
        }
    }
}

//- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
//{
////    return [self.contents[indexPath.row] count] - 1;
//    return [[[shaixuanArr objectAtIndex:indexPath.row]objectForKey:@"def_value"] count];
//}


#pragma 按钮的实现方法
- (void)buttonAction:(DImgButton *)btn{
    [self.oneBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fourBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    if (btn == self.oneBtn) {
        order = @"";
        [self refreshData:^(BOOL finish) {
        }];
        [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            fourFlag = YES;
        }];
    } else if (btn == self.twoBtn){
        [self.twoBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        if (twoFlag) {
            order = @"sum_sales_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = NO;
            }];
        }
        else {
            order = @"sum_sales_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = YES;
            }];
        }
    } else if (btn == self.threeBtn){
        [self.threeBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        if (threeFlag) {
            order = @"haoping_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.threeImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = NO;
            }];
        }
        else {
            order = @"haoping_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = YES;
            }];
        }
    } else if (btn == self.fourBtn){
        [self.fourBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        if (fourFlag) {
            order = @"price_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.fourImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = NO;
            }];
        }
        else {
            order = @"price_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5f animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = YES;
            }];
        }
    } else if (btn == self.fiveBtn){
        [self.fiveBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        isShaixuan = YES;
        self.titleLabel.text = @"筛选";
        [self.cancelBtn setHidden:NO];
        [self.successBtn setHidden:NO];
        [self loadingScreen:cateId];
        [UIView animateWithDuration:0.5f animations:^{
            
            self.selectView.frame = CGRectMake(105, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            [self.view bringSubviewToFront:self.selectView];
        } completion:^(BOOL finished) {
            [self.blurView setHidden:NO];
            [self.view bringSubviewToFront:self.blurView];
        }];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//添加搜索框和选择城市head
- (void) addSelectCityAndSearchBar
{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, 44)];
    [self.view addSubview:headview];
    
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 5, 34)];
    [cityLabel setFont:DFont_11];
    [cityLabel setTextColor:DColor_666666];
    [cityLabel setNumberOfLines:0];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    [headview addSubview:cityLabel];
    
    cityUpImageV = [[UIImageView alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x+cityLabel.frame.size.width, 19, 10, 6)];
    [cityUpImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [headview addSubview:cityUpImageV];
    
    UIButton *cityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cityButton setBackgroundColor:[UIColor clearColor]];
    [cityButton addTarget:self action:@selector(cityButtonClip:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:cityButton];
    
//    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(cityUpImageV.frame.origin.x+10+20, 10, 30, 24)];
    dSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(cityUpImageV.frame.origin.x+10+10, 10, DWIDTH_CONTROLLER_DEFAULT- 2*(cityUpImageV.frame.origin.x+20), 24)];
//    [searchBar setBarStyle:UIBarStyleDefault];
    [dSearchBar setSearchBarStyle:UISearchBarStyleDefault];
    dSearchBar.placeholder = @"请输入商品/店铺";
    [dSearchBar setBarTintColor:[UIColor whiteColor]];
    [dSearchBar setBackgroundColor:[UIColor whiteColor]];
    [dSearchBar setTintColor:[UIColor whiteColor]];
    [dSearchBar.layer setMasksToBounds:YES];
    dSearchBar.layer.borderColor = [DColor_f3f3f3 CGColor];
    dSearchBar.layer.borderWidth = 1.0;
    dSearchBar.layer.contentsScale = 5.0;
    dSearchBar.delegate = self;
    
    [headview addSubview:dSearchBar];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT-50, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(feileiBUttonClip:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 17, 17)];
    rightImageV.layer.cornerRadius = 2.0;
    rightImageV.layer.masksToBounds = YES;
    [rightImageV setImage:[UIImage imageNamed:@"img_pub_04"]];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addSubview:rightImageV];
    [headview addSubview:rightBtn];
    
    [self setCurrentSelectCity:@"全城" andquxian:@"上海"];

}
//根据字体调整frame
- (void) setCurrentSelectCity:(NSString *)PCityname andquxian:(NSString *)quName
{
    CGRect  size = [cityLabel contentAdaptionLabel:PCityname.length>quName.length ? PCityname:quName withSize:CGSizeMake(100, 34) withTextFont:12];
    [cityLabel setFrame:CGRectMake(15, 5, size.size.width, 34)];
    [cityUpImageV setFrame:CGRectMake(cityLabel.frame.origin.x+cityLabel.frame.size.width, 19, 10, 6)];
    [dSearchBar setFrame:CGRectMake(cityUpImageV.frame.origin.x+10+10, 10, DWIDTH_CONTROLLER_DEFAULT- (cityUpImageV.frame.origin.x+20)-50, 24)];
    
//    if ([quName isEqualToString:@""]||quName == nil ) {
//        cityLabel.text = [NSString stringWithFormat:@"%@",PCityname];
//    }else{
//        cityLabel.text = [NSString stringWithFormat:@"%@\n%@",PCityname,quName];
//    }
    if ([PCityname isEqualToString:@"全城"]) {
        cityLabel.text = [NSString stringWithFormat:@"%@",quName];
    }else{
        cityLabel.text = [NSString stringWithFormat:@"%@\n%@",PCityname,quName];
    }
}


#pragma feileiBUttonClip
- (void)feileiBUttonClip:(id)sender
{
    if (fenleiArr.count > 0) {
        
    }else{
        NSDictionary *paramerDic = @{@"cityRegionId":_cityRegionId,@"regionId":_regionId};
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.cateFwzxZhiying" parameters:paramerDic ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                if (fenleiArr != nil) {
                    [fenleiArr removeAllObjects];
                    fenleiArr = nil;
                }
                fenleiArr = [[NSMutableArray alloc]init];
                for (NSDictionary *fenlei1Dic in responseObject.result) {
                    [fenleiArr addObject:fenlei1Dic];
                }
                [self.selectTableView reloadData];
            }else {
                showMessage(responseObject.msg);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
            showMessage(@"请求失败");
        }];

    }
    
    isShaixuan = NO;
    self.titleLabel.text = @"分类";
    [self.cancelBtn setHidden:YES];
    [self.successBtn setHidden:YES];
    [UIView animateWithDuration:0.5f animations:^{
        
        self.selectView.frame = CGRectMake(105, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
        [self.view bringSubviewToFront:self.selectView];
    } completion:^(BOOL finished) {
        [self.blurView setHidden:NO];
        [self.view bringSubviewToFront:self.blurView];
        
    }];

}


#pragma cityButtonClip
- (void) cityButtonClip:(id) sender
{
    if (_SelectCityView.isHidden == YES) {
        [_SelectCityView setHidden:NO];
        [_selectVMengbanView setHidden:NO];
        [self getCurrengCitys];
    }else{
        [_SelectCityView setHidden:YES];
        [_selectVMengbanView setHidden:YES];
        [self getCurrengCitys];
    }

}

#pragma mark------
#pragma mark------SelectCityViewDelegate---------
- (void) changeCity
{
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    DSelectCityViewController *selectCityVC = [[DSelectCityViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void) selectView:(DSelectCityView *)mSelectView selectedIndex:(int)index
{
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    NSInteger cityId = [[[DFileOperation getCurrentZhiyingCityDic]objectForKey:@"id"]integerValue];
    NSArray *cityAr = [DFileOperation getAllQuyuByCityId:cityId];
    [DFileOperation writeCurrentCityWithCityDic:[cityAr  objectAtIndex:index]];
    [self getCurrengCitys];
}
#pragma mark------
#pragma mark------单击萌版---------
- (void)handleSingleTapFrom
{
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    [self getCurrengCitys];
}

#pragma mark-----
#pragma mark---------load data---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
        success (YES);
    }else{
        [self loadingData:^(BOOL finish) {
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
    page = 0;
    [_goodsListArray removeAllObjects];
    _goodsListArray = nil;
    _goodsListArray = [[NSMutableArray alloc]init];
    
    [cateIdArr removeAllObjects];
    cateIdArr = nil;
    cateIdArr = [[NSMutableArray alloc]init];
    
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

#pragma 网络请求方法
- (void)loadingData:(void (^)(BOOL finish))success{
    attrValues = @"";
    for (int i = 0; i < shaixuanArr.count; i++) {
        NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:i] objectForKey:@"selectAttr"]];
        if (![selectAttrStr isEqualToString:@""]) {
            if ([attrValues isEqualToString:@""]) {
                attrValues = [NSMutableString stringWithFormat:@"%@",selectAttrStr];
            }else{
                attrValues = [attrValues stringByAppendingFormat:@",%@",selectAttrStr];
            }
        }
    }
    if ([keywords isEqualToString:@""]&&[cateId isEqualToString:@""]&&[attrValues isEqualToString:@""]) {
        NSDictionary *paramerDic;
        if ([FileOperation isLogin]) {
            paramerDic = @{@"userId":[FileOperation getUserId],@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"recomId":@"64"};
        }else{
            paramerDic = @{@"userId":@"",@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"recomId":@"64"};
        }
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.indexRecommend" parameters:paramerDic ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                NSArray *dataArr = [responseObject.result objectForKey:@"data"];
                for (NSDictionary *dic in dataArr) {
                    DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                    goodsList = [JsonStringTransfer dictionary:dic ToModel:goodsList];
                    [self.goodsListArray addObject:goodsList];
                    [cateIdArr addObject:[NSString  stringWithFormat:@"%@",goodsList.goods_id]];
                    //                cateId = [NSString stringWithFormat:@"%@,%ld",cateId,[goodsList goods_id]];
                }
                //            cateId = [cateId substringWithRange:NSMakeRange(1, cateId.length - 1)];
                page++;
                if (dataArr.count < 10) {
                    isEnd = YES;
                }
            }
            else
            {
                if ([responseObject.msg length] == 0) {
                    [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
                }else
                    [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
            success(YES);
             [self.dMainTableView reloadData];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            success(YES);
            showMessage(@"请求失败");
             [self.dMainTableView reloadData];
        }];
        isFirst = NO;

    }else{
        NSDictionary *parameter = @{@"order":order,@"storeId":storeId,@"keywords":keywords,@"regionId":[NSString stringWithFormat:@"%@",[[DFileOperation getCurrentZhiyingCityDic] objectForKey:@"id"]],@"attrIds":attrIds,@"attrValues":attrValues,@"cateId":cateId,@"page":[NSString stringWithFormat:@"%ld",page+1],@"pageSize":@"10"};
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                NSArray *dataArr = [responseObject.result objectForKey:@"data"];
                for (NSDictionary *dic in dataArr) {
                    DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                    goodsList = [JsonStringTransfer dictionary:dic ToModel:goodsList];
                    [self.goodsListArray addObject:goodsList];
                    [cateIdArr addObject:[NSString  stringWithFormat:@"%@",goodsList.goods_id]];
                    //                cateId = [NSString stringWithFormat:@"%@,%ld",cateId,[goodsList goods_id]];
                }
                //            cateId = [cateId substringWithRange:NSMakeRange(1, cateId.length - 1)];
                page++;
                if (dataArr.count < 10) {
                    isEnd = YES;
                }
            }
            else
            {
                if ([responseObject.msg length] == 0) {
                    [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
                }else
                    [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
            [self.dMainTableView reloadData];
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
            [self.dMainTableView reloadData];
            success(YES);
        }];

    }
}

- (void)loadingScreen:(NSString *)goodsIDString{
    NSDictionary *parameter;
    NSMutableString *cateIdStr = [NSMutableString stringWithString:@""];
//    if ([goodsIDString isEqualToString:@""]) {
        int count = 0;
        if (cateIdArr.count > 10) {
            count = 10;
        }else{
            count = cateIdArr.count;
        }
        
//        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",[cateIdArr objectAtIndex:0]];
//        NSMutableString *cateIdStr = [[NSMutableString  alloc]initWithString:@"abcd"];
        for (int i = 0; i < count; i++) {
            if (i == 0) {
                [cateIdStr appendFormat:@"%@",[cateIdArr objectAtIndex:i]];
            }else{
                [cateIdStr appendFormat:@",%@",[cateIdArr objectAtIndex:i]];
            }
        }
//        parameter = @{@"goodsIds":[NSString stringWithFormat:@"%@",cateIdStr],@"keywords":keywords};
        parameter = @{@"goodsIds":cateIdStr,@"keywords":keywords};
//    }
//else{
//        parameter = @{@"goodsIds":goodsIDString,@"keywords":keywords};
//    }
    NSLog(@"parameter=%@",parameter);
    NSLog(@"cateIdStr=%@",cateIdStr);
    
    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.screen" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            if (shaixuanArr != nil) {
                [shaixuanArr removeAllObjects];
                shaixuanArr = nil;
            }
            shaixuanArr = [[NSMutableArray alloc]init];
            if ([responseObject.result isKindOfClass:[NSString class]]) {
                [self.selectTableView reloadData];
                showMessage(@"没有相关筛选！");
                return ;
            }
//            if ([responseObject.result isEqualToString:@""]) {
//                 [self.selectTableView reloadData];
//                return ;
//            }
            for (NSDictionary *dic in responseObject.result) {
                NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
                NSArray *defValueArr = [[dic objectForKey:@"def_value"] componentsSeparatedByString:@","];
                [muDic setObject:defValueArr forKey:@"def_value"];
                [muDic setObject:[dic objectForKey:@"attr_id"] forKey:@"attr_id"];
                [muDic setObject:[dic objectForKey:@"attr_name"] forKey:@"attr_name"];
                NSMutableArray *isflagArr = [[NSMutableArray alloc]init];
                for (int i = 0; i < defValueArr.count; i++) {
                    [isflagArr insertObject:@"0" atIndex:i];
                }
                [muDic setObject:isflagArr forKey:@"isFlag"];
                [muDic setObject:@"" forKey:@"selectAttr"];
                [shaixuanArr addObject:muDic];
            }
            [self.selectTableView reloadData];
        }
        else
        {
             [self.selectTableView reloadData];
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


- (void) toBtns:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"btn.tag = %d",btn.tag);
    
    
    
    if (btn.tag == nowOpen) {
        nowOpen = 1000;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:btn.tag]objectForKey:@"isFlag"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(0);
        
        [self.selectTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }else{
        if (nowOpen != 1000) {
            
            NSInteger nowClose = nowOpen;
            nowOpen = 1000;
            NSMutableArray *arr0 = [[NSMutableArray alloc]init];
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:nowClose]objectForKey:@"isFlag"]] ;
            for (int i = 0; i < isFlagArr.count; i++) {
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:nowClose];
                [arr0 addObject:indesPath];
            }
            
            UIImageView *imageV = (UIImageView *)[self.selectTableView viewWithTag:2000+nowClose];
            imageV.transform = CGAffineTransformMakeRotation(0);
            
            [self.selectTableView deleteRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationTop];
            nowOpen = btn.tag;
            
        }else{
            nowOpen = btn.tag;
            
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:btn.tag]objectForKey:@"isFlag"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }
}

- (void) toFenleiBtns:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"btn.tag = %d",btn.tag);
    
    if (btn.tag == 0) {
        return;
    }else{
        if ([[[fenleiArr objectAtIndex:btn.tag-1] objectForKey:@"two"] count] == 0) {
            nowOpen = 1000;
            fNowOpen = 1000;
            cateId = [NSString stringWithFormat:@"%@",[[fenleiArr objectAtIndex:btn.tag - 1] objectForKey:@"cate_id"]];
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5f animations:^{
                self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
                self.blurView.hidden = YES;
            } completion:^(BOOL finished) {
                NSLog(@"FINISHED");
            }];
            return;
        }
    }
    
    if (btn.tag == fNowOpen) {
        fNowOpen = 1000;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[fenleiArr objectAtIndex:btn.tag-1]objectForKey:@"two"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(0);
        
        [self.selectTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
    }else{
        if (fNowOpen != 1000) {
            
            NSInteger nowClose = fNowOpen;
            fNowOpen = 1000;
            NSMutableArray *arr0 = [[NSMutableArray alloc]init];
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[fenleiArr objectAtIndex:nowClose-1]objectForKey:@"two"]] ;
            for (int i = 0; i < isFlagArr.count; i++) {
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:nowClose];
                [arr0 addObject:indesPath];
            }
            
            UIImageView *imageV0 = (UIImageView *)[self.selectTableView viewWithTag:2000+nowClose];
            imageV0.transform = CGAffineTransformMakeRotation(0);
            [self.selectTableView deleteRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationNone];
            fNowOpen = btn.tag;
        }else{
            fNowOpen = btn.tag;
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[fenleiArr objectAtIndex:btn.tag-1]objectForKey:@"two"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        
        UIImageView *imageV1 = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV1.transform = CGAffineTransformMakeRotation(M_PI);
        
        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }
}


#pragma mark----
#pragma mark------UISearchBarDelegate--------
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    keywords = [NSString stringWithFormat:@"%@",searchBar.text];
    [dSearchBar endEditing:YES];
    [self refreshData:^(BOOL finish) {
    }];
}
- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"nihao = %@",searchBar.text);
    if ([dSearchBar.text isEqualToString:@""]) {
        keywords = @"";
        [self refreshData:^(BOOL finish) {
        }];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    dSearchBar.text = @"";
    [dSearchBar endEditing:YES];
}

//单击筛选萌版，筛选侧边拦消失
- (void) shaixuanHidden
{
    [UIView animateWithDuration:0.5f animations:^{
        self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
        self.blurView.hidden = YES;
    } completion:^(BOOL finished) {
        NSLog(@"FINISHED");
    }];
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
