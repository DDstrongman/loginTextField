//
//  UserDiseaseTraitViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "UserDiseaseTraitViewController.h"

#import "CurrentSymptomViewController.h"
#import "DiseaseDescribeViewController.h"

@interface UserDiseaseTraitViewController ()

{
    NSMutableArray *firstTitleArray;
    NSMutableArray *secondTitleArray;
    NSMutableArray *thirdTitleArray;
    NSMutableArray *titleLabelArray;
    
    NSMutableArray *familyDiseaseHistoryArray;//如名，不会看么，逗比
    NSMutableArray *diseaseYearArray;
    NSMutableDictionary *diseaseYearDic;
    NSMutableArray *curePlanArray;
    NSMutableArray *stateArray;
    NSMutableArray *diseaseArray;
    
    UIView *bottomChooseView;//底部选择view
    UILabel *titleChooseLabel;//底部选择view的标题label
    UIPickerView *choosePicker;//选择框
    NSMutableArray *chooseArray;//选择的数据元数组
    NSInteger chooseIndex;//选择到了第几行
    
    NSInteger selectTrait;//选择病症的编号
    
    UIView *visualEffectView;//模糊的view
    
    NSDictionary *tempRelativeDic;//网络获取的数据
    NSDictionary *tempPlanDic;
    NSDictionary *tempSymptomDic;

    NSString *tempFirst;
    NSString *tempSecond;
    NSString *tempThird;
    
    int height;//身高
    int weight;//体重
    
    NSInteger indexRowPicker;//选择的序号
}

@end

@implementation UserDiseaseTraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
}

-(void)familyDiseaseHistory:(UISwitch *)sender{
    if ([sender isOn]) {
        NSLog(@"打开");
    }else{
        NSLog(@"关闭");
    }
}

-(void)diseaseTrait:(UISwitch *)sender{
    if (sender.tag == 0) {
        if ([sender isOn]) {
            NSLog(@"打开");
        }else{
            NSLog(@"关闭");
        }
    }else if (sender.tag == 1){
        if ([sender isOn]) {
            NSLog(@"打开");
        }else{
            NSLog(@"关闭");
        }
    }else if (sender.tag == 2){
        if ([sender isOn]) {
            NSLog(@"打开");
        }else{
            NSLog(@"关闭");
        }
    }else if (sender.tag == 3){
        if ([sender isOn]) {
            NSLog(@"打开");
        }else{
            NSLog(@"关闭");
        }
    }else if (sender.tag == 4){
        if ([sender isOn]) {
            NSLog(@"打开");
        }else{
            NSLog(@"关闭");
        }
    }
}

-(void)cancelChooseView:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomChooseView];
}

