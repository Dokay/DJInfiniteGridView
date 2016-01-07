//
//  DJInfiniteGridView.h
//  DJInfiniteGridViewDemo
//
//  Created by Dokay on 16/1/7.
//  Copyright © 2016年 ylbd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJInfiniteGridView;

@protocol DJInfiniteGridViewDataSource <NSObject>

- (UIView *)infiniteGridView:(DJInfiniteGridView *)gridView forIndex:(NSInteger)gridIndex;
- (NSUInteger)numberOfGridsInInfiniteGridView:(DJInfiniteGridView *)gridView;

@end

@protocol DJInfiniteGridDelegate <NSObject>

@optional

- (void)infiniteGridView:(DJInfiniteGridView *)gridView didScrollToPage:(NSInteger)pageIndex;
- (void)infiniteGridView:(DJInfiniteGridView *)gridView didSelectGridAtIndex:(NSInteger)gridIndex;

@end

@interface DJInfiniteGridView : UIView

@property (nonatomic, weak) NSObject<DJInfiniteGridViewDataSource> *dataSource;
@property (nonatomic, weak) NSObject<DJInfiniteGridDelegate> *delegate;

@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, assign) NSTimeInterval autoScrollElapse;
@property (nonatomic, assign) BOOL isAutoScroll;

- (void)reloadData;
- (void)jumpToIndex:(NSInteger)gridIndex;

@end
