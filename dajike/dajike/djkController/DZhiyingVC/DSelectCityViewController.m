//
//  SelectCityViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/16.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DSelectCityViewController.h"
//#import "defines.h"
#import "UIView+MyView.h"

#import "BATableView.h"
#import "DQuyuModel.h"
#import "MyChineseBookAddress.h"
#import "DFileOperation.h"

#import "dDefine.h"


@interface DSelectCityViewController ()<BATableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *suoyinCityList;
    UILabel *cityLabel;
    //热门城市
    NSArray *hostCity;
    UISearchBar *_searchBar;
    //搜索城市结果
    NSMutableArray *searchCitys;
}

@property (retain, nonatomic)UILabel *flotageLabel;
@property (nonatomic, strong) BATableView *contactTableView;

@end

@implementation DSelectCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self addTableView:UITableViewStyleGrouped];
    [self setNaviBarTitle:@"选择城市"];
    [self addData];
    
    
    [self addSearchBarAndLayoutTableview];
    if (self.isNOSelectCity) {
        [self navigationCanDragBack:NO];
        [self setNaviBarLeftBtn:nil];
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [FileOperation writeSelectIndex:0];
}

- (void) addSearchBarAndLayoutTableview
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 5+64, DWIDTH_CONTROLLER_DEFAULT-20-10, 30)];
    //    searchBar.backgroundColor = Color_White;
    _searchBar.barTintColor = DColor_White;
    _searchBar.layer.borderColor = [DColor_cccccc CGColor];
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 64+40, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64-40)];
    self.contactTableView.delegate = self;
    [self.view addSubview:self.contactTableView];
    
    
    self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.view.bounds.size.width - 64 ) / 2,(self.view.bounds.size.height - 64) / 2,64,64}];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
    [self.flotageLabel setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addData
{
    dataArray = [[NSMutableArray alloc]init];
    suoyinCityList = [[NSMutableArray alloc]init];
//    [suoyinCityList addObject:@"定位"];
    [suoyinCityList insertObject:@"最近" atIndex:0];
    [suoyinCityList insertObject:@"热门" atIndex:1];
    //    [suoyinCityList insertObject:@"全部" atIndex:3];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从plist文件中获取所有城市列表
        NSArray *citysArr = [DFileOperation getAllCityPlaces];
        //添加完首字母的城市列表
        NSMutableArray *resultCityArr = [[NSMutableArray alloc]init];
        for (NSDictionary *cityDic in citysArr) {
            NSString *nameString = [cityDic objectForKey:@"name"];
            if (nameString == nil) {
                nameString = @"";
            }
            
            NSString *pinYin;
            if (![nameString isEqualToString:@""]) {
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<1;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([nameString characterAtIndex:j])]uppercaseString];
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                pinYin=pinYinResult;
            }else{
                //                                     chineseString.pinYin=@"";
                pinYin = @"";
            }
            //一个城市的字典
            NSMutableDictionary *cityDictionary = [NSMutableDictionary dictionaryWithDictionary:cityDic];
            //添加拼音首字母元素
            [cityDictionary setObject:pinYin forKey:@"pinYin"];
            if ([[nameString substringToIndex:2]isEqualToString:@"重庆"]) { //多音字
                [cityDictionary setObject:@"C" forKey:@"pinYin"];
            }
            if ([[nameString substringToIndex:2]isEqualToString:@"厦门"]) { //多音字
                [cityDictionary setObject:@"X" forKey:@"pinYin"];
            }
            if ([[nameString substringToIndex:2]isEqualToString:@"长沙"]) { //多音字
                [cityDictionary setObject:@"C" forKey:@"pinYin"];
            }
            
            NSMutableString *ms = [[NSMutableString alloc] initWithString:nameString];
            CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
            NSString * ms1 = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([ms1 isEqualToString:@"zhongqing"]) {
                ms1 = @"chongqing";
            }
            if ([ms1 isEqualToString:@"zhangsha"]) {
                ms1 = @"changsha";
            }
            if ([ms1 isEqualToString:@"shamen"]) {
                ms1 = @"xiamen";
            }
            [cityDictionary setObject:ms1 forKey:@"pinyinName"];
            
            //字典转model
            DQuyuModel *model = [[DQuyuModel alloc]init];
            model = [JsonStringTransfer dictionary:cityDictionary ToModel:model];
            //添加到城市列表
            [resultCityArr addObject:model];
        }
        
