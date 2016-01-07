//
//  DJInfiniteGridView.m
//  DJInfiniteGridViewDemo
//
//  Created by Dokay on 16/1/7.
//  Copyright © 2016年 ylbd. All rights reserved.
//

#import "DJInfiniteGridView.h"

#define myWidth self.frame.size.width
#define myHeight self.frame.size.height
#define pageSize (myHeight * 0.2 > 25 ? 25 : myHeight * 0.2)

@interface DJInfiniteGridView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger MaxImageCount;

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
        self.MaxImageCount = [self.dataSource numberOfGridsInInfiniteGridView:self];
        self.scrollView.contentSize = CGSizeMake(myWidth * 3, 0);
        [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
    }else{
        return;
    }
}

- (void)jumpToIndex:(NSInteger)gridIndex
{
    
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


- (void)changeImageWithOffset:(CGFloat)offsetX {
    
    if (offsetX >= myWidth * 2) {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1) {
            
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount) {
            
            _currentIndex = 0;
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
    }
    
    if (offsetX <= 0) {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
    }
    
}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
    
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(infiniteGridView:forIndex:)]) {
        _leftImageView.image = ((UIImageView *)[self.dataSource infiniteGridView:self forIndex:LeftIndex]).image;
        _centerImageView.image = ((UIImageView *)[self.dataSource infiniteGridView:self forIndex:centerIndex]).image;
        _rightImageView.image = ((UIImageView *)[self.dataSource infiniteGridView:self forIndex:rightIndex]).image;
    }else{
        _leftImageView = nil;
        _centerImageView = nil;
        _rightImageView = nil;
    }
    _centerImageView.backgroundColor = [UIColor redColor];
    
    [_scrollView setContentOffset:CGPointMake(myWidth, 0)];
}

#pragma mark - private method
- (void)setupCurrentView
{
    [self addSubview:self.scrollView];
    [self prepareImageView];
}

- (void)prepareImageView {
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,myWidth, myHeight)];
    UIImageView *center = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth, 0,myWidth, myHeight)];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth * 2, 0,myWidth, myHeight)];
    
    center.userInteractionEnabled = YES;
    [center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    
    [_scrollView addSubview:left];
    [_scrollView addSubview:center];
    [_scrollView addSubview:right];
    
    _leftImageView = left;
    _centerImageView = center;
    _rightImageView = right;
    
}

- (void)imageViewDidTap
{
   
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

@end
