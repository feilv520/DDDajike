//
//  SGFocusImageFrame.h
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//


//封装广告视图相关
#import <UIKit/UIKit.h>
@class SGFocusImageItem;
@class SGFocusImageFrame;

#pragma mark - SGFocusImageFrameDelegate
@protocol SGFocusImageFrameDelegate <NSObject>
@optional
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item;
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;

@end


@interface SGFocusImageFrame : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    BOOL _isAutoPlay;
//    BOOL isArticleAd;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto isAD:(BOOL)isAd;


- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items;
- (void)scrollToIndex:(int)aIndex;

#pragma mark 改变添加视图内容
-(void)changeImageViewsContent:(NSArray *)aArray;

@property (nonatomic, assign) id<SGFocusImageFrameDelegate> delegate;
@property (nonatomic, assign) BOOL isArticleAd;

@end