//        for (NSDictionary *cityDic in citysArr) {
//            if (([[cityDic objectForKey:@"parentId"] integerValue] >= 2)&&([[cityDic objectForKey:@"parentId"] integerValue] <= 35)) {
//                
//                NSString *nameString = [cityDic objectForKey:@"regionName"];
//                if (nameString == nil) {
//                    nameString = @"";
//                }
//                
//                NSString *pinYin;
//                if (![nameString isEqualToString:@""]) {
//                    NSString *pinYinResult=[NSString string];
//                    for(int j=0;j<1;j++){
//                        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([nameString characterAtIndex:j])]uppercaseString];
//                        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
//                    }
//                    pinYin=pinYinResult;
//                }else{
//                    //                                     chineseString.pinYin=@"";
//                    pinYin = @"";
//                }
//                //一个城市的字典
//                NSMutableDictionary *cityDictionary = [NSMutableDictionary dictionaryWithDictionary:cityDic];
//                //添加拼音首字母元素
//                if ([[nameString substringToIndex:2]isEqualToString:@"重庆"]) { //多音字
//                    [cityDictionary setObject:@"C" forKey:@"pinYin"];
//                }else{
//                    [cityDictionary setObject:pinYin forKey:@"pinYin"];
//                }
//                //字典转model
//                CityModel *model = [[CityModel alloc]init];
//                model = [JsonStringTransfer dictionary:cityDictionary ToModel:model];
//                //添加到城市列表
//                [resultCityArr addObject:model];
//            }
//        }
        
        
        
        for(char c ='A';c<='Z';c++)
            
        {
            
            //当前字母
            
            NSString *zimu=[NSString stringWithFormat:@"%c",c];
            
            //每个字母对应的城市放在一个数组里
            NSMutableArray *ZIMUArr = [[NSMutableArray alloc]init];
            
            for (DQuyuModel *model0 in resultCityArr) {
                if ([model0.pinYin isEqualToString:zimu]) {
                    [ZIMUArr addObject:model0];
                }
            }
            
            if (ZIMUArr.count > 0) {
                [suoyinCityList addObject:[NSString stringWithFormat:@"%c",c]];
                [dataArray addObject:ZIMUArr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contactTableView reloadData];
        });
        
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取热门城市
        [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"QyZhiYings.hotRegion" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);
                hostCity = [NSArray arrayWithArray:responseObject.result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contactTableView reloadData];
                });
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    });
}

#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        return 0.5;
    }
    if (section == 0) {
        return 30.0;
    }
    return 30;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        return searchCitys.count;
    }
    if ( section == 0||section == 1) {
        return 1;
    }else{
        if (dataArray.count > 0) {
            return ((NSArray *)[dataArray objectAtIndex:section-2]).count;
        }
        return 0;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        return 30.0;
    }
//    if (indexPath.section == 0) {
//        return 31.0;
//    }else
    if (indexPath.section == 0){
        return 31.0;
    }else if (indexPath.section == 1){
        return ((hostCity.count/4 + (hostCity.count%4 == 0?0:1))*32.0);
    }else{
        return 30.0;
    }
    
    return 0.0;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        static NSString *identifer = @"searchCell";
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil == cell3) {
            cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        }

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, DWIDTH_CONTROLLER_DEFAULT, 1)];
        line.backgroundColor = DColor_cccccc;
        [cell3 addSubview:line];
        [cell3.textLabel setFont:DFont_12];
        [cell3.textLabel setTextColor:DColor_808080];
        cell3.textLabel.text = [[searchCitys objectAtIndex:indexPath.row] objectForKey:@"name"];
        return cell3;
    }
