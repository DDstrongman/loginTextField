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
//    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, ViewWidth-10, 21)];
//    remindLabel.text = NSLocalizedString(@"请输入病史", @"");
//    remindLabel.font = [UIFont systemFontOfSize:12.0];
//    [self.view addSubview:remindLabel];
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, ViewWidth, 300)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.borderColor = lightGrayBackColor.CGColor;
    inputView.layer.borderWidth = 0.5;
    [self.view addSubview:inputView];
    _inputText = [[UITextView alloc]initWithFrame:CGRectMake(15,8, ViewWidth-30, 300-8*2)];
    _inputText.backgroundColor = [UIColor whiteColor];
    _inputText.font = [UIFont systemFontOfSize:15.0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userHistoryNote"] != nil) {
        _inputText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHistoryNote"];
    }
    [_inputText becomeFirstResponder];
    [inputView addSubview:_inputText];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton setTitle:NSLocalizedString(@"保存", @"") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(saveNoteHistory:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance] setupNavigationRightButton:self RightButton:confirmButton];
}

-(void)setupData{
    
}

-(void)saveNoteHistory:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *diseaseTextID = [[_infoDic objectForKey:@"病史描述"] objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/symptom/%@?uid=%@&token=%@&value=%@",Baseurl,diseaseTextID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],_inputText.text];
    [[HttpManager ShareInstance] AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"上传修改成功");
            [user setObject:_inputText.text forKey:@"userHistoryNote"];
            [_diseaseDescribeDele changeDescribe:YES];
        }else{
            [_diseaseDescribeDele changeDescribe:NO];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_diseaseDescribeDele changeDescribe:NO];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

@end
