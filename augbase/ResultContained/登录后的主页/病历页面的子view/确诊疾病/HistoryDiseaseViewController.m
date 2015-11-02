//
//  HistoryDiseaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "HistoryDiseaseViewController.h"
#import "LableCell.h"
#import "KRLCollectionViewGridLayout.h"

static NSString *historyCellIndentifyDisease = @"HistoryDiseaseCell";

@interface HistoryDiseaseViewController ()

{
    NSMutableArray *diseaseArray;//疾病总数数组
    NSMutableArray *diseaseConfirmArray;//存储对应疾病是否有的数组
    KRLCollectionViewGridLayout *lineLayout;//布局
    NSString *modifyString;//修改的字符串
}

@end

@implementation HistoryDiseaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

#pragma collectionview的delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return diseaseArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LableCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:historyCellIndentifyDisease forIndexPath:indexPath];
    cell.titleText.text = [diseaseArray[indexPath.row] objectForKey:@"name"];
    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = lightGrayBackColor.CGColor;
    
    if ([diseaseConfirmArray[indexPath.row] intValue] == 0) {
        cell.backgroundColor = lightGrayBackColor;
        cell.titleText.textColor = [UIColor blackColor];
    }else{
        cell.backgroundColor = themeColor;
        cell.titleText.textColor = [UIColor whiteColor];
    }
    [cell viewWithRadis:10.0];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了%ld",(long)indexPath.row);
    if ([diseaseConfirmArray[indexPath.row] intValue] == 0) {
        [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = themeColor;
        ((LableCell *)[collectionView cellForItemAtIndexPath:indexPath]).titleText.textColor = [UIColor whiteColor];
        [diseaseConfirmArray replaceObjectAtIndex:indexPath.row withObject:@1];
    }else{
        [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = lightGrayBackColor;
        ((LableCell *)[collectionView cellForItemAtIndexPath:indexPath]).titleText.textColor = [UIColor blackColor];
        [diseaseConfirmArray replaceObjectAtIndex:indexPath.row withObject:@0];
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"历史疾病", @"");
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(15,10,0,10);
    lineLayout.numberOfItemsPerLine = 2;
    lineLayout.interitemSpacing = 10;
    lineLayout.lineSpacing = 10;
    lineLayout.aspectRatio = 1.0/0.3;//长宽比例
    
    _historyDiseaseCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) collectionViewLayout:lineLayout];
    _historyDiseaseCollection.dataSource = self;
    _historyDiseaseCollection.delegate = self;
    _historyDiseaseCollection.backgroundColor = [UIColor whiteColor];
    _historyDiseaseCollection.alwaysBounceVertical = YES;
    [_historyDiseaseCollection registerClass:[LableCell class]forCellWithReuseIdentifier:historyCellIndentifyDisease];
    [self.view addSubview:_historyDiseaseCollection];
}

-(void)setupData{
    diseaseArray = [NSMutableArray array];
    diseaseConfirmArray = [NSMutableArray array];
    [[HttpManager ShareInstance]AFNetGETSupport:[NSString stringWithFormat:@"%@v2/disease/all?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]] Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSArray *allInfoArray = [source objectForKey:@"diseasesInfo"];
            for (NSDictionary *dic in allInfoArray) {
                if ([[dic objectForKey:@"type"] intValue] == 0) {
                    [diseaseArray addObject:dic];
                    [diseaseConfirmArray addObject:@0];
                }
            }
            [[HttpManager ShareInstance]AFNetGETSupport:[NSString stringWithFormat:@"%@und/list?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]] Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                int res = [[source objectForKey:@"res"] intValue];
                if (res == 0) {
                    NSArray *disListArray = [source objectForKey:@"disHisList"];
                    for (NSDictionary *dic in disListArray) {
                        NSInteger index = [[dic objectForKey:@"id"] integerValue]-1;
                        [diseaseConfirmArray replaceObjectAtIndex:index withObject:@1];
                    }
                    [_historyDiseaseCollection reloadData];
                }else{
                    UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"请检查您的网络", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                    [showMess show];
                }
            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            [_historyDiseaseCollection reloadData];
        }else{
            UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"请检查您的网络", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showMess show];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    for (int i=0;i<diseaseConfirmArray.count;i++) {
        if ([diseaseConfirmArray[i] intValue] == 1) {
            if (modifyString == nil) {
                modifyString = [NSString stringWithFormat:@"%d",i+1];
            }else{
                modifyString = [NSString stringWithFormat:@"%@_%d",modifyString,i+1];
            }
        }
    }
    [[HttpManager ShareInstance]AFNetPOSTSupport:[NSString stringWithFormat:@"%@und/edit?uid=%@&token=%@&category=%d&did=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],1,modifyString] Parameters:nil ConstructingBodyWithBlock:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"修改成功");
            [_hisDele historyDiseaseDelegate:YES];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