-(void)confirmChooseView:(UIButton *)sender{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (chooseIndex == 0) {
        chooseIndex = 1;
        titleChooseLabel.text = NSLocalizedString(@"请选择性别", @"");
         chooseArray = [@[@"男",@"女"]mutableCopy];
        [choosePicker reloadAllComponents];
    }else if (chooseIndex == 1){
        chooseIndex = 2;
        titleChooseLabel.text = NSLocalizedString(@"请选择身高", @"");
        chooseArray = [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]mutableCopy];
        [choosePicker reloadAllComponents];
    }else if (chooseIndex == 2){
        height = [titleChooseLabel.text floatValue];
        ((UITableViewCell *)[_diseaseTrait viewWithTag:886]).detailTextLabel.text = titleChooseLabel.text;
        NSString *heightID = [[[tempSymptomDic objectForKey:@"身高"] objectForKey:@"id"] stringValue];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%d",Baseurl,heightID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],height];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                [_diseaseTrait reloadData];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [self popSpringAnimationHidden:bottomChooseView];
//        chooseIndex = 3;
//        titleChooseLabel.text = NSLocalizedString(@"请选择体重", @"");
//        chooseArray = [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]mutableCopy];
//        [choosePicker reloadAllComponents];
    }else if(chooseIndex == 3){
        weight = [titleChooseLabel.text floatValue];
        chooseIndex = 2;
        ((UITableViewCell *)[_diseaseTrait viewWithTag:887]).detailTextLabel.text = titleChooseLabel.text;
        if (height != 0 &&weight != 0) {
            ((UITableViewCell *)[_diseaseTrait viewWithTag:888]).detailTextLabel.text = [NSString stringWithFormat:@"%d",weight/(height*height/10000)];
        }
        [self popSpringAnimationHidden:bottomChooseView];
        NSString *weightID = [[[tempSymptomDic objectForKey:@"体重"] objectForKey:@"id"] stringValue];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%d",Baseurl,weightID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],weight];
        [[HttpManager ShareInstance]AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                [_diseaseTrait reloadData];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        NSString *BMIID = [[[tempSymptomDic objectForKey:@"BMI"] objectForKey:@"id"] stringValue];
        float tempWeight = weight;
        float tempHeight = height;
        float BMI = tempWeight/(tempHeight*tempHeight/10000.00);
        NSString *tempBMI = [NSString stringWithFormat:@"%.2f",BMI];
        NSLog(@"bmi====%@",tempBMI);
        [[NSUserDefaults standardUserDefaults] setObject:tempBMI forKey:@"userBMI"];
        NSString *BMIurl = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%@",Baseurl,BMIID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],tempBMI];
        [[HttpManager ShareInstance]AFNetPUTSupport:BMIurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [_diseaseTrait reloadData];
    }else if(chooseIndex == 5){
        ((UITableViewCell *)[_diseaseTrait viewWithTag:881]).detailTextLabel.text = titleChooseLabel.text;
        NSString *familyDiseaseID = [[[tempSymptomDic objectForKey:@"有家族史"] objectForKey:@"id"] stringValue];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%ld",Baseurl,familyDiseaseID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],indexRowPicker];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//        titleChooseLabel.text = NSLocalizedString(@"肝功能异常年限", @"");
//        chooseIndex = 6;
//        chooseArray = diseaseYearArray;
//        [choosePicker reloadAllComponents];
        [self popSpringAnimationHidden:bottomChooseView];
        
    }else if (chooseIndex == 6){
        ((UITableViewCell *)[_diseaseTrait viewWithTag:882]).detailTextLabel.text = titleChooseLabel.text;
        NSString *diseaseYearID = [[[tempSymptomDic objectForKey:@"肝功能异常年限"] objectForKey:@"id"] stringValue];
        NSString *day;
        for (NSString *key in diseaseYearDic) {
            if ([[diseaseYearDic objectForKey:key] isEqualToString:diseaseYearArray[indexRowPicker]]) {
                day = key;
            }
        }
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%@",Baseurl,diseaseYearID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],day];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//        titleChooseLabel.text = NSLocalizedString(@"目前医生给的治疗方案", @"");
//        chooseIndex = 7;
//        chooseArray = curePlanArray;
//        [choosePicker reloadAllComponents];
        
        [self popSpringAnimationHidden:bottomChooseView];
        
    }else if (chooseIndex == 7){
        ((UITableViewCell *)[_diseaseTrait viewWithTag:883]).detailTextLabel.text = titleChooseLabel.text;
        NSString *curePlanID = [[[tempSymptomDic objectForKey:@"目前医生给的治疗方案"] objectForKey:@"id"] stringValue];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%ld",Baseurl,curePlanID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],indexRowPicker];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//        titleChooseLabel.text = NSLocalizedString(@"我(或我太太)妊娠与哺乳状态", @"");
//        chooseIndex = 8;
//        chooseArray = stateArray;
//        [choosePicker reloadAllComponents];
        
        [self popSpringAnimationHidden:bottomChooseView];
    }else if (chooseIndex == 8){
        ((UITableViewCell *)[_diseaseTrait viewWithTag:884]).detailTextLabel.text = titleChooseLabel.text;
        NSString *stateID = [[[tempSymptomDic objectForKey:@"我(或我太太)妊娠与哺乳状态"] objectForKey:@"id"] stringValue];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%ld",Baseurl,stateID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],indexRowPicker];
        [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"上传修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        tempRelativeDic = [source objectForKey:@"relativeInfo"];
                        tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
                        tempSymptomDic = [source objectForKey:@"symptom"];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//        chooseIndex = 2;
        [self popSpringAnimationHidden:bottomChooseView];
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"主诉", @"");
    _diseaseTrait = [[UITableView alloc]init];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _diseaseTrait.tableFooterView = headerView;
    _diseaseTrait.sectionHeaderHeight = 22.0;
    _diseaseTrait.backgroundColor = grayBackgroundLightColor;
    _diseaseTrait.delegate = self;
    _diseaseTrait.dataSource = self;
    _diseaseTrait.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_diseaseTrait];
    [_diseaseTrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(@0);
    }];
    [self setupBottomView];
}

