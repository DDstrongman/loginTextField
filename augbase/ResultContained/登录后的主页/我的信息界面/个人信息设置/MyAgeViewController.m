//
//  MyAgeViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/22.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "MyAgeViewController.h"

@interface MyAgeViewController ()

{
    UIDatePicker *agePicker;//选择生日，算出年龄
    NSInteger age;//年龄
}

@end

@implementation MyAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)selectBirthday:(UIDatePicker *)sender{
    NSDate *select  = [sender date];
    NSDate *date  = [NSDate date];
    NSDate *startDate = select;
    NSDate *endDate = date;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    age = [components year];
}

-(void)editAge:(UIButton *)sender{
    NSString *ageNumber = [NSString stringWithFormat:@"%ld",age];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ageNumber forKey:@"age"];
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            [user setObject:ageNumber forKey:@"userAge"];
            [_updateAge UpdateAge:YES];
            NSLog(@"修改年龄完成");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    self.title = NSLocalizedString(@"您的出生年月", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    agePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, ViewWidth, 300)];
    agePicker.datePickerMode = UIDatePickerModeDate;
    [agePicker addTarget:self action:@selector(selectBirthday:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:agePicker];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton setTitle:NSLocalizedString(@"保存", @"") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(editAge:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:confirmButton];
}

-(void)setupData{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

@end
