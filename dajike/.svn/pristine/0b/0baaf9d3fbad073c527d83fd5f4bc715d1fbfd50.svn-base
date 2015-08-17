//
//  CashCouponTitleTextViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 类：  代金券图文详情
 */

#import "CashCouponTitleTextViewController.h"
#import "defines.h"
#import "SwbBuyView.h"
#import "CouponBuyNeedKownCell.h"
#import "LoginViewController.h"
#import "WriteIndentViewController.h"
#import "BuyNeedKnowCell.h"
#import "FillInIndentViewController.h"

#import "PictureTextDetailModel.h"

static NSString *swbCell = @"CouponBuyNeedKownCell";
static NSString *swbCell1 = @"BuyNeedKnowCell";

@interface CashCouponTitleTextViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int     _oldOffSet;
    
//    NSMutableArray *_dataSource;
}

@end

@implementation CashCouponTitleTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    [self setNavType:SHAREANGSHOUCANG_BUTTON];
    [self setStoreBtnHidden:YES];
    _oldOffSet = 120;
//    _dataSource = [[NSMutableArray alloc]init];
    
    titleLabel.text = @"图文详情";
    
    [self setBuyView];
    
    
    [self addTableView:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview setFrame:CGRectMake(0, 45, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-45)];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"CouponBuyNeedKownCell" bundle:nil] forCellReuseIdentifier:swbCell];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BuyNeedKnowCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    
//    [self getData];
    
}

// ----------------------------- 分割线 -------------------------------