-(void)setupBottomView{
    bottomChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 300)];
    bottomChooseView.backgroundColor = grayBackgroundLightColor;
    [self.view addSubview:bottomChooseView];
    
    titleChooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, ViewWidth-80-80, 30)];
    titleChooseLabel.text = NSLocalizedString(@"请选择年龄", @"");
    titleChooseLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *cancelChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    [cancelChooseButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelChooseButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelChooseButton addTarget:self action:@selector(cancelChooseView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-10-60, 10, 60, 30)];
    [confirmChooseButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmChooseButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmChooseButton addTarget:self action:@selector(confirmChooseView:) forControlEvents:UIControlEventTouchUpInside];
    
    choosePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 45, ViewWidth-20, 300-45-10)];
    choosePicker.delegate = self;
    choosePicker.dataSource = self;
    [bottomChooseView addSubview:titleChooseLabel];
    [bottomChooseView addSubview:cancelChooseButton];
    [bottomChooseView addSubview:confirmChooseButton];
    [bottomChooseView addSubview:choosePicker];
}

-(void)setupData{
    selectTrait = 999;
    chooseIndex = 2;
    
    tempFirst = @"0";
    tempSecond = @"0";
    tempThird = @"0";
    diseaseYearDic = [NSMutableDictionary dictionary];
    chooseArray = [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]mutableCopy];
    firstTitleArray = [@[NSLocalizedString(@"年龄", @""),NSLocalizedString(@"性别", @""),NSLocalizedString(@"身高(cm)", @""),NSLocalizedString(@"体重(kg)", @""),NSLocalizedString(@"BMI", @"")]mutableCopy];
    secondTitleArray = [@[NSLocalizedString(@"有家族史", @""),NSLocalizedString(@"肝功能异常年限", @""),NSLocalizedString(@"目前医生给的治疗方案", @""),NSLocalizedString(@"妊娠及哺乳状况", @"")]mutableCopy];
    familyDiseaseHistoryArray = [@[NSLocalizedString(@"家里没有人有乙肝", @""),NSLocalizedString(@"垂直传播（即父母）乙肝", @""),NSLocalizedString(@"水平传播（即兄弟姐妹）乙肝", @""),NSLocalizedString(@"只有父母、兄弟姐妹之外的亲戚有乙肝", @"")]mutableCopy];
    diseaseYearArray = [@[NSLocalizedString(@"0周", @""),NSLocalizedString(@"1周", @""),NSLocalizedString(@"2周", @""),NSLocalizedString(@"1 个月", @""),NSLocalizedString(@"2 个月", @""),NSLocalizedString(@"3 个月", @""),NSLocalizedString(@"半年", @""),NSLocalizedString(@"9 个月", @""),NSLocalizedString(@"1 年", @""),NSLocalizedString(@"2 年", @""),NSLocalizedString(@"3 年", @""),NSLocalizedString(@"4 年", @""),NSLocalizedString(@"5 年", @""),NSLocalizedString(@"7 年", @""),NSLocalizedString(@"10 年", @""),NSLocalizedString(@"15 年", @""),NSLocalizedString(@"20 年", @""),NSLocalizedString(@"30 年", @""),NSLocalizedString(@"40 年", @"")]mutableCopy];
    [diseaseYearDic setObject:diseaseYearArray[0] forKey:@"0"];
    [diseaseYearDic setObject:diseaseYearArray[1] forKey:@"7"];
    [diseaseYearDic setObject:diseaseYearArray[2] forKey:@"14"];
    [diseaseYearDic setObject:diseaseYearArray[3] forKey:@"31"];
    [diseaseYearDic setObject:diseaseYearArray[4] forKey:@"61"];
    [diseaseYearDic setObject:diseaseYearArray[5] forKey:@"91"];
    [diseaseYearDic setObject:diseaseYearArray[6] forKey:@"183"];
    [diseaseYearDic setObject:diseaseYearArray[7] forKey:@"274"];
    [diseaseYearDic setObject:diseaseYearArray[8] forKey:@"365"];
    [diseaseYearDic setObject:diseaseYearArray[9] forKey:@"730"];
    [diseaseYearDic setObject:diseaseYearArray[10] forKey:@"1095"];
    [diseaseYearDic setObject:diseaseYearArray[11] forKey:@"1460"];
    [diseaseYearDic setObject:diseaseYearArray[12] forKey:@"1825"];
    [diseaseYearDic setObject:diseaseYearArray[13] forKey:@"2555"];
    [diseaseYearDic setObject:diseaseYearArray[14] forKey:@"3650"];
    [diseaseYearDic setObject:diseaseYearArray[15] forKey:@"5475"];
    [diseaseYearDic setObject:diseaseYearArray[16] forKey:@"7300"];
    [diseaseYearDic setObject:diseaseYearArray[17] forKey:@"10950"];
    [diseaseYearDic setObject:diseaseYearArray[18] forKey:@"14600"];
    
    curePlanArray = [@[NSLocalizedString(@"无需治疗", @""),NSLocalizedString(@"抗病毒为主", @""),NSLocalizedString(@"抗纤维为主", @""),NSLocalizedString(@"保肝降酶为主", @""),NSLocalizedString(@"服用中药为主", @"")]mutableCopy];
    stateArray = [@[NSLocalizedString(@"暂无计划", @""),NSLocalizedString(@"正处备孕期", @""),NSLocalizedString(@"正处妊娠期（正怀孕）", @""),NSLocalizedString(@"正处哺乳期（宝宝刚出生不久）", @"")]mutableCopy];
    
    thirdTitleArray = [@[NSLocalizedString(@"现有症状", @""),NSLocalizedString(@"病史描述", @"")]mutableCopy];
    
    titleLabelArray = [@[NSLocalizedString(@"BMI指数太高容易得脂肪肝", @""),NSLocalizedString(@"现有症状:(治疗过程中的副作用症状处理非常重要)", @"")]mutableCopy];
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSLog(@"geturl ===%@",url);
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            tempRelativeDic = [source objectForKey:@"relativeInfo"];
            tempPlanDic =  [source objectForKey:@"pregnantPlanInfo"];
            tempSymptomDic = [source objectForKey:@"symptom"];
            [_diseaseTrait reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma delegate在最下方
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return firstTitleArray.count;
    }else if (section == 1){
        return secondTitleArray.count;
    }else{
        return thirdTitleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"collectionCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    
    UIImageView *tailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    tailImageView.image = [UIImage imageNamed:@"goin"];
    UIView *clearView = [[UIView alloc]init];
    if (indexPath.section == 0) {
        cell.textLabel.text = firstTitleArray[indexPath.row];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [user objectForKey:@"userAge"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 1){
            if ([[user objectForKey:@"userGender"] intValue] == 0) {
                cell.detailTextLabel.text = NSLocalizedString(@"男", @"");
            }else{
                cell.detailTextLabel.text = NSLocalizedString(@"女", @"");
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(indexPath.row == 2){
            cell.tag = 886;
            cell.accessoryView = clearView;
            [cell addSubview:tailImageView];
            [tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(@-15);
            }];
            height = [[[tempSymptomDic objectForKey:@"身高"] objectForKey:@"value"] intValue];
            cell.detailTextLabel.text = [[tempSymptomDic objectForKey:@"身高"] objectForKey:@"value"];
        }else if(indexPath.row == 3){
            cell.tag = 887;
            cell.accessoryView = clearView;
            [cell addSubview:tailImageView];
            [tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(@-15);
            }];
            weight = [[[tempSymptomDic objectForKey:@"体重"] objectForKey:@"value"] intValue];
            cell.detailTextLabel.text = [[tempSymptomDic objectForKey:@"体重"] objectForKey:@"value"];
        }else if (indexPath.row == 4){
            cell.tag = 888;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userBMI"]!=nil) {
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userBMI"];
            }
//            cell.detailTextLabel.text = [[tempSymptomDic objectForKey:@"BMI"] objectForKey:@"value"];
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = secondTitleArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.tag = 881;
            cell.detailTextLabel.text = familyDiseaseHistoryArray[[[[tempSymptomDic objectForKey:@"有家族史"] objectForKey:@"value"]intValue]];
        }else if (indexPath.row == 1) {
            cell.tag = 882;
            cell.detailTextLabel.text = [diseaseYearDic objectForKey:[[tempSymptomDic objectForKey:@"肝功能异常年限"] objectForKey:@"value"]];
        }else if (indexPath.row == 2){
            cell.tag = 883;
            if ([[[tempSymptomDic objectForKey:@"目前医生给的治疗方案"] objectForKey:@"value"] intValue]<curePlanArray.count) {
                cell.detailTextLabel.text = curePlanArray[[[[tempSymptomDic objectForKey:@"目前医生给的治疗方案"] objectForKey:@"value"] intValue]];
            }
        }else if (indexPath.row == 3){
            cell.tag = 884;
            if ([[[tempSymptomDic objectForKey:@"我(或我太太)妊娠与哺乳状态"] objectForKey:@"value"] intValue]<stateArray.count) {
                cell.detailTextLabel.text = stateArray[[[[tempSymptomDic objectForKey:@"我(或我太太)妊娠与哺乳状态"] objectForKey:@"value"] intValue]];
            }
        }
        cell.accessoryView = clearView;
        [cell addSubview:tailImageView];
        [tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(@-15);
        }];
    }else if (indexPath.section == 2){
        cell.textLabel.text = thirdTitleArray[indexPath.row];
        cell.accessoryView = clearView;
        [cell addSubview:tailImageView];
        [tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(@-15);
        }];
        if (indexPath.row == 0){
            cell.tag = 771;
            NSString *tempString = @"";
            int CountNumber = 0;
            for (NSString *key in diseaseArray) {
                if ([[[tempSymptomDic objectForKey:key] objectForKey:@"value"] intValue] == 1) {
                    if (CountNumber == 0) {
                        tempString = [[tempSymptomDic objectForKey:key] objectForKey:@"symptomname"];
                        CountNumber++;
                    }else if (CountNumber<3) {
                        tempString = [NSString stringWithFormat:@"%@,%@",tempString,[[tempSymptomDic objectForKey:key] objectForKey:@"symptomname"]];
                        CountNumber++;
                    }else{
                        tempString = [tempString stringByAppendingString:@"..."];
                        break;
                    }
                }
            }
            cell.detailTextLabel.text = tempString;
        }else{
            cell.tag = 772;
            cell.detailTextLabel.text = [[tempSymptomDic objectForKey:@"病史描述"] objectForKey:@"value"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        if(indexPath.row == 2){
            chooseIndex = 2;
            titleChooseLabel.text = NSLocalizedString(@"请选择身高", @"");
            chooseArray = [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]mutableCopy];
            [choosePicker reloadAllComponents];
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
        }else if(indexPath.row == 3){
            chooseIndex = 3;
            titleChooseLabel.text = NSLocalizedString(@"请选择体重", @"");
            chooseArray = [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]mutableCopy];
            [choosePicker reloadAllComponents];
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
        }else{
            
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
            chooseIndex = 5;
            titleChooseLabel.text = NSLocalizedString(@"家族病史情况", @"");
            chooseArray = familyDiseaseHistoryArray;
            [choosePicker reloadAllComponents];
        }else if (indexPath.row == 1){
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
            chooseIndex = 6;
            titleChooseLabel.text = NSLocalizedString(@"肝功能异常年限", @"");
            chooseArray = diseaseYearArray;
            [choosePicker reloadAllComponents];
        }else if (indexPath.row == 2){
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
            chooseIndex = 7;
            titleChooseLabel.text = NSLocalizedString(@"医生给的治疗方案", @"");
            chooseArray = curePlanArray;
            [choosePicker reloadAllComponents];
        }else if (indexPath.row == 3){
            [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
            chooseIndex = 8;
            titleChooseLabel.text = NSLocalizedString(@"妊娠和哺乳情况", @"");
            chooseArray = stateArray;
            [choosePicker reloadAllComponents];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CurrentSymptomViewController *cyv = [[CurrentSymptomViewController alloc]init];
            cyv.infoDic = tempSymptomDic;
            [self.navigationController pushViewController:cyv animated:YES];
        }else{
            DiseaseDescribeViewController *ddv = [[DiseaseDescribeViewController alloc]init];
            ddv.infoDic = tempSymptomDic;
            [self.navigationController pushViewController:ddv animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.layer.borderColor = lightGrayBackColor.CGColor;
    headerView.layer.borderWidth = 0.5;
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ViewWidth-15, 22)];
//    if (section != 0) {
//        titleLabel.text = titleLabelArray[section-1];
//    }
//    titleLabel.font = [UIFont systemFontOfSize:12.0];
//    titleLabel.textColor = grayLabelColor;
//    [headerView addSubview:titleLabel];
    return headerView;
}

