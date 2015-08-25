//
//  OcrResultGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
#import "OcrResultGroupViewController.h"

#import "HttpManager.h"

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
    NSMutableArray *ocrProgressDetailArray;//ocr图片具体结果分组
    NSMutableArray *ocrSucessDetailArray;//ocr图片具体结果分组
}

@end

@implementation OcrResultGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"原始报告", @"");
}

#pragma collectionview的delegate,section需要网络获取数目
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_SegIndex == 0) {
        return ocrFailedArray.count;
    }else if(_SegIndex == 1){
        return ocrProgressArray.count;
    }else{
        return ocrSucessArray.count;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_SegIndex == 0) {
        return ((NSArray *)ocrFailedDetailArray[section]).count;
    }else if(_SegIndex == 1){
        return ((NSArray *)ocrProgressDetailArray[section]).count;
    }else{
        return ((NSArray *)ocrSucessDetailArray[section]).count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdOcrResult forIndexPath:indexPath];
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    NSString *urlString;
    if (_SegIndex == 0) {
        urlString = ((NSArray *)ocrFailedDetailArray[indexPath.section])[indexPath.row];
    }else if(_SegIndex == 1){
        urlString = ((NSArray *)ocrProgressDetailArray[indexPath.section])[indexPath.row];
    }else{
        urlString = ((NSArray *)ocrSucessDetailArray[indexPath.section])[indexPath.row];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString]]
                      placeholderImage:[UIImage imageNamed:@"test.png"]];
//    cell.titleText.text = @"小月是逗比";
//    cell.descriptionText.text = @"小月是逗比";
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
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ocrgroupresultheader" forIndexPath:indexPath];
    if (_SegIndex == 0) {
        ((UILabel *)[headerView viewWithTag:1]).text = ocrFailedArray[indexPath.section];
    }else if(_SegIndex == 1){
        ((UILabel *)[headerView viewWithTag:1]).text = ocrProgressArray[indexPath.section];
    }else{
        ((UILabel *)[headerView viewWithTag:1]).text = ocrSucessArray[indexPath.section];
    }
    headerView.backgroundColor = themeColor;
    return headerView;
}

-(void)setupView{
    VOSegmentedControl *segctrl1 = [[VOSegmentedControl alloc] initWithSegments:@[@{@"text": NSLocalizedString(@"识别失败", @"")},
                                                                                  @{@"text": NSLocalizedString(@"识别中", @"")},
                                                                                  @{@"text": NSLocalizedString(@"识别成功", @"")}]];
    segctrl1.contentStyle = VOContentStyleTextAlone;
    segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
    segctrl1.textColor = [UIColor blackColor];
    segctrl1.backgroundColor = grayBackColor;
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
    lineLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    //    lineLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
    
    ocrGroupTitleArray = [@[@"识别失败",@"识别中",@"识别成功"]mutableCopy];
}

-(void)setupData{
    _SegIndex = 0;
    
    ocrFailedArray = [NSMutableArray array];
    ocrProgressArray = [NSMutableArray array];
    ocrSucessArray = [NSMutableArray array];
    ocrSucessDetailArray = [NSMutableArray array];
    ocrProgressDetailArray = [NSMutableArray array];
    ocrFailedDetailArray = [NSMutableArray array];
    
    NSString *urlFailedSucess = [NSString stringWithFormat:@"%@ltr/month/list?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    NSString *urlProgressing = [NSString stringWithFormat:@"%@ltr/nodislist?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    [[HttpManager ShareInstance] AFNetGETSupport:urlFailedSucess Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSDictionary *picSucessList = [source objectForKey:@"ltr"];
        NSArray *picFailedList = [source objectForKey:@"faillist"];
        if (res == 0) {
#warning 此处的结构在后端重构合理的json结构后需要改变，具体参考识别失败的结构
            for (id key in picSucessList) {
                [ocrSucessArray addObject:key];
                NSArray *sucListArray = [picSucessList objectForKey:key];
                for(id picDetail in sucListArray){
                    NSDictionary *picDic = picDetail;
                    [ocrSucessDetailArray addObject:[picDic objectForKey:@"pics"]];
                }
            }
            for (int i = 0;i<picFailedList.count;i++) {
                NSDictionary *failDic = picFailedList[i];
                [ocrFailedArray addObject:[failDic objectForKey:@"createtime"]];
//                for (id pic in [failDic objectForKey:@"pics"]) {
//                    [ocrFailedDetailArray addObject:pic];
//                }
                [ocrFailedDetailArray addObject:[failDic objectForKey:@"pics"]];
            }
            [_ocrResultCollection reloadData];
        }else{
            
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB获取成功失败列表失败%@",error);
    }];
    
    [[HttpManager ShareInstance] AFNetGETSupport:urlProgressing Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSArray *ocrProgressing = [source objectForKey:@"nodislist"];
        if (res == 0) {
            for (id progress in ocrProgressing) {
                NSDictionary *progressDic = progress;
                [ocrProgressArray addObject:[progressDic objectForKey:@"createtime"]];
                [ocrProgressDetailArray addObject:[progressDic objectForKey:@"pics"]];
            }
            [_ocrResultCollection reloadData];
        }else{
            
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB获取进行中列表失败：%@",error);
    }];
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    _SegIndex = segmentCtrl.selectedSegmentIndex;
    [_ocrResultCollection reloadData];
}

@end
