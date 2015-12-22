//
//  OcrResultGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
#import "OcrResultGroupViewController.h"

#import "HYSegmentedControl.h"

#import "MBProgressHUD.h"

NSString * const cellReuseIdOcrResult = @"ocrGroupCell";

@interface OcrResultGroupViewController ()<DeleteFailedReportDele,HYSegmentedControlDelegate>{
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
    
    UIImageView *backGroudImageView;//底部没有识别图片的时候的背景图片
    UILabel *remindLabel;//和图一起出现的图示用label
    
    MBProgressHUD *hud;
}

@property (strong, nonatomic)HYSegmentedControl *segmentedControl;

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
    if (_SegIndex == 2) {
        return 1;
    }else if(_SegIndex == 1){
        return 1;
    }else{
        return ocrSucessArray.count;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_SegIndex == 2) {
        return ocrFailedDetailArray.count;
    }else if(_SegIndex == 1){
        return ocrProgressArray.count;
    }else{
        return ((NSArray *)ocrSucessDetailArray[section]).count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdOcrResult forIndexPath:indexPath];
    NSString *urlString;
    if (_SegIndex == 2) {
        NSArray *tempArray = [ocrFailedDetailArray[indexPath.row] objectForKey:@"picsInfo"];
        if (tempArray.count>0) {
            urlString = [tempArray[0] objectForKey:@"pic"];
        }
    }else if(_SegIndex == 1){
        if (ocrProgressArray.count>0) {
            NSDictionary *tempDic = ocrProgressArray[indexPath.row];
            NSArray *tempArray = [tempDic objectForKey:@"picsInfo"];
            NSDictionary *progressTempDic = tempArray[0];
            urlString = [progressTempDic objectForKey:@"pic"];
        }
    }else{
        if (ocrSucessDetailArray.count>0) {
            NSArray *tempArray = [(NSDictionary *)((NSArray *)ocrSucessDetailArray[indexPath.section])[indexPath.row] objectForKey:@"picsInfo"];
            if (tempArray.count>0) {
                urlString = [tempArray[0] objectForKey:@"pic"];
            }
        }
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin_thumb/%@",urlString]]
                      placeholderImage:[UIImage imageNamed:@"yulantu_3"]];
    cell.backgroundColor = grayBackgroundLightColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了section===%ld,row===%ld",(long)indexPath.section,(long)indexPath.row);
    if (_SegIndex == 2) {
        NSString *urlString;
        NSArray *tempArray = [ocrFailedDetailArray[indexPath.row] objectForKey:@"picsInfo"];
        if (tempArray.count>0) {
            urlString = [tempArray[0] objectForKey:@"pic"];
        }
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FailedOcrResultViewController *forv = [main instantiateViewControllerWithIdentifier:@"ocrfailedresult"];
        forv.failedImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
        forv.detailDic = ocrFailedDetailArray[indexPath.row];
        forv.caseRootVC = _caseRootVC;
        forv.deleteFailedReportDele = self;
        [self.navigationController pushViewController:forv animated:YES];
    }else{
        NSString *urlString;
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailImageOcrViewController *diov = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
        if (_SegIndex == 1) {
            diov.ResultOrING = NO;//识别中
            if (ocrProgressArray.count>0) {
                NSDictionary *tempDic = ocrProgressArray[indexPath.row];
                NSArray *tempArray = [tempDic objectForKey:@"picsInfo"];
                NSDictionary *progressTempDic = tempArray[0];
                urlString = [progressTempDic objectForKey:@"pic"];
            }
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
    if (_SegIndex == 2) {
        ((UILabel *)[headerView viewWithTag:1]).text = NSLocalizedString(@"识别失败", @"");
    }else if(_SegIndex == 1){
        ((UILabel *)[headerView viewWithTag:1]).text = NSLocalizedString(@"请耐心等待", @"");
    }else{
        if (ocrSucessArray.count>0) {
            ((UILabel *)[headerView viewWithTag:1]).text = ocrSucessArray[indexPath.section];
        }
    }
    headerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.3];
    return headerView;
}

#pragma 删除识别失败化验单成功后的返回delegate
-(void)deleteReport:(BOOL)result{
    if (result) {
        [_ocrResultCollection reloadData];
    }
}

