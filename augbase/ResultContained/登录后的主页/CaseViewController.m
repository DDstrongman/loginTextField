//
//  CaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "CaseViewController.h"

#import "MyDoctorRootViewController.h"

@interface CaseViewController ()

{
    KRLCollectionViewGridLayout *lineLayout;
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *imageNameArray;//cell图片名称数组
}

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0,0);
    lineLayout.numberOfItemsPerLine = 1;
    lineLayout.interitemSpacing = 0.2;
    lineLayout.lineSpacing = 0.2;
    lineLayout.aspectRatio = 1.0/0.15;//长宽比例
    lineLayout.headerReferenceSize = CGSizeMake(ViewWidth, 39);
    
    _settingCollection.collectionViewLayout = lineLayout;
    _settingCollection.alwaysBounceVertical = YES;
    _settingCollection.delegate   = self;
    _settingCollection.dataSource = self;
    
    [_settingCollection setClipsToBounds:YES];
    
    _settingCollection.backgroundColor = grayBackgroundLightColor;
    _settingCollection.pagingEnabled = NO;
    
    _settingCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [_checkResultButton imageWithRedNumber:4];
    [_checkResultButton addTarget:self action:@selector(gotoOcrTextResult) forControlEvents:UIControlEventTouchUpInside];
    [_cameraNewButton addTarget:self action:@selector(cameRaNewResult:) forControlEvents:UIControlEventTouchUpInside];
    titleDataArray = [@[NSLocalizedString(@"原始报告", @""),NSLocalizedString(@"确诊病情", @""),NSLocalizedString(@"用药记录", @""),NSLocalizedString(@"我的医生", @""),NSLocalizedString(@"小易课堂", @""),NSLocalizedString(@"问卷", @"")]mutableCopy];
    imageNameArray = [@[@"reports2",@"diagnose2",@"medication2",@"my_doc",@"class",@"patients_c2"]mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.title = NSLocalizedString(@"病历", @"");
#warning 去掉navigationbar下划线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
//    [self initNavigationBar];
    
    UIImage* imageNormal = [UIImage imageNamed:@"case_history_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"case_history_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 66)];
    navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22+22);
    titleLabel.text = NSLocalizedString(@"病历", @"");
    titleLabel.textColor = [UIColor whiteColor];
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
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:imageNameArray[indexPath.row]];
    [((UIImageView *)[cell.contentView viewWithTag:4]) setTintColor:grayBackColor];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = titleDataArray[indexPath.row];
    ((UILabel *)[cell.contentView viewWithTag:3]).textColor = grayLabelColor;
    if (indexPath.row == 0) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"2015-07-12";
    }else if (indexPath.row == 1) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"大三阳";
    }else if (indexPath.row == 2) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"恩替卡韦";
    }else if (indexPath.row == 3) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"";
    }else if (indexPath.row == 4) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"";
    }else if (indexPath.row == 5) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"";
    }
    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = lightGrayBackColor.CGColor;

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
    }else if (indexPath.row == 3){
        MyDoctorRootViewController *mdrv = [[MyDoctorRootViewController alloc]init];
        [self.navigationController pushViewController:mdrv animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
