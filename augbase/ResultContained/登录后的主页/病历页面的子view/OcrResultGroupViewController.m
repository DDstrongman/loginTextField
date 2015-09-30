//
//  OcrResultGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
#import "OcrResultGroupViewController.h"
#import "VOSegmentedControl.h"

NSString * const cellReuseIdOcrResult = @"ocrGroupCell";

@interface OcrResultGroupViewController ()

{
    KRLCollectionViewGridLayout *lineLayout;
    KRLCollectionViewGridLayout *lineLayoutDetail;
    NSMutableArray *ocrGroupTitleArray;//ocr图片结果分组
    NSMutableArray *ocrFailedArray;//ocr图片头分组
    NSMutableArray *ocrProgressArray;//ocr图片头分组
    NSMutableArray *ocrSucessArray;//ocr图片头分组
    NSMutableArray *ocrFailedDetailArray;//ocr图片具体结果分组
    NSMutableArray *ocrSucessDetailArray;//ocr图片具体结果分组
    
    NSArray *sucessOrderArray;//成功的排序；
    NSArray *failedOrderArray;//失败的排序;
}

@end

@implementation OcrResultGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    _SegIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"原始报告", @"");
}

#pragma collectionview的delegate,section需要网络获取数目
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_SegIndex == 0) {
        return ocrFailedArray.count;
    }else if(_SegIndex == 1){
        return 1;
    }else{
        return ocrSucessArray.count;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_SegIndex == 0) {
        return ((NSArray *)ocrFailedDetailArray[section]).count;
    }else if(_SegIndex == 1){
        return ocrProgressArray.count;
    }else{
        return ((NSArray *)ocrSucessDetailArray[section]).count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdOcrResult forIndexPath:indexPath];
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    NSString *urlString;
    if (_SegIndex == 0) {
        urlString = [(NSDictionary *)[(NSDictionary *)((NSArray *)ocrFailedDetailArray[indexPath.section])[indexPath.row] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];
    }else if(_SegIndex == 1){
        NSDictionary *tempDic = ocrProgressArray[indexPath.row];
        NSArray *tempArray = [tempDic objectForKey:@"picsInfo"];
        NSDictionary *progressTempDic = tempArray[0];
        urlString = [progressTempDic objectForKey:@"pic"];
    }else{
        urlString = [(NSDictionary *)[(NSDictionary *)((NSArray *)ocrSucessDetailArray[indexPath.section])[indexPath.row] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin_thumb/%@",urlString]]
                      placeholderImage:[UIImage imageNamed:@"test.png"]];
    cell.backgroundColor = grayBackgroundLightColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了section===%ld,row===%ld",(long)indexPath.section,(long)indexPath.row);
    if (_SegIndex == 0) {
        NSString *urlString;
        urlString = [(NSDictionary *)[(NSDictionary *)((NSArray *)ocrFailedDetailArray[indexPath.section])[indexPath.row] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FailedOcrResultViewController *forv = [main instantiateViewControllerWithIdentifier:@"ocrfailedresult"];
        forv.failedImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
        forv.detailDic = ocrFailedDetailArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:forv animated:YES];
    }else{
        NSString *urlString;
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailImageOcrViewController *diov = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
        if (_SegIndex == 1) {
            diov.ResultOrING = NO;//识别中
            NSDictionary *tempDic = ocrProgressArray[indexPath.row];
            NSArray *tempArray = [tempDic objectForKey:@"picsInfo"];
            NSDictionary *progressTempDic = tempArray[0];
            urlString = [progressTempDic objectForKey:@"pic"];
        }else{
            diov.ResultOrING = YES;//识别结果
            diov.detailDic = ocrSucessDetailArray[indexPath.section][indexPath.row];
            urlString = [(NSDictionary *)[(NSDictionary *)((NSArray *)ocrSucessDetailArray[indexPath.section])[indexPath.row] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];
        }
        diov.showImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
        [self.navigationController pushViewController:diov animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ocrgroupresultheader" forIndexPath:indexPath];
    if (_SegIndex == 0) {
        ((UILabel *)[headerView viewWithTag:1]).text = ocrFailedArray[indexPath.section];
    }else if(_SegIndex == 1){
        ((UILabel *)[headerView viewWithTag:1]).text = NSLocalizedString(@"识别中", @"");
    }else{
        ((UILabel *)[headerView viewWithTag:1]).text = ocrSucessArray[indexPath.section];
    }
    headerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.7];
    return headerView;
}

-(void)setupView{
    VOSegmentedControl *segctrl1 = [[VOSegmentedControl alloc] initWithSegments:@[@{@"text": NSLocalizedString(@"识别失败", @"")},
                                                                                  @{@"text": NSLocalizedString(@"识别中", @"")},
                                                                                  @{@"text": NSLocalizedString(@"识别成功", @"")}]];
    segctrl1.contentStyle = VOContentStyleTextAlone;
    segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
    segctrl1.textColor = [UIColor blackColor];
    segctrl1.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    segctrl1.allowNoSelection = NO;
    segctrl1.frame = CGRectMake(0,0,ViewWidth,44);
    segctrl1.selectedTextFont = [UIFont systemFontOfSize:17];
    segctrl1.selectedTextColor = themeColor;
    segctrl1.selectedBackgroundColor = [UIColor clearColor];
    segctrl1.indicatorThickness = 4;
    segctrl1.selectedIndicatorColor = themeColor;
    segctrl1.tag = 1;
    [self.view addSubview:segctrl1];
    [segctrl1 setIndexChangeBlock:^(NSInteger index) {
        
    }];
    [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(0, 1, 1, 1);
    lineLayout.numberOfItemsPerLine = 3;
    lineLayout.interitemSpacing = 10;
    lineLayout.lineSpacing = 1;
    lineLayout.aspectRatio = 1.0/1.0;
    lineLayout.headerReferenceSize = CGSizeMake(ViewWidth, 45);
    
    _ocrResultCollection.collectionViewLayout = lineLayout;
    _ocrResultCollection.alwaysBounceVertical = YES;
    _ocrResultCollection.delegate   = self;
    _ocrResultCollection.dataSource = self;
    
    [_ocrResultCollection setClipsToBounds:YES];
    
    _ocrResultCollection.backgroundColor = [UIColor whiteColor];
    _ocrResultCollection.pagingEnabled = NO;
    
    _ocrResultCollection.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_ocrResultCollection registerClass:[Cell1 class]forCellWithReuseIdentifier:cellReuseIdOcrResult];
    
    ocrGroupTitleArray = [@[@"识别失败",@"识别中",@"识别成功"]mutableCopy];
}

-(void)setupData{
    
    ocrFailedArray = [NSMutableArray array];
    ocrProgressArray = [NSMutableArray array];
    ocrSucessArray = [NSMutableArray array];
    ocrSucessDetailArray = [NSMutableArray array];
    ocrFailedDetailArray = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/user/ltr/all/?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    NSLog(@"url===%@",url);
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSDictionary *picSucessList = [source objectForKey:@"successedLtr"];
        NSDictionary *picFailedList = [source objectForKey:@"failedLtr"];
        sucessOrderArray = [source objectForKey:@"successedLtrOrder"];
        failedOrderArray = [source objectForKey:@"failedLtrOrder"];
        ocrSucessArray = [NSMutableArray arrayWithArray:sucessOrderArray];
        ocrFailedArray = [NSMutableArray arrayWithArray:failedOrderArray];
        ocrProgressArray = [source objectForKey:@"onProgressLtr"];
        if (res == 0) {
            for (int i = 0;i<failedOrderArray.count;i++) {
                NSString *failDate = failedOrderArray[i];
                [ocrFailedDetailArray addObject:[picFailedList objectForKey:failDate]];
            }
            for (int i = 0;i<sucessOrderArray.count;i++) {
                NSString *sucessDate = sucessOrderArray[i];
                [ocrSucessDetailArray addObject:[picSucessList objectForKey:sucessDate]];
            }
            [_ocrResultCollection reloadData];
        }else{
            
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB获取成功失败列表失败%@",error);
    }];
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    _SegIndex = segmentCtrl.selectedSegmentIndex;
    [_ocrResultCollection reloadData];
}

@end
