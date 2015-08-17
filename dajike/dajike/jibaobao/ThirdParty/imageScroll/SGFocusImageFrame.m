//
//  SGFocusImageFrame.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>
#import "defines.h"
//#import "UIImageView+AFNetworking.h"
#define ITEM_WIDTH self.frame.size.width

@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    //    GPSimplePageView *_pageControl;
    UIPageControl *_pageControl;
}

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto isAD:(BOOL)isAd
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        _isArticleAd = isAd;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES isAD:NO];
}



#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;

    //    _pageControl = [[GPSimplePageView alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5, self.bounds.size.height - size.height, size.width, size.height)];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height -17, 30, 17)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = Color_cheng1;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];

    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addImageViews:imageItems];
}

#pragma mark 添加视图
-(void)addImageViews:(NSArray *)aImageItems{
    //移除子视图
    for (UIView *lView in _scrollView.subviews) {
        [lView removeFromSuperview];
    }
    float space = 0;
    CGSize size = CGSizeMake(320, 0);
    for (int i = 0; i < aImageItems.count; i++) {
        SGFocusImageItem *item = [aImageItems objectAtIndex:i];
        item.tag = 200+i;
        if (self.isArticleAd == YES) {
            UIImageView *imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space+10, 7, ( _scrollView.frame.size.height-14)/1, ( _scrollView.frame.size.height-14)/1)];
            imageView0.contentMode = UIViewContentModeScaleToFill;
            //加载图片
            imageView0.backgroundColor = i%2?[UIColor clearColor]:[UIColor clearColor];
//            NSString * imgStr0 = [[NSMutableString stringWithString:item.image] substringToIndex:5] ;
//            if ([imgStr0 isEqualToString:@"http:"]) {
////                [imageView0 setImageWithURL:[NSURL URLWithString:item.image]];
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.image]];
//                imageView0.image = [UIImage imageWithData:data];
//            }else{
//                imageView0.image = [UIImage imageNamed:item.image];
//            }
            imageView0.image = [UIImage imageWithContentsOfFile:item.image];
//            imageView0.image = [UIImage imageNamed:item.image];
            imageView0.layer.cornerRadius = 5.0;
            imageView0.layer.masksToBounds
            = YES;
            imageView0.layer.borderWidth = 0.1;
            imageView0.layer.borderColor = [Color_cheng1 CGColor];
            imageView0.contentMode
            = UIViewContentModeScaleAspectFit;
//            imageView0.layer.shouldRasterize = YES;
//            imageView0.layer.rasterizationScale = imageView0.window.screen.scale;
            [_scrollView addSubview:imageView0];
            self.layer.borderColor = [Color_cheng1 CGColor];
            self.layer.borderWidth = 1.1;
            self.backgroundColor = Color_cheng1;
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            //加载图片
            imageView.backgroundColor = i%2?[UIColor grayColor]:[UIColor grayColor];
//            NSString * imgStr = [[NSMutableString stringWithString:item.image] substringToIndex:5] ;
//            if ([imgStr isEqualToString:@"http:"]) {
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.image]];
//                imageView.image = [UIImage imageWithData:data];
//            }else{
//                imageView.image = [UIImage imageNamed:item.image];
//            }
            [imageView setImage:[UIImage imageNamed:@"ico.png"]];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(space,  _scrollView.frame.size.height-2*space-22, _scrollView.frame.size.width-space*2, 22)];
//            backView.backgroundColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:0.5];
             backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [imageView addSubview:backView];
            
            [_scrollView addSubview:imageView];
        }
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space+5+10-5, _scrollView.frame.size.height-35 , 300, (_scrollView.frame.size.height-2*space-size.height)/4)];
        titleLabel.text = item.title;
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.5]];
        titleLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:titleLabel];
        
        UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space+( _scrollView.frame.size.height-14)+17,-3, (_scrollView.frame.size.width-space*2-_scrollView.frame.size.height), 32)];
        titleLabel1.text = item.title1;
        [titleLabel1 setFont:[UIFont fontWithName:@"Helvetica Bold" size:14]];
        titleLabel1.textColor = [UIColor blackColor];
        [_scrollView addSubview:titleLabel1];
        
        UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space+( _scrollView.frame.size.height-14)+17, 0, _scrollView.frame.size.width-space*2-_scrollView.frame.size.height, (_scrollView.frame.size.height-2*space-size.height)/4+10+50)];
        titleLabel2.numberOfLines = 2;
        titleLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
        if (item.title2.length > 37) {
            NSMutableString *str = [NSMutableString stringWithString:[item.title2 substringToIndex:37]];
            [str appendString:@"..."];
            titleLabel2.text = str;
        }else{
            titleLabel2.text = item.title2;
        }
//        titleLabel2.text = item.title2;
//        [titleLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [titleLabel2 setFont:[UIFont systemFontOfSize:11]];
        titleLabel2.textColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
        [_scrollView addSubview:titleLabel2];
        
       
        
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * aImageItems.count, _scrollView.frame.size.height);
    _pageControl.numberOfPages = aImageItems.count>1?aImageItems.count -2:aImageItems.count;
    _pageControl.currentPage = 0;
    
    if ([aImageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
        
    }
}

#pragma mark 改变添加视图内容
-(void)changeImageViewsContent:(NSArray *)aArray{
    NSMutableArray *imageItems = [NSMutableArray arrayWithArray:aArray];
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addImageViews:imageItems];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
//    if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
//    {
//        [self.delegate foucusImageFrame:self currentItem:targetX/_scrollView.frame.size.width];
//    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        if (targetX >= ITEM_WIDTH * ([imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    //    NSLog(@"%f %d",_scrollView.contentOffset.x,page);
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = (int)(_pageControl.numberOfPages -1);
        }
    }
//    if (page!= _pageControl.currentPage)
//    {
//        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
//        {
//            [self.delegate foucusImageFrame:self currentItem:page];
//        }
//    }
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
}


- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = (int)([imageItems count]-3);
        }
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}
@end