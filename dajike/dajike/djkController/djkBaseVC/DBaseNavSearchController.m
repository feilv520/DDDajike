//
//  DBaseNavSearchController.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseNavSearchController.h"
#import "DBaseViewController.h"
#import "DBaseNavView.h"
#import "dDefine.h"

#define RECT_NaviBar                            DRect(0.0f, StatusBarHeight, 320.0f, 44)
#define RECT_SearchBarFrame                     DRect(0.0f, 0.0f, [DBaseNavView rightBtnFrame].origin.x-2.0f, 44)
#define RECT_CancelBtnFrame                     DRect([DBaseNavView rightBtnFrame].origin.x, 0.0f, [DBaseNavView rightBtnFrame].size.width, 44)

@interface DBaseNavSearchController()
<
    UISearchBarDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, readonly, weak) DBaseViewController *m_viewCtrlParent;
@property (nonatomic, readonly) UIView *m_viewNaviBar;
@property (nonatomic, readonly) UISearchBar *m_searchBar;
@property (nonatomic, readonly) UIImageView *m_viewBlackCover;
@property (nonatomic, readonly) UIButton *m_btnCancel;
@property (nonatomic, readonly) UITableView *m_tableView;

@property (nonatomic, readonly) BOOL m_bIsFixation;
@property (nonatomic, readonly) BOOL m_bIsCoverTitleView;
@property (nonatomic, readonly) BOOL m_bIsWorking;
@property (nonatomic, readonly) NSArray *m_arrRecent;

@property (nonatomic, readonly) UIImage *m_imgBlurBg;

@end

@implementation DBaseNavSearchController
@synthesize delegate;
@synthesize m_viewNaviBar = _viewNaviBar;
@synthesize m_viewCtrlParent = _viewCtrlParent;
@synthesize m_searchBar = _searchBar;
@synthesize m_viewBlackCover = _viewBlackCover;
@synthesize m_btnCancel = _btnCancel;
@synthesize m_tableView = _tableView;
@synthesize m_bIsFixation = _bIsFixation;
@synthesize m_bIsWorking = _bIsWorking;
@synthesize m_arrRecent = _arrRecent;
@synthesize m_bIsCoverTitleView = _bIsCoverTitleView;
@synthesize m_imgBlurBg = _imgBlurBg;

- (id)initWithParentViewCtrl:(DBaseViewController *)viewCtrl
{
    self = [super init];
    if (self)
    {
        APP_ASSERT(viewCtrl);
        _viewCtrlParent = viewCtrl;
        
        [self initUI];
        
    }else{}
    return self;
}

- (void)initUI
{
    APP_ASSERT(_viewCtrlParent);
    _viewNaviBar = [[UIView alloc] initWithFrame:RECT_NaviBar];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 44)];
    _searchBar.placeholder = @"请输入";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [UIImage imageNamed:@"Transparent"];
    _searchBar.delegate = self;
    
    _btnCancel = [DBaseNavView createNavBtnWithTitle:@"取消" target:self action:@selector(btnCancel:)];
    _btnCancel.frame = RECT_CancelBtnFrame;
    [_btnCancel setTitleColor:DColor_mainRed forState:UIControlStateNormal];
    _btnCancel.hidden = YES;
    
    [_viewNaviBar addSubview:_searchBar];
    [_viewNaviBar addSubview:_btnCancel];
    
    _viewBlackCover = [[UIImageView alloc] initWithFrame:_viewCtrlParent.view.bounds];
    _viewBlackCover.backgroundColor = [UIColor clearColor];
    _viewBlackCover.userInteractionEnabled = YES;
    _viewBlackCover.backgroundColor = DRGBA(0.0f, 0.0f, 0.0f, 0.8f);
    
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToClose:)];
    [_viewBlackCover addGestureRecognizer:tapToClose];
}

- (void)resetPlaceHolder:(NSString *)strMsg
{
    _searchBar.placeholder = strMsg;
}

- (void)showTempSearchCtrl
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    _bIsFixation = NO;
    _bIsCoverTitleView = NO;
    
    [self startSearch];
}

- (void)showFixationSearchCtrl
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    
    _bIsFixation = YES;
    _bIsCoverTitleView = NO;
}

- (void)showFixationSearchCtrlOnTitleView
{
    _viewNaviBar.frame = [DBaseNavView titleViewFrame];
    _searchBar.frame = _viewNaviBar.bounds;
    [_viewCtrlParent naviBarAddCoverViewOnTitleView:_viewNaviBar];
    
    _bIsFixation = YES;
    _bIsCoverTitleView = YES;
}

- (void)startSearch
{
    [self startWorking];
}

- (void)removeSearchCtrl
{
    [self removeFromParent];
}

- (void)setRecentKeyword:(NSArray *)arrRecentKeyword
{
    if (arrRecentKeyword)
    {
        _arrRecent = [NSArray arrayWithArray:arrRecentKeyword];
    }
    else
    {
        _arrRecent = nil;
    }
    
    if (_tableView)
    {
        [_tableView reloadData];
    }else{}
}

