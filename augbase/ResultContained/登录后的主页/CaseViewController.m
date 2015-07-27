//
//  CaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "CaseViewController.h"

@interface CaseViewController ()

{
    KRLCollectionViewGridLayout *lineLayout;
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
}

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    lineLayout.numberOfItemsPerLine = 1;
    lineLayout.interitemSpacing = 2;
    lineLayout.lineSpacing = 2;
    lineLayout.aspectRatio = 1.0/0.15;
    lineLayout.headerReferenceSize = CGSizeMake(ViewWidth, 44);
    
    _settingCollection.collectionViewLayout = lineLayout;
    _settingCollection.alwaysBounceVertical = YES;
    _settingCollection.delegate   = self;
    _settingCollection.dataSource = self;
    
    [_settingCollection setClipsToBounds:YES];
    
    _settingCollection.backgroundColor = grayBackColor;
    _settingCollection.pagingEnabled = NO;
    
    _settingCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [_checkResultButton imageWithRedNumber:4];
    [_checkResultButton addTarget:self action:@selector(gotoOcrTextResult) forControlEvents:UIControlEventTouchUpInside];
    [_cameraNewButton addTarget:self action:@selector(cameRaNewResult:) forControlEvents:UIControlEventTouchUpInside];
    titleDataArray = [@[NSLocalizedString(@"原始报告", @""),NSLocalizedString(@"确诊病情", @""),NSLocalizedString(@"用药记录", @""),NSLocalizedString(@"小易课堂", @""),NSLocalizedString(@"问卷", @"")]mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
}

#pragma 上方两个大按钮的响应函数
-(void)cameRaNewResult:(UIButton *)sender{
    CameraViewController *cvc = [[CameraViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)gotoOcrTextResult{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OcrTextResultViewController *otrv = [story instantiateViewControllerWithIdentifier:@"ocrtextresult"];
    [self.navigationController pushViewController:otrv animated:YES];
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 22, ViewWidth, 44)];
    navigationBar.backgroundColor = themeColor;
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    titleLabel.text = NSLocalizedString(@"病历", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    [self.view addSubview:navigationBar];
}

#pragma collectionview的delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titleDataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"casechoosecell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [((UIImageView *)[cell.contentView viewWithTag:4]) setTintColor:grayBackColor];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = titleDataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OcrResultGroupViewController *orgv = [main instantiateViewControllerWithIdentifier:@"ocrgroupresult"];
        [self.navigationController pushViewController:orgv animated:YES];
    }else if (indexPath.row == 1){
        BasicsituationViewController *bsv = [[BasicsituationViewController alloc]init];
        [self.navigationController pushViewController:bsv animated:YES];
    }else if (indexPath.row == 2){
        HistoryViewController *hvc = [[HistoryViewController alloc]init];
        [self.navigationController pushViewController:hvc animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
