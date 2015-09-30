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

-(void)setupView{
    self.title = NSLocalizedString(@"更改年龄", @"");
    self.view.backgroundColor = grayBackColor;
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ViewWidth-40, 20)];
    remindLabel.text = NSLocalizedString(@"请输入您的生日", @"");
    [self.view addSubview:remindLabel];
    agePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, ViewWidth, 300)];
    agePicker.datePickerMode = UIDatePickerModeDate;
    [agePicker addTarget:self action:@selector(selectBirthday:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:agePicker];
}

-(void)setupData{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSString *ageNumber = [NSString stringWithFormat:@"%ld",age];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ageNumber forKey:@"introduction"];
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
}

@end