-(void)setupView{
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[NSLocalizedString(@"识别成功", @""), NSLocalizedString(@"识别中", @""), NSLocalizedString(@"识别失败", @"")] delegate:self] ;
    [self.view addSubview:_segmentedControl];

    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    lineLayout.numberOfItemsPerLine = 3;
    lineLayout.interitemSpacing = 10;
    lineLayout.lineSpacing = 10;
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
    
    ocrGroupTitleArray = [@[@"识别成功",@"识别中",@"识别失败"]mutableCopy];
    
    backGroudImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth/2-60,(ViewHeight)/2-30-44-22-44-44, 120, 120)];
    [_ocrResultCollection addSubview:backGroudImageView];
    remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth/2-90,(ViewHeight)/2-30+120+10-44-22-44-44, 180, 50)];
    remindLabel.font = [UIFont systemFontOfSize:15.0];
    remindLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
    remindLabel.numberOfLines = 2;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [_ocrResultCollection addSubview:remindLabel];
}

-(void)setupData{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    hud.labelText = NSLocalizedString(@"加载中...", @"");
    //是否有庶罩
    hud.dimBackground = NO;
    ocrFailedArray = [NSMutableArray array];
    ocrProgressArray = [NSMutableArray array];
    ocrSucessArray = [NSMutableArray array];
    ocrSucessDetailArray = [NSMutableArray array];
    ocrFailedDetailArray = [NSMutableArray array];
    
    if (_LocalOrNet||![[WriteFileSupport ShareInstance]isFileExist:yizhenMineReportImage]) {
        NSString *url = [NSString stringWithFormat:@"%@v2/user/ltr/all/?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
        NSLog(@"url====%@",url);
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
                    for (NSDictionary *dic in [picFailedList objectForKey:failDate]) {
                        [ocrFailedDetailArray addObject:dic];
                    }
                }
                for (int i = 0;i<sucessOrderArray.count;i++) {
                    NSString *sucessDate = sucessOrderArray[i];
                    [ocrSucessDetailArray addObject:[picSucessList objectForKey:sucessDate]];
                }
                NSData *tempSuccessDetailData = [NSKeyedArchiver archivedDataWithRootObject:ocrSucessDetailArray];
                NSData *tempFailedDetailData = [NSKeyedArchiver archivedDataWithRootObject:ocrFailedDetailArray];
                [[WriteFileSupport ShareInstance]writeArray:ocrSucessArray DirName:yizhenMineReportImage FileName:yizhenMineSucessReport];
                [[WriteFileSupport ShareInstance]writeArray:ocrProgressArray DirName:yizhenMineReportImage FileName:yizhenMineProgressReport];
                [[WriteFileSupport ShareInstance]writeArray:ocrFailedArray DirName:yizhenMineReportImage FileName:yizhenMineFailedReport];
                [[WriteFileSupport ShareInstance]writeData:tempSuccessDetailData DirName:yizhenMineReportImage FileName:yizhenMineSucessDetailReport];
                [[WriteFileSupport ShareInstance]writeData:tempFailedDetailData DirName:yizhenMineReportImage FileName:yizhenMineFailedDetailReport];
                
                if (ocrSucessArray.count == 0) {
                    backGroudImageView.hidden = NO;
                    remindLabel.hidden = NO;
                    backGroudImageView.image = [UIImage imageNamed:@"no_hyd"];
                    remindLabel.text = NSLocalizedString(@"您还没有识别完成的报告\n请先上传报告", @"");
                }else{
                    backGroudImageView.hidden = YES;
                }
                if (ocrSucessArray.count == 0&& _SegIndex == 0) {
                    backGroudImageView.hidden = NO;
                    remindLabel.hidden = NO;
                    remindLabel.text = NSLocalizedString(@"您还没有识别完成的报告\n请先上传报告", @"");
                    backGroudImageView.image = [UIImage imageNamed:@"no_hyd"];
                }else if (ocrProgressArray.count == 0&& _SegIndex == 1){
                    backGroudImageView.hidden = NO;
                    remindLabel.hidden = NO;
                    remindLabel.text = NSLocalizedString(@"您还没有识别中的报告\n请先上传报告", @"");
                    backGroudImageView.image = [UIImage imageNamed:@"no_hyd3"];
                }else if (ocrFailedArray.count == 0&& _SegIndex == 2){
                    backGroudImageView.hidden = NO;
                    remindLabel.hidden = NO;
                    remindLabel.text = NSLocalizedString(@"没有识别失败的报告", @"");
                    backGroudImageView.image = [UIImage imageNamed:@"no_hyd2"];
                }else{
                    backGroudImageView.hidden = YES;
                    remindLabel.hidden = YES;
                }
                [_ocrResultCollection reloadData];
                [hud hide:YES];
            }else{
                
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"WEB获取成功失败列表失败%@",error);
        }];
    }else{
        ocrSucessArray = [[WriteFileSupport ShareInstance]readArray:yizhenMineReportImage FileName:yizhenMineSucessReport];
        ocrProgressArray = [[WriteFileSupport ShareInstance]readArray:yizhenMineReportImage FileName:yizhenMineProgressReport];
        ocrFailedArray = [[WriteFileSupport ShareInstance]readArray:yizhenMineReportImage FileName:yizhenMineFailedReport];
        NSData *tempSucDetailData = [[WriteFileSupport ShareInstance]readData:yizhenMineReportImage FileName:yizhenMineSucessDetailReport];
        NSData *tempFailDetailData = [[WriteFileSupport ShareInstance]readData:yizhenMineReportImage FileName:yizhenMineFailedDetailReport];
        ocrSucessDetailArray = [NSKeyedUnarchiver unarchiveObjectWithData:tempSucDetailData];
        ocrFailedDetailArray = [NSKeyedUnarchiver unarchiveObjectWithData:tempFailDetailData];
        
        if (ocrSucessArray.count == 0) {
            backGroudImageView.hidden = NO;
            remindLabel.hidden = NO;
            backGroudImageView.image = [UIImage imageNamed:@"no_hyd"];
            remindLabel.text = NSLocalizedString(@"您还没有识别完成的报告\n请先上传报告", @"");
        }else{
            backGroudImageView.hidden = YES;
        }
        if (ocrSucessArray.count == 0&& _SegIndex == 0) {
            backGroudImageView.hidden = NO;
            remindLabel.hidden = NO;
            remindLabel.text = NSLocalizedString(@"您还没有识别完成的报告\n请先上传报告", @"");
            backGroudImageView.image = [UIImage imageNamed:@"no_hyd"];
        }else if (ocrProgressArray.count == 0&& _SegIndex == 1){
            backGroudImageView.hidden = NO;
            remindLabel.hidden = NO;
            remindLabel.text = NSLocalizedString(@"您还没有识别中的报告\n请先上传报告", @"");
            backGroudImageView.image = [UIImage imageNamed:@"no_hyd3"];
        }else if (ocrFailedArray.count == 0&& _SegIndex == 2){
            backGroudImageView.hidden = NO;
            remindLabel.hidden = NO;
            remindLabel.text = NSLocalizedString(@"没有识别失败的报告", @"");
            backGroudImageView.image = [UIImage imageNamed:@"no_hyd2"];
        }else{
            backGroudImageView.hidden = YES;
            remindLabel.hidden = YES;
        }
        [_ocrResultCollection reloadData];
        [hud hide:YES];
    }
}

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    _SegIndex = index;
    if (ocrSucessArray.count == 0&& _SegIndex == 0) {
        backGroudImageView.hidden = NO;
        remindLabel.hidden = NO;
        remindLabel.text = NSLocalizedString(@"您还没有识别完成的报告\n请先上传报告", @"");
        backGroudImageView.image = [UIImage imageNamed:@"no_hyd"];
    }else if (ocrProgressArray.count == 0&& _SegIndex == 1){
        backGroudImageView.hidden = NO;
        remindLabel.hidden = NO;
        remindLabel.text = NSLocalizedString(@"您还没有识别中的报告\n请先上传报告", @"");
        backGroudImageView.image = [UIImage imageNamed:@"no_hyd3"];
    }else if (ocrFailedArray.count == 0&& _SegIndex == 2){
        backGroudImageView.hidden = NO;
        remindLabel.hidden = NO;
        remindLabel.text = NSLocalizedString(@"没有识别失败的报告", @"");
        backGroudImageView.image = [UIImage imageNamed:@"no_hyd2"];
    }else{
        backGroudImageView.hidden = YES;
        remindLabel.hidden = YES;
    }
    [_ocrResultCollection reloadData];
}

@end