//    if (section == 0) {
//        UITableViewCell *cell0 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
//        cell0.backgroundColor = DColor_f7f7f7;
////        cell0.contentView.backgroundColor = [UIColor clearColor];
//        
//        
//        cityLabel = [[UILabel alloc]creatLabelWithFrame:CGRectMake(15, 0, DWIDTH_CONTROLLER_DEFAULT-50, 30) AndFont:11 AndBackgroundColor:DColor_White AndText:[NSString stringWithFormat:@" 定位城市：%@",[FileOperation getDingweiCityName]] AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_808080 andCornerRadius:2.0];
//        cityLabel.layer.borderColor = [DColor_cccccc CGColor];
//        cityLabel.layer.borderWidth = 1.0;
//        [cell0 addSubview:cityLabel];
//        
//        return cell0;
//    }else
    if(section == 0)
    {
        UITableViewCell *cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        cell1.backgroundColor = DColor_f7f7f7;
//        cell1.contentView.backgroundColor = DColor_f3f3f3;
        
        NSArray *recentlyCitys = [DFileOperation getRecentlyZhiyingCitys];
        if (recentlyCitys.count > 1) {
            for (int i = 0; i < recentlyCitys.count-1; i++) {
                UIButton *btn = [[UIButton alloc] createButtonWithFrame:CGRectMake(15+(i%3)*70, 0, 70.5, 30) andBackImageName:nil andTarget:self andAction:@selector(cell1ButtonClip:) andTitle:[[recentlyCitys objectAtIndex:i+1]objectForKey:@"name"] andTag:i+100];
                btn.backgroundColor = DColor_White;
                btn.layer.borderColor = [DColor_cccccc CGColor];
                btn.layer.borderWidth = 0.5;
                [btn.titleLabel setFont:DFont_11];
                [btn setTitleColor:DColor_808080 forState:UIControlStateNormal];
                [cell1 addSubview:btn];
            }

        }
        
        return cell1;
    }
    else if(section == 1)
    {
        UITableViewCell *cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
        cell2.backgroundColor = DColor_f7f7f7;
        
        if (hostCity.count > 0) {
            for (int i = 0; i < hostCity.count; i++) {
                UIButton *btn = [[UIButton alloc] createButtonWithFrame:CGRectMake(15+(i%4)*69, (i/4)*30, 69.5, 30.5) andBackImageName:nil andTarget:self andAction:@selector(cell2ButtonClip:) andTitle:[[hostCity objectAtIndex:i]objectForKey:@"region_name"] andTag:i+100];
                btn.backgroundColor = DColor_White;
                btn.layer.borderColor = [DColor_cccccc CGColor];
                btn.layer.borderWidth = 0.5;
                [btn setTitleColor:DColor_808080 forState:UIControlStateNormal];
                [cell2 addSubview:btn];
            }
        }
        
        
        
        return cell2;
    }else{
        static NSString *identifer = @"cell3";
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil == cell3) {
            cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, DWIDTH_CONTROLLER_DEFAULT, 0.5)];
        line.backgroundColor = DColor_cccccc;
        [cell3 addSubview:line];
        if (dataArray.count > 0) {
            [cell3.textLabel setFont:DFont_12];
            [cell3.textLabel setTextColor:DColor_808080];
            cell3.textLabel.text = ((DQuyuModel *)[[dataArray objectAtIndex:section-2] objectAtIndex:indexPath.row]).name;
        }
        
        return cell3;
    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        //写进第一项中去
