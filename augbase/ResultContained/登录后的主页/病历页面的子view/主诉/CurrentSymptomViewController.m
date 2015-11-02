//
//  CurrentSymptomViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/18.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "CurrentSymptomViewController.h"

#import "LableCell.h"
#import "KRLCollectionViewGridLayout.h"

static NSString *cellIndentifyDisease = @"SymptomCell";

@interface CurrentSymptomViewController ()

{
    NSMutableArray *diseaseArray;//疾病总数数组
    NSMutableArray *diseaseIdArray;//病症ID数组
    NSMutableArray *diseaseConfirmArray;//存储对应疾病是否有的数组
    KRLCollectionViewGridLayout *lineLayout;//布局
    NSString *modifyString;//修改的字符串
}

@end

@implementation CurrentSymptomViewController

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
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifyDisease forIndexPath:indexPath];
    cell.titleText.text = diseaseArray[indexPath.row];
    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = lightGrayBackColor.CGColor;
    
    if ([diseaseConfirmArray[indexPath.row] intValue] == 0||[diseaseConfirmArray[indexPath.row] isEqualToString:@""]) {
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
        [diseaseConfirmArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = lightGrayBackColor;
        ((LableCell *)[collectionView cellForItemAtIndexPath:indexPath]).titleText.textColor = [UIColor blackColor];
        [diseaseConfirmArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"当前症状", @"");
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(15,10,0,10);
    lineLayout.numberOfItemsPerLine = 3;
    lineLayout.interitemSpacing = 10;
    lineLayout.lineSpacing = 10;
    lineLayout.aspectRatio = 1.0/0.4;//长宽比例
    
    _currentSymptomCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) collectionViewLayout:lineLayout];
    _currentSymptomCollection.dataSource = self;
    _currentSymptomCollection.delegate = self;
    _currentSymptomCollection.backgroundColor = [UIColor whiteColor];
    _currentSymptomCollection.alwaysBounceVertical = YES;
    [_currentSymptomCollection registerClass:[LableCell class]forCellWithReuseIdentifier:cellIndentifyDisease];
    [self.view addSubview:_currentSymptomCollection];
}

-(void)setupData{
    diseaseArray = [@[@"心情沮丧",
                      @"发热",
                      @"乏力",
                      @"肌痛",
                      @"头疼",
                      @"食欲减少",
                      @"牙龈出血",
                      @"关节痛",
                      @"脱发",
                      @"腹泻",
                      @"头晕",
                      @"失眠",
                      @"恶心",
                      @"过敏",
                      @"喉咙痛",
                      @"僵硬",
                      @"咳嗽",
                      @"瘙痒",
                      @"呼吸困难",
                      @"腹部疼痛",
                      @"背痛",]mutableCopy];
    diseaseIdArray = [NSMutableArray array];
    diseaseConfirmArray = [NSMutableArray array];
    for (NSString *key in diseaseArray) {
        [diseaseIdArray addObject:[[_infoDic objectForKey:key] objectForKey:@"id"]];
        [diseaseConfirmArray addObject:[[_infoDic objectForKey:key] objectForKey:@"value"]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    for (int i=0;i<diseaseIdArray.count;i++) {
        NSString *stateID = diseaseIdArray[i];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%@",Baseurl,stateID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],diseaseConfirmArray[i]];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
  
    }
}


@end
