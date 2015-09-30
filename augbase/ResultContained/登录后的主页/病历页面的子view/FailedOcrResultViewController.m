//
//  FailedOcrResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FailedOcrResultViewController.h"

@interface FailedOcrResultViewController ()

@end

@implementation FailedOcrResultViewController

#pragma 初始化各个信息，需要网络获取失败的原因种类和失败的原因详情
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [deleteButton setTitle:NSLocalizedString(@"删除", @"") forState:UIControlStateNormal];
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton addTarget:self action:@selector(deleteReport) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:deleteButton]];
    
    
    self.title = NSLocalizedString(@"识别失败", @"");
    _failedImageUrl = [_failedImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_failResultImageView sd_setImageWithURL:[NSURL URLWithString:_failedImageUrl] placeholderImage:[UIImage imageNamed:@"test"]];
    NSLog(@"此处需要网络获取失败原因种类和详情");
    NSString *failedCategory = @"网络获取中";
    NSString *failedDetail = @"网络获取中";
    if (_detailDic != nil) {
        failedCategory = [_detailDic objectForKey:@"content"];
        failedDetail = [_detailDic objectForKey:@"suggest"];
    }
    _failCategoryText.text = [NSString stringWithFormat:@"无法识别原因:%@",failedCategory];
    _failDetailText.text = [NSString stringWithFormat:@"建议:%@",failedDetail];
    [_cameraAgainButton addTarget:self action:@selector(cameraAgain:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma 此处要添加右侧删除按钮响应函数
-(void)deleteReport{
    NSLog(@"此处要添加右侧删除按钮响应函数");
}

-(void)cameraAgain:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