- (void)setBuyView
{
    NSString *price = @"";
    NSString *marketPrice = @"";
    NSString *lottery = @"";
    
    if ([self.flagStr intValue] == 0) {
        price = self.goodModel.price;
        marketPrice = self.goodModel.market_price;
        lottery = [NSString stringWithFormat:@"%.0f%%累计抽奖",[self.goodModel.choujiang_bili floatValue]*100];
    }
    if ([self.flagStr intValue] == 1) {
        price = self.model.price;
        marketPrice = self.model.market_price;
        lottery = [NSString stringWithFormat:@"%.0f%%累计抽奖",[self.model.choujiang_bili floatValue]*100];
    }
    SwbBuyView *buyView = [[SwbBuyView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 45)];
    buyView.priceLb.text = [NSString stringWithFormat:@"%.2f元",[price floatValue]];
    CGRect rect1 = [self.view contentAdaptionLabel:buyView.priceLb.text withSize:CGSizeMake(1000, 20) withTextFont:14.0f];
    buyView.priceLb.frame = CGRectMake(10, 1, rect1.size.width+5, 20);
    if ([marketPrice floatValue]>0) {
        buyView.notPriceLb.text = [NSString stringWithFormat:@"%.2f元",[marketPrice floatValue]];
        CGRect rect2 = [self.view contentAdaptionLabel:buyView.notPriceLb.text withSize:CGSizeMake(1000, 10) withTextFont:14.0f];
        buyView.notPriceLb.frame = CGRectMake(CGRectGetMaxX(buyView.priceLb.frame)+10, 5, rect2.size.width+5, 10);
        [buyView.notPriceLb setHidden:NO];
    }else
        [buyView.notPriceLb setHidden:YES];
    buyView.lotteryLb.text = lottery;
    
    [buyView CallBackBuyBtnClicked:^{
        NSLog(@"立即购买");
        if ([self.flagStr intValue] == 0) {
            NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
            if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
                FillInIndentViewController *vc = [[FillInIndentViewController alloc]init];
                vc.goodModel = self.goodModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if ([self.flagStr intValue] == 1) {
            WriteIndentViewController *writeVC = [[WriteIndentViewController alloc]init];
            writeVC.model = self.model;
            [self.navigationController pushViewController:writeVC animated:YES];
        }
        
        
    }];
    
    [self.view addSubview:buyView];
}

//- (void)getData
//{
//    NSDictionary *parameter = @{@"goodsId":self.goodId};
//    
//    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCoupons.twDetail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//        if (responseObject.succeed) {
//            NSLog(@"result = %@",responseObject.result);
//            
//            NSMutableArray *arr = [responseObject.result mutableCopy];
//            for (int i=0; i<arr.count; i++) {
//                PictureTextDetailModel *model = [[PictureTextDetailModel alloc]init];
//                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
//                [arr replaceObjectAtIndex:i withObject:model];
//            }
//            [_dataSource addObjectsFromArray:arr];
//            [self.mainTabview reloadData];
//        }
//        else
//        {
//            if ([responseObject.msg length] == 0) {
//                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
//            }else
//                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",error);
//        NSLog(@"operation6 = %@",operation);
//    }];
//}


//右一
- (void)right1Cliped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 55) {
        [self.mainTabview setContentOffset:CGPointMake(0, 0) animated:YES];
        NSLog(@"列表滚回顶部");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.5;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.flagStr intValue] == 0) {
            CGRect rect1 = [self.view contentAdaptionLabel:_kuaidiModel.fanwei withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect2 = [self.view contentAdaptionLabel:_kuaidiModel.kuaidi withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect3 = [self.view contentAdaptionLabel:_kuaidiModel.feiyong withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect4 = [self.view contentAdaptionLabel:_kuaidiModel.shijian withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            CGRect rect5 = [self.view contentAdaptionLabel:_kuaidiModel.shouhou withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-30, 500) withTextFont:12.0f];
            return 180+rect1.size.height+rect2.size.height+rect3.size.height+rect4.size.height+rect5.size.height>280?180+rect1.size.height+rect2.size.height+rect3.size.height+rect4.size.height+rect5.size.height:280;
        }else{
            CGRect rect1 = [self.view contentAdaptionLabel:self.model.unuse_time_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            CGRect rect2 = [self.view contentAdaptionLabel:self.model.use_time_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            CGRect rect3 = [self.view contentAdaptionLabel:self.model.use_rule_desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
            return 120+rect1.size.height+rect2.size.height+rect3.size.height>160?120+rect1.size.height+rect2.size.height+rect3.size.height:160;
        }
    }else {
        if (indexPath.row == 0) {
            return 30;
        }else {
            float heightCell = 0.0f;
            for (int i=0; i<self.picturesArr.count; i++) {
                PictureTextDetailModel *model = [self.picturesArr objectAtIndex:i];
                CGRect rect = [self.view contentAdaptionLabel:model.desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 1000) withTextFont:12.0f];
                
                heightCell = heightCell+rect.size.height+10+WIDTH_CONTROLLER_DEFAULT-5;
            }
            return heightCell;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.flagStr intValue] == 0) {
            BuyNeedKnowCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
            myCell.model = self.goodModel;
            myCell.kuaidiModel = self.kuaidiModel;
            return myCell;
        }else {
            CouponBuyNeedKownCell *mCell = [tableView dequeueReusableCellWithIdentifier:swbCell];
            mCell.model = self.model;
            return mCell;
        }
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *cell1 = @"cell111";
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
                UILabel *lb = [self.view creatLabelWithFrame:CGRectMake(10, 0, 150, 30) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:@"产品介绍" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
                [myCell.contentView addSubview:lb];
            }
            return myCell;
        }
        else {
            static NSString *cell2 = @"cell222";
            UITableViewCell *mCell = [tableView dequeueReusableCellWithIdentifier:cell2];
            if (!mCell) {
                mCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
            }
            for (int i=0; i<self.picturesArr.count; i++) {
                UILabel *descLb = (UILabel *)[mCell.contentView viewWithTag:50*i+5];
                if (!descLb) {
                    descLb = [[UILabel alloc]init];
                    descLb.tag = 50*i+5;
                    descLb.font = [UIFont systemFontOfSize:12.0f];
                    [mCell.contentView addSubview:descLb];
                }
                UIImageView *imgView = (UIImageView *)[mCell.contentView viewWithTag:50*i+10];
                if (!imgView) {
                    imgView = [[UIImageView alloc]init];
                    imgView.tag = 50*i+10;
                    [mCell.contentView addSubview:imgView];
                }
                PictureTextDetailModel *model = [self.picturesArr objectAtIndex:i];
                CGRect rect1 = [self.view contentAdaptionLabel:model.desc withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-20, 1000) withTextFont:12.0f];
                
                UIImageView *previousImgView = (UIImageView *)[mCell.contentView viewWithTag:50*(i-1)+10];
                descLb.numberOfLines = 0;
                descLb.frame = CGRectMake(10, 5+CGRectGetMaxY(previousImgView.frame), WIDTH_CONTROLLER_DEFAULT-20, rect1.size.height+10);
                descLb.text = model.desc;
                descLb.tag = 50*i+5;
                
                imgView.frame = CGRectMake(10, CGRectGetMaxY(descLb.frame)+5, WIDTH_CONTROLLER_DEFAULT-20, WIDTH_CONTROLLER_DEFAULT-20);
                [imgView setImageWithURL:[commonTools getImgURL:model.imgUrl] placeholderImage:PlaceholderImage];
                imgView.tag = 50*i+10;
                
            }
            return mCell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > _oldOffSet) {
        [self setScrollBtnHidden:NO];
    }else
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