//        [FileOperation writeCurrentCityWithCityName:[[searchCitys objectAtIndex:indexPath.row] objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[[searchCitys objectAtIndex:indexPath.row] objectForKey:@"regionId"]]];
//        if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[searchCitys objectAtIndex:indexPath.row] objectForKey:@"regionId"]]].count > 0) {
//            [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[searchCitys objectAtIndex:indexPath.row] objectForKey:@"regionId"]]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//        }
//        
//        //返回
//        [self.navigationController popViewControllerAnimated:YES];
        
//        DQuyuModel *model = (DQuyuModel *)[searchCitys objectAtIndex:row];
//        NSDictionary *dic = [JsonStringTransfer modelToDictionary:model];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[searchCitys objectAtIndex:row]];
        [DFileOperation writeCurrentCityWithCityDic:dic];
        
        
        
//        //写进第一项中去
//        [FileOperation writeCurrentCityWithCityName:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] andCityId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] ];
//        if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]].count > 0) {
//            [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] ] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//        }
        
        //返回
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
//    if (section == 0) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //获取定位城市
//        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Regions.locationCity" parameters:@{@"latitude":@"",@"longitude":@""} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if (responseObject.succeed) {
//                NSLog(@"responseObject.result = %@",[responseObject.result objectForKey:@"regionName"]);
//                NSMutableArray *citysArr = [[NSMutableArray alloc]init];
//                NSDictionary *cityDic = @{@"regionName":@"全城",@"regionId":[responseObject.result objectForKey:@"regionId"]};
//                [citysArr addObject:cityDic];
//                for (NSArray *arr in [responseObject.result objectForKey:@"subRegions"]) {
//                    NSDictionary *dic = @{@"regionName":[arr objectAtIndex:1],@"regionId":[arr objectAtIndex:0]};
//                    [citysArr addObject:dic];
//                }
//                
//                [FileOperation setPlistObject:citysArr forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//                //存储定位城市信息
//                [FileOperation writeDingweiCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];
//                //写进最近城市列表
//                [FileOperation writeCurrentCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];
//                //返回
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                //定位失败，获取上次选择城市id
//                [ProgressHUD showMessage:@"定位失败。" Width:280 High:10];
//                
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error = %@",error);
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            //定位失败，显示以前定位城市
//            [ProgressHUD showMessage:@"定位失败。" Width:280 High:10];
//        }];
//        
//    }
    if (section >= 2) {
        DQuyuModel *model = (DQuyuModel *)[[dataArray objectAtIndex:section-2] objectAtIndex:row];
        NSDictionary *dic = [JsonStringTransfer modelToDictionary:model];
        [DFileOperation writeCurrentCityWithCityDic:dic];
        
        
        
//        //写进第一项中去
//        [FileOperation writeCurrentCityWithCityName:((DQuyuModel *)[[dataArray objectAtIndex:section-3] objectAtIndex:row]).name andCityId:[NSString stringWithFormat:@"%@",((DQuyuModel *)[[dataArray objectAtIndex:section-3] objectAtIndex:row]).id]];
//        if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",((DQuyuModel *)[[dataArray objectAtIndex:section-3] objectAtIndex:row]).id]].count > 0) {
//            [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",((DQuyuModel *)[[dataArray objectAtIndex:section-3] objectAtIndex:row]).id]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//        }
        
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSArray *arr = @[
//                     @"nihao1",
//                     @"2",
//                     @"3",
//                     @"4",
//                     @"5",
//                     @"6",
//                     @"7",
//                     @"8",
//
//                     ];
//        return suoyinCityList;
//}
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        return nil;
    }
    
    
    return suoyinCityList;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        return 1;
    }
    return suoyinCityList.count;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //城市搜索
