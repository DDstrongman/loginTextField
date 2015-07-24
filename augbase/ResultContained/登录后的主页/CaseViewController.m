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
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
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
//    //左侧头像按钮，点击打开用户相关选项
//    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
//    userButton.center = CGPointMake(20, 22);
//    
//    userButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
//    [userButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
//    
//    [userButton addTarget:self action:@selector(openUser) forControlEvents:UIControlEventTouchUpInside];
//    
//    [navigationBar addSubview:userButton];
    
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    titleLabel.text = NSLocalizedString(@"病历", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
//    //去登陆界面
//    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
//    cameraButton.center = CGPointMake(ViewWidth-20, 22);
//    
//    cameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
//    [cameraButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
//    
//    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
//    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
//    [navigationBar addSubview:cameraButton];
    
    [self.view addSubview:navigationBar];
}

#pragma 打开用户相关界面，左侧抽屉显示，view暂时未做
-(void)openUser{
    NSLog(@"打开用户界面");
}

#pragma 打开cameraview拍摄化验单等,cameraview已写好
-(void)openCamera{
    NSLog(@"打开拍照界面");
}

#pragma collectionview的delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"casechoosecell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [((UIImageView *)[cell.contentView viewWithTag:4]) setTintColor:grayBackColor];
    if (indexPath.row == 0) {
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"原始报告", @"");
    }else if (indexPath.row ==1){
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"确诊病情", @"");
    }else if (indexPath.row ==2){
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"用药记录", @"");
    }else if (indexPath.row ==3){
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"小易课堂", @"");
    }else if (indexPath.row ==4){
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"问卷", @"");
    }else{
        
    }
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
}


@end
