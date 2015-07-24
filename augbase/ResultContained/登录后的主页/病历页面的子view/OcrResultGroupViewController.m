//
//  OcrResultGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
#import "OcrResultGroupViewController.h"

NSString * const cellReuseIdOcrResult = @"ocrGroupCell";

@interface OcrResultGroupViewController ()

{
    KRLCollectionViewGridLayout *lineLayout;
}

@end

@implementation OcrResultGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    lineLayout.numberOfItemsPerLine = 3;
    lineLayout.interitemSpacing = 2;
    lineLayout.lineSpacing = 2;
    lineLayout.aspectRatio = 1.0/1.0;
    lineLayout.headerReferenceSize = CGSizeMake(ViewWidth, 22);
    
    _ocrResultCollection.collectionViewLayout = lineLayout;
    _ocrResultCollection.alwaysBounceVertical = YES;
    _ocrResultCollection.delegate   = self;
    _ocrResultCollection.dataSource = self;
    
    [_ocrResultCollection setClipsToBounds:YES];
    
    _ocrResultCollection.backgroundColor = grayBackColor;
    _ocrResultCollection.pagingEnabled = NO;
    
    _ocrResultCollection.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_ocrResultCollection registerClass:[Cell1 class]forCellWithReuseIdentifier:cellReuseIdOcrResult];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:themeColor];
    self.title = NSLocalizedString(@"原始报告", @"");
}

#pragma collectionview的delegate,section需要网络获取数目
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdOcrResult forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"test"];
    cell.titleText.text = @"小月是逗比";
    cell.descriptionText.text = @"小月是逗比";
    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了section===%ld,row===%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section != 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailImageOcrViewController *diov = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
        if (indexPath.section == 1) {
            diov.ResultOrING = NO;//识别中
        }else{
            diov.ResultOrING = YES;//识别结果
        }
        diov.showImage = ((Cell1 *)[_ocrResultCollection cellForItemAtIndexPath:indexPath]).imageView.image;
        [self.navigationController pushViewController:diov animated:YES];
    }else{
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FailedOcrResultViewController *forv = [main instantiateViewControllerWithIdentifier:@"ocrfailedresult"];
        forv.failedImage = ((Cell1 *)[_ocrResultCollection cellForItemAtIndexPath:indexPath]).imageView.image;
        [self.navigationController pushViewController:forv animated:YES];
    }
}

@end
