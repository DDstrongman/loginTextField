//
//  HAPaperCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAPaperCollectionViewController.h"
#import "HATransitionLayout.h"

#define MAX_COUNT 20
#define CELL_ID @"CELL_ID"

@interface HAPaperCollectionViewController ()

@end


@implementation HAPaperCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

//#pragma mark - Hide StatusBar
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

#pragma 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
//    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell"]];
//    cell.backgroundView = backgroundView;
//    cell.backgroundColor = themeColor;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 20)];
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    _labelButton = [[UIButton alloc]init];//需要自适应宽度，高度为25
    _labelButton.layer.cornerRadius = 4;
    _labelButton.clipsToBounds = YES;
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 180)];
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 60)];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_imageButton];
    [self.view addSubview:_timeLabel];
    [self.view addSubview:_labelButton];
    [self.view addSubview:_titleImageView];
    [self.view addSubview:_detailLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_COUNT;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewController*)nextViewControllerAtPoint:(CGPoint)point
{
    return nil;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

#pragma 此处可以加入网络获取的初始化数据，为加速可以提前从网络获取并将一些同步到本地
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [HAPaperCollectionViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}

@end
