//
//  ViewController.m
//  DJInfiniteGridViewDemo
//
//  Created by Dokay on 16/1/7.
//  Copyright © 2016年 ylbd. All rights reserved.
//

#import "ViewController.h"
#import "DJInfiniteGridView.h"

@interface ViewController ()<DJInfiniteGridViewDataSource,DJInfiniteGridDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DJInfiniteGridView *gridView = [[DJInfiniteGridView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    gridView.dataSource = self;
    gridView.delegate = self;
    [self.view addSubview:gridView];
    [gridView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)infiniteGridView:(DJInfiniteGridView *)gridView forIndex:(NSInteger)gridIndex
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:gridView.frame];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(gridIndex+1)]];
//    if (gridIndex % 2 == 1) {
//        imageView.image = [UIImage imageNamed:@"1"];
//    }else{
//        imageView.image = [UIImage imageNamed:@"place"];
//    }
//    
//    if (gridIndex == 6) {
//        imageView.image = [UIImage imageNamed:@"3"];
//    }
    
    return imageView;
}

- (NSUInteger)numberOfGridsInInfiniteGridView:(DJInfiniteGridView *)gridView
{
    return 3;
}

@end