//    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
//        return @"";
//    }
//    if (section == 0) {
//        return @"";
//    }else if(section == 1){
//        return @"最近访问";
//    }else if(section == 2){
//        return @"热门城市";
//    }else{
//        return [suoyinCityList objectAtIndex:section];
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 30)];
    [v setBackgroundColor:DColor_f7f7f7];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DWIDTH_CONTROLLER_DEFAULT-10, 30)];
    [label setFont:DFont_12];
    [label setTextColor:DColor_808080];
    label.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    //城市搜索
    if ((searchCitys !=nil)&&(searchCitys.count > 0)) {
        label.text = @"";
    }
//    if (section == 0) {
//        label.text =@"";
//    }else
    if(section == 0){
        label.text = @"最近访问";
    }else if(section == 1){
        label.text = @"热门城市";
    }else{
        label.text = [NSString stringWithString:[suoyinCityList objectAtIndex:section]];
    }
    return v;
}

//- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    NSLog(@"===%@  ===%d",title,index);
//
//    [self.flotageLabel setHidden:NO];
//    self.flotageLabel.text = title;
//
//     [self performSelector:@selector(hiddenflotageLabel) withObject:nil afterDelay:1.5f];
//
//
//    //点击索引，列表跳转到对应索引的行
//
//    [tableView
//     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
//     atScrollPosition:UITableViewScrollPositionTop animated:YES];
//
//
//
//    //弹出首字母提示
//
//    //[self showLetter:title ];
//
//    return 0;
////    return 8;
//}




#pragma mark------
#pragma mark------loadTableView--------


//最近访问
- (void) cell1ButtonClip:(id) sender
{
    //100+
    UIButton *btn = (UIButton *)sender;
    NSInteger selectRow = btn.tag - 100;
    //获取最近访问城市的信息
    NSArray *cityArrs = [DFileOperation getRecentlyZhiyingCitys];
    //最近城市  为记录中的后三项纪录,不包括第一项
    NSDictionary *dic = [cityArrs objectAtIndex:selectRow+1];
    //写进第一项中去
    [DFileOperation writeCurrentCityWithCityDic:dic];
    
    
    
//    [FileOperation writeCurrentCityWithCityName:[dic objectForKey:@"regionName"] andCityId:[dic objectForKey:@"regionId"]];
//    if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"regionId"]]].count > 0) {
//        [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"regionId"]]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//    }
    //返回
    [self.navigationController popViewControllerAnimated:YES];
    
}
//热门城市
- (void) cell2ButtonClip:(id) sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 100;
    
//    @property (strong, nonatomic) NSString *id;
//    @property (strong, nonatomic) NSString *name;
//    @property (strong, nonatomic) NSString *pname;
//    @property (strong, nonatomic) NSString *pid;
//    @property (strong, nonatomic) NSString *pinYin;
//    @property (strong, nonatomic) NSString *pinyinName;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[hostCity objectAtIndex:index]objectForKey:@"region_name"],@"name",[[hostCity objectAtIndex:index]objectForKey:@"region_id"],@"id",@"全城",@"pname",@"pid",@"0" ,nil];
    [DFileOperation writeCurrentCityWithCityDic:dic];
    
    
    
    //写进第一项中去
//    [FileOperation writeCurrentCityWithCityName:[[hostCity objectAtIndex:index]objectForKey:@"region_name"]andCityId:[NSString stringWithFormat:@"%@",[[hostCity objectAtIndex:index]objectForKey:@"region_id"]]];
//    if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[hostCity objectAtIndex:index]objectForKey:@"region_id"]]].count > 0) {
//        [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[hostCity objectAtIndex:index]objectForKey:@"region_id"]]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//    }

    //返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

//掩藏
- (void) hiddenflotageLabel
{
    [self.flotageLabel setHidden:YES];
}

