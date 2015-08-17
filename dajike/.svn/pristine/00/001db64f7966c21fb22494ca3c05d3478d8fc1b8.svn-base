//
//  EnvironmentViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 类 ： 商家详情.环境
 */

#import "EnvironmentViewController.h"
#import "GMGridView.h"
#import "EnvironmentCell.h"
#import "defines.h"
#import "SDPhotoBrowser.h"
#import "UIView+MyView.h"
#import "EnvironmentCollectionCell.h"
#import "MJRefresh.h"
#import "PhotoAlbumModel.h"

static NSString *swbCell = @"EnvironmentCollectionCell";

#define itemSpacing  ((WIDTH_CONTROLLER_DEFAULT-270-1)/3)
//GMGridViewDataSource,GMGridViewTransformationDelegate,GMGridViewActionDelegate,GMGridViewSortingDelegate,
@interface EnvironmentViewController ()<SDPhotoBrowserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    //网格视图
    UICollectionView    *_collectionView;
//    GMGridView      *_mTableView;
    NSIndexPath         *_selectedIndex;
    
    int     _page;
}

@property (nonatomic, strong) NSMutableArray *imgArr;

@end

@implementation EnvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _selectedIndex = 0;
    _page = 0;
    _imgArr = [[NSMutableArray alloc]init];
    
//    _srcStringArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg"];
    
//    [self GMGridViewSet];
    
    [self createCollectionView];
    
    [self getData];
}
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(135, 150);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64) collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:@"EnvironmentCollectionCell" bundle:nil] forCellWithReuseIdentifier:swbCell];
    _collectionView.backgroundColor = Color_bg;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    [self.view addSubview:_collectionView];
    
    
}

- (void)getData
{
    NSDictionary *parameter = @{@"storeId":self.stroeId,@"page":@"1",@"pageSize":@"100"};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.photoList" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"] mutableCopy];
            
            for (int i=0; i<tmpArr.count; i++) {
                PhotoAlbumModel *model = [[PhotoAlbumModel alloc]init];
                model = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:model];
                [tmpArr replaceObjectAtIndex:i withObject:model];
            }
            [_imgArr addObjectsFromArray:tmpArr];
            
            [_collectionView reloadData];
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



//- (void)GMGridViewSet
//{
//    _mTableView                     = [[GMGridView alloc]init];
//    _mTableView.frame               = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-95);
//    float spacing                     = 16;
//    _mTableView.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
//    _mTableView.backgroundColor     = Color_bg;
//    
//    [self.view addSubview:_mTableView];
//    
//    _mTableView.style               = GMGridViewStyleSwap;
//    _mTableView.itemSpacing         = spacing;
//    _mTableView.minEdgeInsets       = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
//    _mTableView.centerGrid          = NO;
//    _mTableView.actionDelegate      = self;
//    _mTableView.dataSource          = self;
//    _mTableView.contentSize         = CGSizeMake(0, 0);
//    NSLog(@"---%f,---%@",WIDTH_CONTROLLER_DEFAULT,NSStringFromCGRect(_mTableView.frame));
//}
/*
//--------------------------------------------------------------
//----------------GridView---------Start---------------
//---------------------------------------------------------------
#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return 18;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(135  , 150);
}


- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    
    static NSString * cellIdentifier = @"identifier";
    
    EnvironmentCell *mCell = (EnvironmentCell *)[gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *iv = nil;
    UILabel *lb = nil;
    if (!mCell) {
        mCell = (EnvironmentCell *)[[EnvironmentCell alloc]initWithFrame:CGRectMake(0, 0, 135, 150)];
        iv = [self.view createImageViewWithFrame:CGRectMake(15, 8, 105, 105) andImageName:@"ico"];
        [mCell addSubview:iv];
        lb = [self.view creatLabelWithFrame:CGRectMake(15, CGRectGetMaxY(iv.frame)+5, 105, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
        [mCell addSubview:lb];
    }
    
    NSURL *str = [NSURL URLWithString:[_srcStringArray objectAtIndex:index]];
    NSData *data = [NSData dataWithContentsOfURL:str];
    
    iv.image = [UIImage imageWithData:data];
    lb.text = @"7天连锁酒店";
    
    [mCell setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"%@",mCell.subviews);
    return mCell;
}

//
- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}


#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    
    NSLog(@"Did tap at index %ld", (long)position);
    
    EnvironmentCell *cell = (EnvironmentCell *)[gridView cellForItemAtIndex:position];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = cell; // 原图的父控件
    browser.imageCount = _srcStringArray.count; // 图片总数
    browser.currentImageIndex = (int)position;
    browser.delegate = self;
    [browser show];
    
    //    [self editPortrait];
    //    _itemClickedIndex = position;
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}


- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    
}


- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return cell.frame.size;
}
//--------------------------------------------------------------
//----------------GridView-----END-------------------
//---------------------------------------------------------------
*/

#pragma mark UICollectionView



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EnvironmentCollectionCell *mCell = (EnvironmentCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:swbCell forIndexPath:indexPath];
    
//    mCell.model = [_imgArr objectAtIndex:indexPath.row];
    PhotoAlbumModel *model = [_imgArr objectAtIndex:indexPath.row];
    
//    NSURL *str = [NSURL URLWithString:[_srcStringArray objectAtIndex:indexPath.row]];
//    NSData *data = [NSData dataWithContentsOfURL:str];
//    
    [mCell.imgView setImageWithURL:[commonTools getImgURL:model.file_path] placeholderImage:PlaceholderImage];
    mCell.nameLb.text = model.image_name;
    
    [mCell setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"%@",mCell.subviews);
    return mCell;
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Kcell forIndexPath:indexPath];
//    for (UIView *sub in cell.contentView.subviews) {
//        [sub removeFromSuperview];
//        
//    }
//    
//    
//    NSString *str = _srcStringArray[indexPath.item];
//    
//    UILabel *lael = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 180, 40)];
//    lael.text= str;
//    
//    cell.backgroundColor = [UIColor grayColor];
//    
//    [cell.contentView addSubview:lael];
//    
//    
//    return cell;
}


//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(itemSpacing, itemSpacing, itemSpacing, itemSpacing);
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(180, 180);
//}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return itemSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath;
    EnvironmentCell *cell = (EnvironmentCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = cell; // 原图的父控件
    browser.imageCount = _imgArr.count; // 图片总数
    browser.currentImageIndex = (int)indexPath.row;
    browser.imgArr = _imgArr;
    browser.delegate = self;
    [browser show];
}


#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    EnvironmentCollectionCell *cell = (EnvironmentCollectionCell *)[_collectionView cellForItemAtIndexPath:_selectedIndex];
    NSLog(@"%@",cell.contentView.subviews);
    return [cell.contentView.subviews[0] image];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    PhotoAlbumModel *model = [_imgArr objectAtIndex:index];
    NSString *urlStr = [model.file_path stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
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
