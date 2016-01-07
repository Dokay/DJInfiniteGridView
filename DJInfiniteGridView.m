//
//  DJInfiniteGridView.m
//  DJInfiniteGridViewDemo
//
//  Created by Dokay on 16/1/7.
//  Copyright © 2016年 ylbd. All rights reserved.
//

#import "DJInfiniteGridView.h"

#define selfWidth self.frame.size.width
#define selfHeight self.frame.size.height

@interface DJInfiniteGridView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger maxViewCount;

@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) UIView *leftMirrorView;
@property (nonatomic, strong) UIView *rightMirrorView;

@end

@implementation DJInfiniteGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupCurrentView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupCurrentView];
}

#pragma mark - public method
- (void)reloadData
{
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(numberOfGridsInInfiniteGridView:)]) {
        self.maxViewCount = [self.dataSource numberOfGridsInInfiniteGridView:self];
        if (self.maxViewCount == 0) {
            self.scrollView.scrollEnabled = NO;
            return;
        }else if(self.maxViewCount == 1){
            self.scrollView.contentSize = CGSizeMake(selfWidth, 0);
            self.scrollView.scrollEnabled = NO;
            [self changeImageLeft:10 center:0 right:10];//10 more than 1,to set nil for left and right view
        }else {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentSize = CGSizeMake(selfWidth * 3, 0);
            [self changeImageLeft:_maxViewCount-1 center:0 right:1];
        }
    }else{
        return;
    }
}

- (void)jumpToIndex:(NSInteger)gridIndex
{
    NSInteger leftIndex = gridIndex == 0 ? self.maxViewCount - 1 : gridIndex - 1;
    NSInteger rightIndex = gridIndex == self.maxViewCount ? 0 : gridIndex + 1;
    [self changeImageLeft:leftIndex center:gridIndex right:rightIndex];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeImageWithOffset:scrollView.contentOffset.x];
}


#pragma mark - private method
- (void)setupCurrentView
{
    [self addSubview:self.scrollView];
}

- (void)changeImageWithOffset:(CGFloat)offsetX {
    
    if (offsetX >= selfWidth * 2) {
        _currentIndex++;
        
        if (_currentIndex == _maxViewCount-1) {
            
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _maxViewCount) {
            
            _currentIndex = 0;
            [self changeImageLeft:_maxViewCount-1 center:0 right:1];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
    }
    
    if (offsetX <= 0) {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_maxViewCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _maxViewCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
    }
    
}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
    
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(infiniteGridView:forIndex:)]) {
        
        UIView *leftView;
        if (self.maxViewCount != 2) {
            leftView = [self viewWithIndex:LeftIndex];
        }else{
            if (centerIndex == 0) {
                leftView = self.leftMirrorView;
            }else{
                leftView = self.rightMirrorView;
            }
            [self.scrollView bringSubviewToFront:leftView];
        }
        leftView.frame = CGRectMake(0, 0,selfWidth, selfHeight);
        
        UIView *centerView = [self viewWithIndex:centerIndex];
        centerView.frame = CGRectMake(selfWidth, 0,selfWidth, selfHeight);
        
        UIView *rightView = [self viewWithIndex:rightIndex];
        rightView.frame = CGRectMake(selfWidth * 2, 0,selfWidth, selfHeight);
    }
    
    [_scrollView setContentOffset:CGPointMake(selfWidth, 0)];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteGridView:didScrollToPage:)]) {
        [self.delegate infiniteGridView:self didScrollToPage:centerIndex];
    }
}

- (UIView *)viewWithIndex:(NSInteger)index
{
    UIView *view;
    if (self.viewsArray.count > index) {
        view = [self.viewsArray objectAtIndex:index];
        if ((NSNull *)view == [NSNull null]) {
            view = [self.dataSource infiniteGridView:self forIndex:index];
            view.tag = index;
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)]];
            [self.viewsArray replaceObjectAtIndex:index withObject:view];
            [self.scrollView addSubview:view];
        }
        return view;
    }
    
    return view;
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteGridView:didSelectGridAtIndex:)]) {
        [self.delegate infiniteGridView:self didSelectGridAtIndex:index];
    }
}

#pragma mark - getter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray *)viewsArray
{
    if (_viewsArray == nil) {
        _viewsArray = [NSMutableArray arrayWithCapacity:self.maxViewCount];
        for (int i = 0; i < self.maxViewCount; i++) {
            [_viewsArray addObject:[NSNull null]];
        }
    }
    return _viewsArray;
}

- (UIView *)leftMirrorView
{
    if (_leftMirrorView == nil) {
        _leftMirrorView = [self.dataSource infiniteGridView:self forIndex:self.maxViewCount-1];
        [self.scrollView addSubview:_leftMirrorView];
    }
    return _leftMirrorView;
}

- (UIView *)rightMirrorView
{
    if (_rightMirrorView == nil) {
        _rightMirrorView = [self.dataSource infiniteGridView:self forIndex:0];
        [self.scrollView addSubview:_rightMirrorView];
    }
    return _rightMirrorView;
}

@end