#pragma mark------
#pragma mark------scrollView delegate--------
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar endEditing:YES];
}
#pragma mark------
#pragma mark------UISearchBarDelegate--------
//搜索城市
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.contactTableView reloadData];
    [_searchBar endEditing:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchCitys != nil) {
        [searchCitys removeAllObjects];
        searchCitys = nil;
    }
    searchCitys = [[NSMutableArray alloc]init];
    
    if ([searchText isEqualToString:@""]) {
        [self.contactTableView reloadData];
        return;
    }
    
    NSArray *allPlaceArr1 = [DFileOperation getAllCityPlaces];
    for (NSDictionary *cityDic in allPlaceArr1) {
        NSString *chinseName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"name"]];
        
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:chinseName];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        NSString *pinyinName = [NSString stringWithFormat:@"%@",[ms stringByReplacingOccurrencesOfString:@" " withString:@""]];
        if ([pinyinName isEqualToString:@"zhongqing"]) {
            pinyinName = @"chongqing";
        }
        if ([pinyinName isEqualToString:@"zhangsha"]) {
            pinyinName = @"changsha";
        }
        if ([pinyinName isEqualToString:@"shamen"]) {
            pinyinName = @"xiamen";
        }
        NSRange chineseRange = [chinseName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange  pinyinRange = [pinyinName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (chineseRange.location != NSNotFound) {
            NSLog(@"chinse %lu",(unsigned long)chineseRange.location);
            //从首字母开始 如果首个就不匹配，则排除
            if (chineseRange.location == 0) {
                [searchCitys addObject:cityDic];
            }
        }else if (pinyinRange.location != NSNotFound){
            //从首字母开始 如果首个就不匹配，则排除
            if (pinyinRange.location == 0) {
                [searchCitys addObject:cityDic];
            }
        }

        [self.contactTableView reloadData];
    }

    
//    if ([FileOperation getAllPlaces].count > 0) {
//        NSArray *allPlaceArr0 = [NSArray arrayWithArray:[FileOperation getAllPlaces]];
//        for (NSDictionary *cityDic in allPlaceArr0) {
//            if (([[cityDic objectForKey:@"parentId"] integerValue] >= 2)&&([[cityDic objectForKey:@"parentId"] integerValue] <= 35)) {
//                NSString *chinseName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"regionName"]];
//                NSString *pinyinName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"pingyinName"]];
//                NSRange chineseRange = [chinseName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//                NSRange  pinyinRange = [pinyinName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//                if (chineseRange.location != NSNotFound) {
//                    NSLog(@"chinse %lu",(unsigned long)chineseRange.location);
//                    //从首字母开始 如果首个就不匹配，则排除
//                    if (chineseRange.location == 0) {
//                        [searchCitys addObject:cityDic];
//                    }
//                }else if (pinyinRange.location != NSNotFound){
//                    //从首字母开始 如果首个就不匹配，则排除
//                    if (pinyinRange.location == 0) {
//                        [searchCitys addObject:cityDic];
//                    }
//                }
//            }
//        }
//        [self.contactTableView reloadData];
//    }else{
//        [FileOperation getAllPlaces:^(BOOL finish) {
//            NSArray *allPlaceArr1 = [NSArray arrayWithArray:[FileOperation getAllPlaces]];
//            for (NSDictionary *cityDic in allPlaceArr1) {
//                if (([[cityDic objectForKey:@"parentId"] integerValue] >= 2)&&([[cityDic objectForKey:@"parentId"] integerValue] <= 35)) {
//                    NSString *chinseName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"regionName"]];
//                    NSString *pinyinName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"pingyinName"]];
//                    NSRange chineseRange = [chinseName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//                    NSRange  pinyinRange = [pinyinName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//                    if (chineseRange.location != NSNotFound) {
//                        //从首字母开始 如果首个就不匹配，则排除
//                        if (chineseRange.location == 0) {
//                            [searchCitys addObject:cityDic];
//                        }
//                    }else if (pinyinRange.location != NSNotFound){
//                        //从首字母开始 如果首个就不匹配，则排除
//                        if (pinyinRange.location == 0) {
//                            [searchCitys addObject:cityDic];
//                        }
//                    }
//                }
//            }
//            [self.contactTableView reloadData];
//        }];
//    }
    
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