- (void)setKeyword:(NSString *)strKeyword
{
    if (_searchBar)
    {
        [_searchBar setText:strKeyword];
    }else{}
}

#pragma mark -
- (void)startWorking
{
    _btnCancel.hidden = NO;
    if (_bIsCoverTitleView)
    {
        _viewNaviBar.frame = RECT_NaviBar;
        _searchBar.frame = RECT_SearchBarFrame;
    }
    else
    {
        _searchBar.frame = RECT_SearchBarFrame;
    }
    
    _viewBlackCover.alpha = 0.0f;
    [_viewCtrlParent.view addSubview:_viewBlackCover];
    [UIView animateWithDuration:0.4f animations:^()
     {
         _viewBlackCover.alpha = 1.0f;
     }completion:^(BOOL f){}];
    
    if (![_searchBar isFirstResponder])
    {
        [_searchBar becomeFirstResponder];
    }else{}
    
    [self showRecentTable:YES];
    
    [_viewCtrlParent bringNaviBarToTopmost];
    
    _bIsWorking = YES;
}

- (void)endWorking
{
    _btnCancel.hidden = YES;
    if (_bIsCoverTitleView)
    {
        _viewNaviBar.frame = [DBaseNavView titleViewFrame];
        _searchBar.frame = _viewNaviBar.bounds;
    }
    else
    {
        _searchBar.frame = DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 44);
    }
    
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }else{}
    [_viewBlackCover removeFromSuperview];
    
    [self showRecentTable:NO];
    
    _bIsWorking = NO;
}

- (void)btnCancel:(id)sender
{
    _searchBar.text = @"";
    [self endWorking];
    
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlCancel:)])
    {
        [delegate naviBarSearchCtrlCancel:self];
    }else{}
}

- (void)removeFromParent
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }else{}
    
    [_viewCtrlParent naviBarRemoveCoverView:_viewNaviBar];
    [_viewBlackCover removeFromSuperview];
}

- (void)handleTapToClose:(UIGestureRecognizer *)gesture
{
    [self endWorking];
    
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlCancel:)])
    {
        [delegate naviBarSearchCtrlCancel:self];
    }else{}
}

- (void)showRecentTable:(BOOL)bIsShow
{
    if (bIsShow && _arrRecent && (_arrRecent.count > 0))
    {
        if (!_tableView)
        {
            _tableView = [[UITableView alloc] initWithFrame:_viewCtrlParent.view.bounds style:UITableViewStylePlain];
            [_viewCtrlParent.view addSubview:_tableView];
            [UtilityFunc resetScrlView:_tableView contentInsetWithNaviBar:YES tabBar:NO];
            
            UIView *footer = [[UIView alloc] initWithFrame:DRect(0.0f, 0.0f, DWIDTH_CONTROLLER_DEFAULT, 50.0f)];
            footer.backgroundColor = [UIColor clearColor];
            _tableView.tableFooterView = footer;
            UIButton *btnClearSearchRecord = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClearSearchRecord.frame = DRect(0.0f, 20.0f, footer.frame.size.width, 50.0f);
            [btnClearSearchRecord setTitle:@"清除搜索记录" forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:DColor_Black forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:DColor_mainRed forState:UIControlStateHighlighted];
            [btnClearSearchRecord addTarget:self action:@selector(btnClearSearchRecord:) forControlEvents:UIControlEventTouchUpInside];
            [footer addSubview:btnClearSearchRecord];
            
            _tableView.backgroundColor = DRGBA(235.0f, 235.0f, 235.0f, 1.0f);
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
        }else{}
        _tableView.hidden = NO;
        
        _tableView.frame = DRect(_tableView.frame.origin.x, _tableView.frame.origin.y+_tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height);
        [UIView animateWithDuration:0.3f animations:^()
         {
             _tableView.frame = _viewCtrlParent.view.bounds;
         }];
    }
    else
    {
        if (_tableView)
        {
            [_tableView removeFromSuperview];
            _tableView = nil;
        }else{}
    }
}

- (void)btnClearSearchRecord:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlClearKeywordRecord:)])
    {
        [delegate naviBarSearchCtrlClearKeywordRecord:self];
    }else{APP_ASSERT_STOP}
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text)
    {
        NSString *strKeyword = [[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
        if (strKeyword.length > 0)
        {
            searchBar.text = @"";
            [self endWorking];
            
            if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrl:searchKeyword:)])
            {
                [delegate naviBarSearchCtrl:self searchKeyword:strKeyword];
            }else{}
        }
        else
        {
            searchBar.text = @"";
        }
    }else{APP_ASSERT_STOP}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self startSearch];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iCount = _arrRecent ? _arrRecent.count : 0;
    
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTypeCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = DColor_Black;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *strKeyword = _arrRecent[indexPath.row];
    cell.textLabel.text = strKeyword;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strKeyword = _arrRecent[indexPath.row];
    [_searchBar setText:strKeyword];
}

@end