#pragma pickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (chooseIndex == 2||chooseIndex == 3) {
        return 3;
    }else{
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return chooseArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return chooseArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        tempFirst = chooseArray[row];
    }else if (component ==1){
        tempSecond = chooseArray[row];
    }else{
        tempThird = chooseArray[row];
    }
    if (chooseIndex == 2||chooseIndex == 3) {
        titleChooseLabel.text = [NSString stringWithFormat:@"%@%@%@",tempFirst,tempSecond,tempThird];
    }else{
        titleChooseLabel.text = [NSString stringWithFormat:@"%@",tempFirst];
        indexRowPicker = row;
    }
}

#pragma 去头部粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 22;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    [self.view endEditing:YES];
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView ChooseOrInsert:(BOOL)chooseOrInsert{
    if (chooseIndex == 2||chooseIndex == 3) {
        [choosePicker selectRow:0 inComponent:0 animated:YES];
        [choosePicker selectRow:0 inComponent:1 animated:YES];
        [choosePicker selectRow:0 inComponent:2 animated:YES];
    }else{
        [choosePicker selectRow:0 inComponent:0 animated:YES];
    }
    visualEffectView = [[UIView alloc] init];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view insertSubview:visualEffectView belowSubview:bottomChooseView];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    if (chooseOrInsert) {
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-22-44-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    }else{
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,60,targetView.bounds.size.width,targetView.bounds.size.height)];
    }
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:bottomChooseView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [targetView pop_addAnimation:anim forKey:@"slider"];
    tempFirst = @"0";
    tempSecond = @"0";
    tempThird = @"0";
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
