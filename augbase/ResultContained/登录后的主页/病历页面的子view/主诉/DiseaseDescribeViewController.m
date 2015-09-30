//
//  DiseaseDescribeViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/18.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "DiseaseDescribeViewController.h"

@interface DiseaseDescribeViewController ()

@end

@implementation DiseaseDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"病史描述", @"");
    self.view.backgroundColor = grayBackgroundLightColor;
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, ViewWidth-10, 21)];
    remindLabel.text = NSLocalizedString(@"请输入病史", @"");
    remindLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:remindLabel];
    _inputText = [[UITextView alloc]initWithFrame:CGRectMake(10, 35, ViewWidth-10, 300)];
    _inputText.backgroundColor = [UIColor whiteColor];
    _inputText.font = [UIFont systemFontOfSize:15.0];
    [_inputText becomeFirstResponder];
    [self.view addSubview:_inputText];
}

-(void)setupData{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *diseaseTextID = [[_infoDic objectForKey:@"病史描述"] objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%@",Baseurl,diseaseTextID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],_inputText.text];
    [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"上传修改成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
