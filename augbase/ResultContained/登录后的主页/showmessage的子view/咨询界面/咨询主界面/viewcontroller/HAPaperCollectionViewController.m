//
//  HAPaperCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAPaperCollectionViewController.h"
#import "HATransitionLayout.h"

#import "ShowWebviewViewController.h"
#import "ItemTwo.h"

#define MAX_COUNT 20
#define CELL_ID @"CELL_ID"

@interface HAPaperCollectionViewController ()

{
    NSMutableArray *dataMutArray;
}

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

-(void)viewDidLoad{
#warning 此处要改为网络获取后存入类中
    ItemTwo *articleItem = [[ItemTwo alloc]init];
    articleItem.titleText = NSLocalizedString(@"小月来打飞机了", @"");
    articleItem.titleImage = [UIImage imageNamed:@"wechat"];
    articleItem.aricleImage = [UIImage imageNamed:@"test"];
    articleItem.timeText = NSLocalizedString(@"18:00", @"");
    articleItem.personName = NSLocalizedString(@"小易助手", @"");
    articleItem.tagArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"小月中和镇", @""),NSLocalizedString(@"娄sir中和镇", @""),nil];
    articleItem.aricleDescribe = NSLocalizedString(@"自从小月开始打飞机以来，我司卫生纸的消耗量直线上升", @"");
    dataMutArray = [@[articleItem]mutableCopy];
    for (int i = 0; i<19; i++) {
        [dataMutArray insertObject:articleItem atIndex:i];
    }
}

#pragma 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(0, 0, cell.frame.size.width, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    _titleLabel.text = ((ItemTwo *)dataMutArray[indexPath.row]).titleText;
    _imageButton = [[UIButton alloc]init];//WithFrame:CGRectMake(0, 0, 100, 40)];
    [_imageButton.imageView imageWithRound:NO];
    _imageButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_imageButton setImage:((ItemTwo *)dataMutArray[indexPath.row]).titleImage forState:UIControlStateNormal];
    [_imageButton setTitle:((ItemTwo *)dataMutArray[indexPath.row]).personName forState:UIControlStateNormal];
    [_imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSLog(@"((ItemTwo *)dataMutArray[indexPath.row]).personName == %@",((ItemTwo *)dataMutArray[indexPath.row]).personName);
    [_imageButton addTarget:self action:@selector(showAuthorInfo:) forControlEvents:UIControlEventTouchUpInside];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = ((ItemTwo *)dataMutArray[indexPath.row]).timeText;
    _labelButtonView = [[UIView alloc]init];
    _labelButton = [[UIButton alloc]init];//需要自适应宽度，高度为25
    _labelButton.layer.cornerRadius = 4;
    _labelButton.clipsToBounds = YES;
    [_labelButtonView addSubview:_labelButton];
    _articleImageView = [[UIImageView alloc]init];
    _articleImageView.image = ((ItemTwo *)dataMutArray[indexPath.row]).aricleImage;
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.text = ((ItemTwo *)dataMutArray[indexPath.row]).aricleDescribe;
    _detailLabel.textColor = grayLabelColor;
    _detailLabel.numberOfLines = 6;
    
    [cell addSubview:_titleLabel];
    [cell addSubview:_imageButton];
    [cell addSubview:_timeLabel];
    [cell addSubview:_labelButtonView];
    [cell addSubview:_articleImageView];
    [cell addSubview:_detailLabel];
    
    //test
//    _titleLabel.backgroundColor = themeColor;
//    _imageButton.backgroundColor = themeColor;
//    _timeLabel.backgroundColor = themeColor;
    _labelButtonView.backgroundColor = themeColor;
//    _articleImageView.backgroundColor = themeColor;
//    _detailLabel.backgroundColor = themeColor;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.top.equalTo(@0);
        make.height.equalTo(@20);
    }];
    [_imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(3);
        make.left.equalTo(@5);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(3);
        make.right.equalTo(@-5);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [_labelButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageButton.mas_bottom).with.offset(3);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@30);
    }];
    [_articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelButtonView.mas_bottom).with.offset(3);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@180);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_articleImageView.mas_bottom).with.offset(3);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@60);
    }];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_COUNT;
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowWebviewViewController *swc = [[ShowWebviewViewController alloc]init];
    [self.navigationController pushViewController:swc animated:YES];
}

#pragma 头像响应函数
-(void)showAuthorInfo:(UIButton *)sender{
    UIImage *titleImage = [sender backgroundImageForState:UIControlStateNormal];//获取头像
    UIAlertView *showInfo = [[UIAlertView alloc]initWithTitle:@"砖家" message:@"砖家王balabalabala~" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:titleImage];
    titleImageView.frame = CGRectMake(0, 0, 35, 35);
    titleImageView.center = showInfo.center;
    [titleImageView imageWithRound:NO];
    [showInfo addSubview:titleImageView];
    [showInfo show];
}
#pragma UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
#warning 添加确定的网络交互
        NSLog(@"确定");
    }
}

#pragma 此处可以加入网络获取的初始化数据，为加速可以提前从网络获取并将一些同步到本地
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"资讯放大模式", @"");
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [HAPaperCollectionViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}

@end
